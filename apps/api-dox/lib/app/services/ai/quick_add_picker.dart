import 'dart:convert';

import 'package:api_dox/app/dtos/quick_add_pick/quick_add_pick.dto.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/ai/claude_client.dart';
import 'package:api_dox/app/services/file_cache.dart';
import 'package:api_dox/constants/ai.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:dox_core/dox_core.dart';

const String _system =
    'You choose the one-tap "add again" buttons of an expense app. '
    'You get expenses a group logged more than once. Pick at most '
    '$frequentExpenseLimit of them. Merge near-duplicates: the same thing '
    'with another spelling, case, or a small change in the note or the '
    'amount (for example "Coffee" and "coffee", or "Grab" and "Grab taxi"). '
    'For a merged item keep the row that is used most, then the newest. '
    'Prefer items the group still logs lately. Answer with the ids only.';

/// Picks the quick-add list from the repeat expenses, with Claude.
///
/// Claude's pick is kept in the file cache per group. We ask again only
/// when the set of candidates changes, not when a count goes up. Without
/// Claude (no key, error) the list is the first rows, most used first.
// ponytail: two isolates can ask Claude at the same time once; add a cache lock if that costs too much.
@Inject()
class QuickAddPicker {
  QuickAddPicker(this.claude, this.cache);

  final ClaudeClient claude;
  final FileCache cache;

  /// [candidates] are most used first. [categoryNames] maps id to name.
  Future<List<FrequentExpense>> pick(
    int groupId,
    List<FrequentExpense> candidates,
    Map<int, String> categoryNames,
  ) async {
    List<FrequentExpense> plain = candidates
        .take(frequentExpenseLimit)
        .toList();
    if (candidates.length <= 1 || !claude.enabled) return plain;

    String key = 'quick-add-$groupId';
    String fingerprint = _fingerprint(candidates);
    CacheEntry<Object?>? hit = await cache.read(key);
    Object? stored = hit?.value;
    if (stored is Map && stored['fingerprint'] == fingerprint) {
      bool ai = stored['ai'] == true;
      bool waiting =
          DateTime.now().millisecondsSinceEpoch - hit!.at <
          claudeRetryAfter.inMilliseconds;
      if (ai || waiting) {
        return _keep(candidates, stored['keys'], plain);
      }
    }

    List<String>? keys = await _ask(candidates, categoryNames);
    await cache.write(key, <String, Object?>{
      'fingerprint': fingerprint,
      'ai': keys != null,
      'keys': keys ?? <String>[for (FrequentExpense row in plain) _key(row)],
    });
    return keys == null ? plain : _keep(candidates, keys, plain);
  }

  /// The keys of the rows Claude picked. Null when Claude did not answer.
  Future<List<String>?> _ask(
    List<FrequentExpense> candidates,
    Map<int, String> categoryNames,
  ) async {
    List<Map<String, Object?>> rows = <Map<String, Object?>>[
      for (int i = 0; i < candidates.length; i++)
        <String, Object?>{
          'id': i,
          'category': categoryNames[candidates[i].categoryId],
          'amount': candidates[i].amountCents / 100,
          'note': candidates[i].note,
          'uses': candidates[i].uses,
          'lastOn': candidates[i].lastOn,
        },
    ];
    Object? answer = await claude.askJson(
      system: _system,
      prompt: jsonEncode(rows),
      schema: QuickAddPick.schema.toJsonSchema(),
    );
    if (answer is! Map<String, dynamic>) return null;
    ParseResult<QuickAddPick> parsed = await QuickAddPick.schema
        .safeValidateMap(answer);
    if (!parsed.success) return null;
    List<String> keys = <String>[];
    for (int id in parsed.value!.ids) {
      if (id >= 0 && id < candidates.length) {
        String key = _key(candidates[id]);
        if (!keys.contains(key)) keys.add(key);
      }
    }
    return keys.isEmpty ? null : keys;
  }

  /// The candidates whose key is in [keys], in candidate order (most used
  /// first), at most [frequentExpenseLimit].
  static List<FrequentExpense> _keep(
    List<FrequentExpense> candidates,
    Object? keys,
    List<FrequentExpense> fallback,
  ) {
    if (keys is! List) return fallback;
    Set<String> wanted = <String>{for (Object? k in keys) '$k'};
    List<FrequentExpense> kept = <FrequentExpense>[
      for (FrequentExpense row in candidates)
        if (wanted.contains(_key(row))) row,
    ];
    return kept.isEmpty ? fallback : kept.take(frequentExpenseLimit).toList();
  }

  /// Same category, amount and note = same row.
  static String _key(FrequentExpense row) {
    return jsonEncode(<Object?>[row.categoryId, row.amountCents, row.note]);
  }

  /// The set of candidates, without counts or order.
  static String _fingerprint(List<FrequentExpense> candidates) {
    List<String> keys = <String>[
      for (FrequentExpense row in candidates) _key(row),
    ]..sort();
    return jsonEncode(keys);
  }
}
