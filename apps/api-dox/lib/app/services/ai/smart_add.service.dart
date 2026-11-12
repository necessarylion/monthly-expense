import 'dart:convert';

import 'package:api_dox/app/dtos/smart_add/smart_add.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:api_dox/app/services/ai/expense_categorizer.dart';
import 'package:api_dox/app/services/ai/smart_add_screen.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/app/services/expense.service.dart';
import 'package:api_dox/constants/ai.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:dox_core/dox_core.dart';

/// Smart add: the user types "lunch 5000, taxi 3000", Claude splits it into
/// expenses, and the app shows a card per expense with a Save button. A tap
/// sends an A2UI action back, and [save] stores that one expense.
///
/// Claude only reads the text. The server checks every item and draws the
/// cards itself ([SmartAddScreen]), since they save money.
///
/// The same call picks each item's category, and the card saves it, so the
/// expense is not sent to Claude again. A note the group used before keeps
/// its old category, like POST /expenses.
@Inject()
class SmartAddService {
  SmartAddService(
    this.claude,
    this.accounts,
    this.expenses,
    this.categories,
    this.categorizer,
  );

  final ClaudeClient claude;
  final AccountService accounts;
  final ExpenseService expenses;
  final CategoryService categories;
  final ExpenseCategorizer categorizer;

  /// The A2UI messages of the cards for [input].
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
    SmartAddScreen screen = SmartAddScreen(input.lang ?? 'en');
    List<SmartAddItem> items = <SmartAddItem>[];
    for (Object? raw in answer['items'] as List<dynamic>) {
      SmartAddItem? item = _item(raw, input.today, wallets, fallback, screen);
      if (item == null) continue;
      int? before = await categorizer.fromHistory(group.id!, item.note);
      int? picked = categoryNames.containsKey(before)
          ? before
          : _id((raw as Map<dynamic, dynamic>)['categoryId'], categoryNames);
      items.add(item.withCategory(picked, categoryNames[picked]));
      if (items.length == smartAddMaxItems) break;
    }
    return screen.cards(items, group.currency);
  }

  /// Saves the expense of a tapped Save button, with the checks of
  /// POST /expenses, and returns the update that marks it saved.
  Future<List<Map<String, Object?>>> save(
    User user,
    Group group,
    SmartAddAction action,
  ) async {
    await expenses.create(user, group, action.context);
    return SmartAddScreen(action.lang ?? 'en').saved(action.sourceComponentId);
  }

  /// One of Claude's items, or null when it is not a usable expense. A
  /// wallet Claude made up becomes the default one.
  static SmartAddItem? _item(
    Object? raw,
    String today,
    Map<int, String> wallets,
    int? fallback,
    SmartAddScreen screen,
  ) {
    if (raw is! Map) return null;
    Object? note = raw['note'];
    Object? amount = raw['amount'];
    if (note is! String || amount is! num) return null;
    String text = note.trim();
    // The limits of CreateExpense.
    if (text.isEmpty || text.length > 500) return null;
    if (amount < 0.01 || amount > 10000000) return null;
    int? accountId = _id(raw['walletId'], wallets) ?? fallback;
    return SmartAddItem(
      note: text,
      amount: (amount * 100).round() / 100,
      occurredOn: today,
      accountId: accountId,
      walletName: wallets[accountId] ?? screen.text['noWallet']!,
    );
  }

  /// [raw] when it is one of the ids of [known], else null.
  static int? _id(Object? raw, Map<int, String> known) {
    return raw is int && known.containsKey(raw) ? raw : null;
  }
}
