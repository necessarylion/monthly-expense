import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account.repository.dart';
import 'package:api_dox/app/repositories/account_entry.repository.dart';
import 'package:api_dox/app/repositories/account_member.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/constants/live.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_socketio/dox_socketio.dart';

/// Tells the open apps that data changed, over Socket.IO. Each socket of a
/// user is in the room `user:<id>` (see `LiveNamespace`). An event holds
/// only the topic, never the data: the app loads it again through the API,
/// so the access checks stay in one place.
///
/// No method here throws. A failed lookup or send is logged, and never
/// fails the write that caused it (that write is already saved).
@Inject()
class LiveService {
  LiveService(
    this.groupMembers,
    this.accounts,
    this.accountMembers,
    this.entries,
  );

  final GroupMemberRepository groupMembers;
  final AccountRepository accounts;
  final AccountMemberRepository accountMembers;
  final AccountEntryRepository entries;

  static String roomOf(int userId) => 'user:$userId';

  /// Data of [groupId] changed: tell its members.
  Future<void> groupChanged(int groupId, String topic) async {
    await notify(await usersOfGroup(groupId), topic, groupId: groupId);
  }

  /// An account or its entries changed: tell the owner and the members.
  Future<void> accountChanged(int accountId) async {
    await notify(await usersOfAccount(accountId), liveTopicAccounts);
  }

  /// An expense changed: tell the group, and the users of the wallet it is
  /// booked in ([accountId], from [accountOfExpense]).
  Future<void> expenseChanged(int groupId, int? accountId) async {
    await groupChanged(groupId, liveTopicExpenses);
    if (accountId != null) await accountChanged(accountId);
  }

  /// Exchange rates are new: tell everyone.
  Future<void> ratesChanged() async {
    try {
      await SocketIoProvider.server?.emit(liveEvent, <String, Object>{
        'topic': liveTopicRates,
      });
    } catch (error) {
      Logger.warn('[live] rates: $error');
    }
  }

  /// Sends [topic] to [users]. For a delete, find the users before the
  /// rows are gone, then call this.
  Future<void> notify(Set<int> users, String topic, {int? groupId}) async {
    SocketIoServer? io = SocketIoProvider.server;
    if (io == null || users.isEmpty) return;
    try {
      BroadcastOperator to = io.to(roomOf(users.first));
      for (int user in users.skip(1)) {
        to = to.to(roomOf(user));
      }
      await to.emit(liveEvent, <String, Object>{
        'topic': topic,
        'groupId': ?groupId,
      });
    } catch (error) {
      Logger.warn('[live] $topic: $error');
    }
  }

  /// The joined members of a group. Empty on error.
  Future<Set<int>> usersOfGroup(int groupId) async {
    try {
      return <int>{
        for (GroupMember m in await groupMembers.listByGroup(groupId))
          if (m.userId != null && m.joinedAt != null) m.userId!,
      };
    } catch (error) {
      Logger.warn('[live] members of group $groupId: $error');
      return <int>{};
    }
  }

  /// The owner and the joined members of an account. Empty on error.
  Future<Set<int>> usersOfAccount(int accountId) async {
    try {
      Account? account = await accounts.findById(accountId);
      if (account == null) return <int>{};
      return <int>{
        account.userId,
        for (AccountMember m in await accountMembers.listByAccount(accountId))
          if (m.userId != null && m.joinedAt != null) m.userId!,
      };
    } catch (error) {
      Logger.warn('[live] users of account $accountId: $error');
      return <int>{};
    }
  }

  /// The account an expense is booked in, or null. Null on error.
  Future<int?> accountOfExpense(int expenseId) async {
    try {
      return (await entries.findByExpenseId(expenseId))?.accountId;
    } catch (error) {
      Logger.warn('[live] account of expense $expenseId: $error');
      return null;
    }
  }
}
