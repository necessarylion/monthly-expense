import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account.repository.dart';
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
/// A failed send is logged and never fails the write that caused it.
@Inject()
class LiveService {
  LiveService(this.groupMembers, this.accounts, this.accountMembers);

  final GroupMemberRepository groupMembers;
  final AccountRepository accounts;
  final AccountMemberRepository accountMembers;

  static String roomOf(int userId) => 'user:$userId';

  /// Expenses or shopping items of [groupId] changed: tell its members.
  Future<void> groupChanged(int groupId, String topic) async {
    try {
      Set<int> users = <int>{
        for (GroupMember m in await groupMembers.listByGroup(groupId))
          if (m.userId != null && m.joinedAt != null) m.userId!,
      };
      await _emit(users, <String, Object>{'topic': topic, 'groupId': groupId});
    } catch (error) {
      Logger.warn('[live] group $groupId $topic: $error');
    }
  }

  /// An account or its entries changed: tell the owner and the members.
  Future<void> accountChanged(int accountId) async {
    try {
      await _emit(await usersOfAccount(accountId), <String, Object>{
        'topic': liveTopicAccounts,
      });
    } catch (error) {
      Logger.warn('[live] account $accountId: $error');
    }
  }

  /// Like [accountChanged], for users found before the account was gone.
  Future<void> usersChanged(Set<int> users, String topic) async {
    try {
      await _emit(users, <String, Object>{'topic': topic});
    } catch (error) {
      Logger.warn('[live] $topic: $error');
    }
  }

  /// The owner and the joined members of an account.
  Future<Set<int>> usersOfAccount(int accountId) async {
    Account? account = await accounts.findById(accountId);
    if (account == null) return <int>{};
    return <int>{
      account.userId,
      for (AccountMember m in await accountMembers.listByAccount(accountId))
        if (m.userId != null && m.joinedAt != null) m.userId!,
    };
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

  Future<void> _emit(Set<int> users, Map<String, Object> data) async {
    SocketIoServer? io = SocketIoProvider.server;
    if (io == null || users.isEmpty) return;
    BroadcastOperator to = io.to(roomOf(users.first));
    for (int user in users.skip(1)) {
      to = to.to(roomOf(user));
    }
    await to.emit(liveEvent, data);
  }
}
