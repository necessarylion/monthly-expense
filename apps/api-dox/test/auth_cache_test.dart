import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/firebase.service.dart';
import 'package:api_dox/app/services/user.service.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_core/testing.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

/// Sign-in keeps the user in memory for a short time.
void main() {
  late TestApp app;

  setUpAll(() async {
    app = await TestApp.start();
  });

  tearDownAll(() async {
    await app.close();
  });

  test('a seen user comes from memory; a new name is still saved', () async {
    UserService users = Dox().ioc.get<UserService>();
    FirebaseIdentity first = const FirebaseIdentity(
      uid: 'cache',
      email: 'cache@gmail.com',
      name: 'Old',
    );
    User a = await users.findOrCreate(first);
    User b = await users.findOrCreate(first);
    expect(identical(a, b), isTrue);

    User renamed = await users.findOrCreate(
      const FirebaseIdentity(
        uid: 'cache',
        email: 'cache@gmail.com',
        name: 'New',
      ),
    );
    expect(renamed.displayName, 'New');
    expect(identical(renamed, a), isFalse);
  });

  test('leaving the last group gives a new personal group', () async {
    TestResponse list = await app.call('/api/v1/groups', user: 'leaver');
    int id = list.json['data'][0]['id'] as int;
    (await app.call(
      '/api/v1/groups/$id/membership',
      user: 'leaver',
      method: 'DELETE',
    )).expectStatus(204);

    // the sign-in result is cached, so /groups itself makes the new group
    TestResponse after = await app.call('/api/v1/groups', user: 'leaver');
    List<dynamic> groups = after.json['data'] as List<dynamic>;
    expect(groups, hasLength(1));
    expect(groups[0]['id'], isNot(id));
  });
}
