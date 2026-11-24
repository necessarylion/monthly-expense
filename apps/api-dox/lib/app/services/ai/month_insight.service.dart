import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/app/services/file_cache.dart';
import 'package:api_dox/constants/ai.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/money_util.dart';
import 'package:api_dox/utils/month_util.dart';
import 'package:dox_core/dox_core.dart';

/// "Explain my month": the month's numbers, with a short summary and tips
/// that Claude writes. The web app draws the screen
/// (`month-insight-sheet.tsx`); Claude never writes a number the app shows.
///
/// Claude's words are kept in the file cache with a fingerprint of what
/// Claude saw. Opening the sheet again costs nothing until an expense, the
/// budget, the language or the prompt changes.
// ponytail: two isolates can ask Claude for the same month at once; add a cache lock if that costs too much.
@Inject()
class MonthInsightService {
  MonthInsightService(this.expenses, this.categories, this.claude, this.cache);

  final ExpenseService expenses;
  final CategoryService categories;
  final ClaudeClient claude;
  final FileCache cache;

  /// `{facts, summary, tips}`: the numbers of [_facts] and Claude's words.
  Future<Map<String, Object?>> explain(
    Group group,
    MonthRange month,
    String lang,
  ) async {
    Map<String, Object?> facts = await _facts(group, month, lang);
    String prompt = jsonEncode(facts);
    String key = 'insight-${group.id}-${month.key}-$lang';
    String fingerprint = sha256
        .convert(utf8.encode('$insightSystemPrompt\n$prompt'))
        .toString();
    Object? stored = (await cache.read(key))?.value;
    Map<String, Object?>? words =
        stored is Map && stored['fingerprint'] == fingerprint
        ? _words(stored)
        : null;
    if (words == null) {
      words = _words(
        await claude.askJson(
          system: insightSystemPrompt,
          prompt: prompt,
          schema: insightSchema,
        ),
      );
      if (words == null) {
        throw HttpError.badGateway('Could not explain the month. Try again.');
      }
      await cache.write(key, <String, Object?>{
        'fingerprint': fingerprint,
        ...words,
      });
    }
    return <String, Object?>{'facts': facts, ...words};
  }

  /// The summary and tips of [raw] (Claude's answer, or the cached one), or
  /// null when it is not usable.
  static Map<String, Object?>? _words(Object? raw) {
    if (raw is! Map) return null;
    Object? summary = raw['summary'];
    Object? tips = raw['tips'];
    if (summary is! String || summary.trim().isEmpty || tips is! List) {
      return null;
    }
    return <String, Object?>{
      'summary': summary.trim(),
      'tips': <String>[
        for (Object? tip in tips)
          if (tip is String && tip.trim().isNotEmpty) tip.trim(),
      ].take(insightMaxTips).toList(),
    };
  }

  /// What Claude sees and the app shows: the month's totals, by category, and the biggest
  /// expenses. Money is in currency units, not cents.
  Future<Map<String, Object?>> _facts(
    Group group,
    MonthRange month,
    String lang,
  ) async {
    MonthlySummary summary = await expenses.summary(group, month);
    Map<int, Category> names = await categories.mapForGroup(group);
    List<ExpenseWithCategory> rows = await expenses.listForMonth(group, month);
    // Ties by id, so the same month always gives the same fingerprint.
    rows.sort((ExpenseWithCategory a, ExpenseWithCategory b) {
      int byAmount = b.expense.amountCents.compareTo(a.expense.amountCents);
      return byAmount != 0 ? byAmount : a.expense.id!.compareTo(b.expense.id!);
    });
    int? budget = summary.monthlyBudgetCents;
    int total = summary.totalCents;
    return <String, Object?>{
      'language': lang == 'my' ? 'Burmese' : 'English',
      'month': summary.month,
      'currency': group.currency,
      'total': MoneyUtil.fromCents(summary.totalCents),
      'expenseCount': summary.count,
      'budget': budget == null ? null : MoneyUtil.fromCents(budget),
      'budgetUsedPercent': budget == null || budget == 0
          ? null
          : _percent(total, budget),
      'budgetLeft': budget == null ? null : MoneyUtil.fromCents(budget - total),
      'byCategory': <Map<String, Object?>>[
        for (CategoryTotal row in summary.byCategory)
          <String, Object?>{
            'categoryId': row.categoryId,
            'category': names[row.categoryId]?.name ?? 'No category',
            'total': MoneyUtil.fromCents(row.totalCents),
            'shareOfTotalPercent': total == 0
                ? 0
                : _percent(row.totalCents, total),
            'count': row.count,
          },
      ],
      'biggestExpenses': <Map<String, Object?>>[
        for (ExpenseWithCategory row in rows.take(insightTopExpenses))
          <String, Object?>{
            'note': row.expense.note,
            'amount': MoneyUtil.fromCents(row.expense.amountCents),
            'date': row.expense.occurredOn,
            'categoryId': row.category?.id,
            'category': row.category?.name,
          },
      ],
    };
  }

  /// [part] of [whole], as a whole percent.
  static int _percent(int part, int whole) => (part * 100 / whole).round();
}
