import 'dart:convert';

import 'package:a2ui_agent/a2ui_agent.dart';
import 'package:a2ui_core/a2ui_core.dart';
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

/// "Explain my month": Claude writes a small screen about the month, in
/// A2UI. The web app draws it with `@a2ui/react`.
///
/// The React renderer speaks A2UI v0.9 only, so this uses the v0.9 basic
/// catalog, cut down to [insightComponents].
///
/// The answer is kept in the file cache with a fingerprint of what Claude
/// saw. Opening the sheet again costs nothing until an expense, the budget,
/// the language or the prompt changes.
// ponytail: two isolates can ask Claude for the same month at once; add a cache lock if that costs too much.
@Inject()
class MonthInsightService {
  MonthInsightService(this.expenses, this.categories, this.claude, this.cache);

  final ExpenseService expenses;
  final CategoryService categories;
  final ClaudeClient claude;
  final FileCache cache;

  static final A2uiGenerator _generator = A2uiGenerator(
    catalogs: <CatalogConfig>[
      CatalogConfig(
        BasicCatalog.v0_9(),
        transformers: <CatalogTransformer>[
          ComponentPruningTransformer(insightComponents),
        ],
      ),
    ],
  );

  /// The A2UI messages that draw the month, as JSON.
  Future<List<Map<String, dynamic>>> explain(
    Group group,
    MonthRange month,
    String lang,
  ) async {
    A2uiRequestProcessor processor = _generator.createProcessor(
      A2uiRendererCapabilities.forCatalogIds(<String>[BasicCatalog.v0_9Id]),
    );
    String system = '$insightSystemPrompt\n\n${processor.promptSnippet}';
    String prompt = jsonEncode(await _facts(group, month, lang));
    String key = 'insight-${group.id}-${month.key}-$lang';
    String fingerprint = sha256
        .convert(utf8.encode('$system\n$prompt'))
        .toString();
    Object? stored = (await cache.read(key))?.value;
    if (stored is Map &&
        stored['fingerprint'] == fingerprint &&
        stored['messages'] is List) {
      return <Map<String, dynamic>>[
        for (Object? message in stored['messages'] as List<dynamic>)
          message as Map<String, dynamic>,
      ];
    }

    String? answer = await claude.askText(
      system: system,
      prompt: prompt,
      timeout: insightTimeout,
    );
    if (answer == null) {
      throw HttpError.badGateway('Could not explain the month. Try again.');
    }
    try {
      List<Map<String, dynamic>> messages = <Map<String, dynamic>>[
        for (A2uiPart part
            in processor.parseResponse(answer).whereType<A2uiPart>())
          for (AgentToRendererMessage message in part.a2ui) message.toJson(),
      ];
      await cache.write(key, <String, Object?>{
        'fingerprint': fingerprint,
        'messages': messages,
      });
      return messages;
    } on A2uiError catch (error) {
      Logger.warn('[insight] bad A2UI from Claude: $error');
      throw HttpError.badGateway('Could not explain the month. Try again.');
    }
  }

  /// What Claude sees: the month's totals, by category, and the biggest
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
    return <String, Object?>{
      'language': lang == 'my' ? 'Burmese' : 'English',
      'month': summary.month,
      'currency': group.currency,
      'total': MoneyUtil.fromCents(summary.totalCents),
      'expenseCount': summary.count,
      'budget': budget == null ? null : MoneyUtil.fromCents(budget),
      'byCategory': <Map<String, Object?>>[
        for (CategoryTotal row in summary.byCategory)
          <String, Object?>{
            'category': names[row.categoryId]?.name ?? 'No category',
            'total': MoneyUtil.fromCents(row.totalCents),
            'count': row.count,
          },
      ],
      'biggestExpenses': <Map<String, Object?>>[
        for (ExpenseWithCategory row in rows.take(insightTopExpenses))
          <String, Object?>{
            'note': row.expense.note,
            'amount': MoneyUtil.fromCents(row.expense.amountCents),
            'date': row.expense.occurredOn,
            'category': row.category?.name,
          },
      ],
    };
  }
}
