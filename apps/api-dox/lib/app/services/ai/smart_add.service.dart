import 'dart:convert';

import 'package:api_dox/app/dtos/smart_add/smart_add.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:api_dox/app/services/ai/expense_categorizer.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/constants/ai.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// Smart add: the user types "lunch 5000, taxi 3000" and Claude splits it
/// into expenses. Nothing is saved here: the app shows the items, the user
/// may edit them, and each Save is a normal POST /expenses.
///
/// Claude only reads the text. The server checks every item.
///
/// The same call picks each item's category, and the app sends it with the
/// save, so the expense is not sent to Claude again. A note the group used
/// before keeps its old category, like POST /expenses.
@Inject()
class SmartAddService {
  SmartAddService(
    this.claude,
    this.accounts,
    this.categories,
    this.categorizer,
  );

  final ClaudeClient claude;
  final AccountService accounts;
  final CategoryService categories;
  final ExpenseCategorizer categorizer;

  /// The expenses in [input], each with the keys of POST /expenses.
  Future<List<Map<String, Object?>>> read(
    User user,
    Group group,
    SmartAddText input,
  ) async {
    Map<int, String> wallets = <int, String>{
      for (AccountWithBalance row in await accounts.withBalances(user))
        row.account.id!: row.account.name,
    };
    Map<int, String> categoryNames = <int, String>{
      for (Category c in await categories.list(group)) c.id!: c.name,
    };
    Object? answer = await claude.askJson(
      system: smartAddSystemPrompt,
      prompt: jsonEncode(<String, Object?>{
        'text': input.text,
        'wallets': <Map<String, Object?>>[
          for (MapEntry<int, String> w in wallets.entries)
            <String, Object?>{'id': w.key, 'name': w.value},
        ],
        'categories': <Map<String, Object?>>[
          for (MapEntry<int, String> c in categoryNames.entries)
            <String, Object?>{'id': c.key, 'name': c.value},
        ],
      }),
      schema: smartAddSchema,
    );
    if (answer is! Map || answer['items'] is! List) {
      throw HttpError.badGateway('Could not read that. Try again.');
    }
    int? fallback = await accounts.defaultAccountId(user, group);
    List<Map<String, Object?>> items = <Map<String, Object?>>[];
    for (Object? raw in answer['items'] as List<dynamic>) {
      if (raw is! Map) continue;
      Object? note = raw['note'];
      Object? amount = raw['amount'];
      if (note is! String || amount is! num) continue;
      String text = note.trim();
      // The limits of CreateExpense.
      if (text.isEmpty || text.length > 500) continue;
      if (amount < 0.01 || amount > 10000000) continue;
      int? before = await categorizer.fromHistory(group.id!, text);
      items.add(<String, Object?>{
        'note': text,
        'amount': (amount * 100).round() / 100,
        'occurredOn': input.today,
        // A wallet Claude made up becomes the default one.
        'accountId': _id(raw['walletId'], wallets) ?? fallback,
        // Null: none found; POST /expenses sorts it then.
        'categoryId': categoryNames.containsKey(before)
            ? before
            : _id(raw['categoryId'], categoryNames),
      });
      if (items.length == smartAddMaxItems) break;
    }
    return items;
  }

  /// [raw] when it is one of the ids of [known], else null.
  static int? _id(Object? raw, Map<int, String> known) {
    return raw is int && known.containsKey(raw) ? raw : null;
  }
}
