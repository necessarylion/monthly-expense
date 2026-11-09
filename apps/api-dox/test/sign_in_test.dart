import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/account_member.repository.dart';
import 'package:api_dox/app/repositories/group_member.repository.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/group.service.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Sign-in: one query for a known user, invites only when they can be new.
void main() {
  late TestApp app;

  setUpAll(() async {
    app = await TestApp.start();
  });

  tearDownAll(() async {
    await app.close();
  });

  test(
    'a new email (any case) is saved lowercase and claims its invites',
    () async {
      UserService users = Dox().ioc.get<UserService>();
      User user = await users.findOrCreate(
        const FirebaseIdentity(uid: 'mover', email: 'old@gmail.com'),
      );
      int groupId =
          (await app.call('/api/v1/groups')).json['data'][0]['id'] as int;
      (await app.call(
        '/api/v1/groups/$groupId/invitations',
        method: 'POST',
        body: <String, dynamic>{'email': 'new@gmail.com'},
      )).expectStatus(201);

      User moved = await users.findOrCreate(
        const FirebaseIdentity(uid: 'mover', email: 'New@Gmail.com'),
      );
      expect(moved.id, user.id);
      expect(moved.email, 'new@gmail.com');
      List<Group> groups = await Dox().ioc.get<GroupService>().listForUser(
        moved,
      );
      expect(groups.map((Group g) => g.id), contains(groupId));
    },
  );

  test('leaving the last group gives a new personal group', () async {
    TestResponse list = await app.call('/api/v1/groups', user: 'leaver');
    int id = list.json['data'][0]['id'] as int;
    (await app.call(
      '/api/v1/groups/$id/membership',
      user: 'leaver',
      method: 'DELETE',
    )).expectStatus(204);

    TestResponse after = await app.call('/api/v1/groups', user: 'leaver');
    List<dynamic> groups = after.json['data'] as List<dynamic>;
    expect(groups, hasLength(1));
    expect(groups[0]['id'], isNot(id));
  });

  test('the group and wallet lists claim an invite sign-in missed', () async {
    // a known user (lowercase email), then old pending rows for that email
    await app.call('/api/v1/me', user: 'late');
    int groupId =
        (await app.call('/api/v1/groups')).json['data'][0]['id'] as int;
    TestResponse wallet = await app.call(
      '/api/v1/accounts',
      method: 'POST',
      body: <String, dynamic>{
        'name': 'Joint',
        'currency': 'THB',
        'color': '#3b82f6',
      },
    );
    int walletId = wallet.json['data']['id'] as int;
    await Dox().ioc.get<GroupMemberRepository>().create(
      groupId: groupId,
      userId: null,
      email: 'late@gmail.com',
      invitedByUserId: null,
      joinedAt: null,
    );
    await Dox().ioc.get<AccountMemberRepository>().create(
      accountId: walletId,
      userId: null,
      email: 'late@gmail.com',
      invitedByUserId: null,
      joinedAt: null,
    );

    List<dynamic> groups =
        (await app.call('/api/v1/groups', user: 'late')).json['data']
            as List<dynamic>;
    expect(<dynamic>[for (dynamic g in groups) g['id']], contains(groupId));
    List<dynamic> wallets =
        (await app.call('/api/v1/accounts', user: 'late')).json['data']
            as List<dynamic>;
    expect(<dynamic>[for (dynamic w in wallets) w['id']], contains(walletId));
  });
}
