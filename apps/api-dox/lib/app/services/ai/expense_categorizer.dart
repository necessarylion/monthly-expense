import 'dart:convert';

import 'package:api_dox/app/dtos/category_pick/category_pick.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:dox_core/dox_core.dart';

const String _system =
    'You sort the expenses of an expense app into categories. You get the '
    'note the user wrote for one expense, its amount, and the categories '
    'of their group. Answer with the id of the category the expense '
    'belongs to. The note can be short, in any language, or just a shop '
    'or brand name. When nothing fits well, pick the category that means '
    '"other" if there is one.';

/// Finds the category of an expense from its note, so the app does not
/// ask for one.
///
/// A note the group used before gets the same category again, with no AI
/// call. A new note goes to Claude.
@Inject()
class ExpenseCategorizer {
  ExpenseCategorizer(this.claude, this.expenses);

  final ClaudeClient claude;
  final ExpenseRepository expenses;

  bool get enabled => claude.enabled;

  /// The category of the group's newest expense with the same note.
  Future<int?> fromHistory(int groupId, String note) {
    return expenses.categoryOfNote(groupId, note);
  }

  /// Claude's pick among [categories]. Null when Claude is off, fails, or
  /// answers with an id that is not in the list.
  Future<int?> ask(
    String note,
    int amountCents,
    List<Category> categories,
  ) async {
    if (!claude.enabled || categories.isEmpty) return null;
    Object? answer = await claude.askJson(
      system: _system,
      prompt: jsonEncode(<String, Object?>{
        'note': note,
        'amount': amountCents / 100,
        'categories': <Map<String, Object?>>[
          for (Category c in categories)
            <String, Object?>{'id': c.id, 'name': c.name},
        ],
      }),
      schema: CategoryPick.schema.toJsonSchema(),
    );
    if (answer is! Map<String, dynamic>) return null;
    ParseResult<CategoryPick> parsed = await CategoryPick.schema
        .safeValidateMap(answer);
    if (!parsed.success) return null;
    int id = parsed.value!.categoryId;
    return categories.any((Category c) => c.id == id) ? id : null;
  }
}
