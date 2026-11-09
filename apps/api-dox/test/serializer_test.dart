import 'dart:convert';

import 'package:api_dox/app/serializers/account.serializer.dart';
import 'package:api_dox/app/serializers/account_entry.serializer.dart';
import 'package:api_dox/app/serializers/category.serializer.dart';
import 'package:api_dox/app/serializers/expense.serializer.dart';
import 'package:api_dox/app/serializers/group.serializer.dart';
import 'package:api_dox/app/serializers/group_member.serializer.dart';
import 'package:api_dox/app/serializers/shopping_item.serializer.dart';
import 'package:api_dox/app/serializers/user.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:test/test.dart';

import 'support/serializer_samples.dart';

/// The web app reads these exact strings: every key, its order,
/// null against missing, and the date format. The expected text was taken
/// from the old hand-written `Serialize` class. Change it only together
/// with the clients.
void main() {
  group('serializers', () {
    test('user (GET /me)', () {
      expectJson(
        UserSerializer(SerializerSamples.user).toJson(),
        r'{"id":1,"firebaseUid":"uid-1","email":"a@b.co","displayName":"Ann","photoUrl":null}',
      );
    });

    test('group', () {
      expectJson(
        GroupSerializer(SerializerSamples.group).toJson(),
        r'{"id":2,"name":"Home","currency":"THB","createdByUserId":null}',
      );
    });

    test('group member, joined and pending', () {
      expectJson(
        GroupMemberSerializer(SerializerSamples.joined).toJson(),
        r'{"id":3,"groupId":2,"userId":1,"email":"a@b.co","invitedByUserId":null,"joinedAt":"2026-01-02T03:04:05.000Z","pending":false}',
      );
      expectJson(
        GroupMemberSerializer(SerializerSamples.pending).toJson(),
        r'{"id":4,"groupId":2,"userId":null,"email":"c@d.co","invitedByUserId":1,"joinedAt":null,"pending":true}',
      );
    });

    test('category', () {
      expectJson(
        CategorySerializer(SerializerSamples.category).toJson(),
        r'{"id":5,"groupId":2,"name":"Food","slug":"food","iconKey":"utensils","color":"#ff0000","createdAt":"2026-01-02T03:04:05.000Z"}',
      );
    });

    test('shopping item, open and done', () {
      expectJson(
        ShoppingItemSerializer(<ShoppingItem>[
          SerializerSamples.open,
          SerializerSamples.done,
        ]).toJson(),
        r'[{"id":6,"groupId":2,"name":"Milk","done":false,"doneAt":null,"createdByUserId":1,"createdAt":"2026-01-02T03:04:05.000Z"},{"id":7,"groupId":2,"name":"Eggs","done":true,"doneAt":"2026-01-03T10:00:00.000Z","createdByUserId":null,"createdAt":"2026-01-02T03:04:05.000Z"}]',
      );
    });

    test('expense, with and without a category', () {
      expectJson(
        ExpenseSerializer(
          ExpenseWithCategory(
            SerializerSamples.expense,
            SerializerSamples.category,
          ),
        ).toJson(),
        r'{"id":8,"groupId":2,"createdByUserId":1,"categoryId":5,"amountCents":1250,"occurredOn":"2026-01-02","note":"lunch","createdAt":"2026-01-02T03:04:05.000Z","updatedAt":"2026-01-02T03:04:06.000Z","category":{"id":5,"groupId":2,"name":"Food","slug":"food","iconKey":"utensils","color":"#ff0000","createdAt":"2026-01-02T03:04:05.000Z"}}',
      );
      expectJson(
        ExpenseSerializer(ExpenseWithCategory(SerializerSamples.bare, null))
            .toJson(),
        r'{"id":9,"groupId":2,"createdByUserId":null,"categoryId":null,"amountCents":99,"occurredOn":"2026-01-03","note":null,"createdAt":"2026-01-02T03:04:05.000Z","updatedAt":"2026-01-02T03:04:05.000Z","category":null}',
      );
    });

    test('account', () {
      expectJson(
        AccountSerializer(SerializerSamples.account).toJson(),
        r'{"id":10,"userId":1,"name":"Cash","currency":"THB","color":"#00ff00","includeInTotal":false,"createdAt":"2026-01-02T03:04:05.000Z","updatedAt":"2026-01-02T03:04:05.000Z"}',
      );
    });

    test('account with balance, with and without shared', () {
      expectJson(
        AccountWithBalance(SerializerSamples.account, 300, true).toJson(),
        r'{"id":10,"userId":1,"name":"Cash","currency":"THB","color":"#00ff00","includeInTotal":false,"createdAt":"2026-01-02T03:04:05.000Z","updatedAt":"2026-01-02T03:04:05.000Z","balanceCents":300,"isDefault":true}',
      );
      expectJson(
        AccountWithBalance(
          SerializerSamples.account,
          300,
          false,
          true,
        ).toJson(),
        r'{"id":10,"userId":1,"name":"Cash","currency":"THB","color":"#00ff00","includeInTotal":false,"createdAt":"2026-01-02T03:04:05.000Z","updatedAt":"2026-01-02T03:04:05.000Z","balanceCents":300,"isDefault":false,"shared":true}',
      );
    });

    test('account entry, one and a list', () {
      expectJson(
        AccountEntrySerializer(SerializerSamples.topUp).toJson(),
        r'{"id":12,"accountId":10,"expenseId":null,"amountCents":5000,"occurredOn":"2026-01-04","note":null,"createdAt":"2026-01-04T00:00:00.000Z","updatedAt":"2026-01-04T00:00:00.000Z"}',
      );
      expectJson(
        AccountEntrySerializer(<AccountEntry>[
          SerializerSamples.spend,
          SerializerSamples.topUp,
        ]).toJson(),
        r'[{"id":11,"accountId":10,"expenseId":8,"amountCents":-1250,"occurredOn":"2026-01-02","note":"lunch","createdAt":"2026-01-02T03:04:05.000Z","updatedAt":"2026-01-02T03:04:05.000Z"},{"id":12,"accountId":10,"expenseId":null,"amountCents":5000,"occurredOn":"2026-01-04","note":null,"createdAt":"2026-01-04T00:00:00.000Z","updatedAt":"2026-01-04T00:00:00.000Z"}]',
      );
      expectJson(AccountEntrySerializer(<AccountEntry>[]).toJson(), '[]');
    });
  });
}

/// Compares the encoded text, so key order counts too.
void expectJson(Object? actual, String expected) {
  expect(jsonEncode(actual), expected);
}
