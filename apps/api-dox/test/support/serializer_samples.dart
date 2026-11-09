import 'package:api_dox/app/models/models.dart';

/// Fixed rows for `test/serializer_test.dart`. They cover each null and
/// non-null case that changes the JSON (pending member, bought item,
/// expense without a category, entry without an expense).
class SerializerSamples {
  static const String ts = '2026-01-02 03:04:05';

  static final User user = User()
    ..id = 1
    ..firebaseUid = 'uid-1'
    ..email = 'a@b.co'
    ..displayName = 'Ann'
    ..photoUrl = null
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final Group group = Group()
    ..id = 2
    ..name = 'Home'
    ..currency = 'THB'
    ..createdByUserId = null
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final GroupMember joined = GroupMember()
    ..id = 3
    ..groupId = 2
    ..userId = 1
    ..email = 'a@b.co'
    ..invitedByUserId = null
    ..joinedAt = ts
    ..defaultAccountId = 9
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final GroupMember pending = GroupMember()
    ..id = 4
    ..groupId = 2
    ..userId = null
    ..email = 'c@d.co'
    ..invitedByUserId = 1
    ..joinedAt = null
    ..defaultAccountId = null
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final Category category = Category()
    ..id = 5
    ..groupId = 2
    ..name = 'Food'
    ..slug = 'food'
    ..iconKey = 'utensils'
    ..color = '#ff0000'
    ..createdAtText = ts;

  static final ShoppingItem open = ShoppingItem()
    ..id = 6
    ..groupId = 2
    ..name = 'Milk'
    ..doneAt = null
    ..createdByUserId = 1
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final ShoppingItem done = ShoppingItem()
    ..id = 7
    ..groupId = 2
    ..name = 'Eggs'
    ..doneAt = '2026-01-03 10:00:00'
    ..createdByUserId = null
    ..createdAtText = ts
    ..updatedAtText = '2026-01-03 10:00:00';

  static final Expense expense = Expense()
    ..id = 8
    ..groupId = 2
    ..createdByUserId = 1
    ..categoryId = 5
    ..amountCents = 1250
    ..occurredOn = '2026-01-02'
    ..note = 'lunch'
    ..createdAtText = ts
    ..updatedAtText = '2026-01-02 03:04:06';

  static final Expense bare = Expense()
    ..id = 9
    ..groupId = 2
    ..createdByUserId = null
    ..categoryId = null
    ..amountCents = 99
    ..occurredOn = '2026-01-03'
    ..note = null
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final Account account = Account()
    ..id = 10
    ..userId = 1
    ..name = 'Cash'
    ..currency = 'THB'
    ..color = '#00ff00'
    ..includeInTotal = false
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final AccountEntry spend = AccountEntry()
    ..id = 11
    ..accountId = 10
    ..expenseId = 8
    ..amountCents = -1250
    ..occurredOn = '2026-01-02'
    ..note = 'lunch'
    ..createdAtText = ts
    ..updatedAtText = ts;

  static final AccountEntry topUp = AccountEntry()
    ..id = 12
    ..accountId = 10
    ..expenseId = null
    ..amountCents = 5000
    ..occurredOn = '2026-01-04'
    ..note = null
    ..createdAtText = '2026-01-04 00:00:00'
    ..updatedAtText = '2026-01-04 00:00:00';
}
