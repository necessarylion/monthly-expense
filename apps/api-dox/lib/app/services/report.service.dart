import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/app/repositories/user.repository.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';

/// Totals for one year: per month and per category.
class YearlySummary {
  final int year;
  final int totalCents;
  final int count;

  /// Always 12 rows, January first.
  final List<Map<String, dynamic>> months;
  final List<CategoryTotal> byCategory;

  const YearlySummary({
    required this.year,
    required this.totalCents,
    required this.count,
    required this.months,
    required this.byCategory,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'year': year,
      'totalCents': totalCents,
      'count': count,
      'months': months,
      'byCategory': <Map<String, dynamic>>[
        for (CategoryTotal row in byCategory) row.toJson(),
      ],
    };
  }
}

/// One person in a month's split.
class MemberBalance {
  final int userId;
  final String email;
  int paidCents = 0;
  int shareCents = 0;

  MemberBalance(this.userId, this.email);

  /// Positive: the others owe them. Negative: they owe.
  int get netCents => paidCents - shareCents;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'paidCents': paidCents,
      'shareCents': shareCents,
      'netCents': netCents,
    };
  }
}

/// One payment that settles part of the month.
class SettleTransfer {
  final int fromUserId;
  final int toUserId;
  final int amountCents;

  const SettleTransfer(this.fromUserId, this.toUserId, this.amountCents);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amountCents': amountCents,
    };
  }
}

class MonthBalances {
  final String month;
  final int totalCents;
  final List<MemberBalance> members;
  final List<SettleTransfer> transfers;

  const MonthBalances(
    this.month,
    this.totalCents,
    this.members,
    this.transfers,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'month': month,
      'totalCents': totalCents,
      'members': <Map<String, dynamic>>[
        for (MemberBalance row in members) row.toJson(),
      ],
      'transfers': <Map<String, dynamic>>[
        for (SettleTransfer row in transfers) row.toJson(),
      ],
    };
  }
}

/// Read-only reports over a group's expenses.
@Inject()
class ReportService {
  ReportService(this.expenses, this.members, this.users);

  final ExpenseRepository expenses;
  final GroupMemberRepository members;
  final UserRepository users;

  Future<YearlySummary> yearly(Group group, int year) async {
    List<Expense> rows = await expenses.listInRange(
      group.id!,
      '$year-01-01',
      '$year-12-31',
    );
    List<int> monthTotals = List<int>.filled(12, 0);
    Map<int?, CategoryTotal> byCategory = <int?, CategoryTotal>{};
    int totalCents = 0;
    for (Expense expense in rows) {
      totalCents += expense.amountCents;
      monthTotals[int.parse(expense.occurredOn.substring(5, 7)) - 1] +=
          expense.amountCents;
      CategoryTotal row = byCategory.putIfAbsent(
        expense.categoryId,
        () => CategoryTotal(expense.categoryId),
      );
      row.totalCents += expense.amountCents;
      row.count += 1;
    }
    List<CategoryTotal> sorted = byCategory.values.toList();
    ExpenseService.stableSortByTotalDesc(sorted);
    return YearlySummary(
      year: year,
      totalCents: totalCents,
      count: rows.length,
      months: <Map<String, dynamic>>[
        for (int i = 0; i < 12; i++)
          <String, dynamic>{
            'month': '$year-${(i + 1).toString().padLeft(2, '0')}',
            'totalCents': monthTotals[i],
          },
      ],
      byCategory: sorted,
    );
  }

  /// Who paid what in the month, and who owes whom. The payer is the
  /// owner of the wallet it was paid from, else who added it. Every joined member
  /// shares the month equally. Someone who paid but has left the group
  /// has no share, so they get their money back.
  Future<MonthBalances> balances(Group group, MonthRange month) async {
    month = MonthUtil.forGroup(group.isTrip, month);
    Map<int, MemberBalance> byUser = <int, MemberBalance>{};
    List<MemberBalance> sharers = <MemberBalance>[];
    for (GroupMember member in await members.listByGroup(group.id!)) {
      if (member.userId == null || member.joinedAt == null) continue;
      MemberBalance row = MemberBalance(member.userId!, member.email);
      byUser[member.userId!] = row;
      sharers.add(row);
    }

    int totalCents = 0;
    List<Expense> rows = await expenses.listInRange(
      group.id!,
      month.start,
      month.end,
    );
    await expenses.attachWalletOwners(rows);
    for (Expense expense in rows) {
      int? payer = expense.payerId;
      // A deleted user: nobody to pay back, so leave it out.
      if (payer == null) continue;
      totalCents += expense.amountCents;
      MemberBalance? row = byUser[payer];
      if (row == null) {
        User? user = await users.findById(payer);
        row = MemberBalance(payer, user?.email ?? '');
        byUser[payer] = row;
      }
      row.paidCents += expense.amountCents;
    }

    // Equal shares; the first members take the leftover cents.
    if (sharers.isNotEmpty) {
      int each = totalCents ~/ sharers.length;
      int extra = totalCents - each * sharers.length;
      for (int i = 0; i < sharers.length; i++) {
        sharers[i].shareCents = each + (i < extra ? 1 : 0);
      }
    }

    List<MemberBalance> list = byUser.values.toList();
    return MonthBalances(month.key, totalCents, list, settle(list));
  }

  /// Fewest simple payments: the biggest debtor pays the biggest creditor,
  /// again and again. Not always the fewest possible, but close and clear.
  static List<SettleTransfer> settle(List<MemberBalance> rows) {
    List<List<int>> owes = <List<int>>[
      for (MemberBalance row in rows)
        if (row.netCents < 0) <int>[row.userId, -row.netCents],
    ];
    List<List<int>> gets = <List<int>>[
      for (MemberBalance row in rows)
        if (row.netCents > 0) <int>[row.userId, row.netCents],
    ];
    List<SettleTransfer> out = <SettleTransfer>[];
    while (owes.isNotEmpty && gets.isNotEmpty) {
      owes.sort(_byAmountDesc);
      gets.sort(_byAmountDesc);
      List<int> from = owes.first;
      List<int> to = gets.first;
      int amount = from[1] < to[1] ? from[1] : to[1];
      out.add(SettleTransfer(from[0], to[0], amount));
      from[1] -= amount;
      to[1] -= amount;
      if (from[1] == 0) owes.removeAt(0);
      if (to[1] == 0) gets.removeAt(0);
    }
    return out;
  }

  static int _byAmountDesc(List<int> a, List<int> b) => b[1].compareTo(a[1]);
}
