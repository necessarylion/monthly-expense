import 'dart:io';

import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/app/services/ai/quick_add_picker.dart';
import 'package:api_dox/app/services/file_cache.dart';
import 'package:dox_core/dox_core.dart';
import 'package:test/test.dart';

import 'support/test_app.dart';

FrequentExpense row(String note, int uses) {
  return FrequentExpense(
    categoryId: 1,
    amountCents: 6000,
    note: note,
    uses: uses,
    lastOn: '2026-11-01',
  );
}

List<String?> notes(List<FrequentExpense> rows) {
  return <String?>[for (FrequentExpense r in rows) r.note];
}

/// Claude picks the quick-add list. Its pick is cached until the set of
/// candidates changes, and a bad or missing answer gives the plain list.
void main() {
  Directory dir = Directory.systemTemp.createTempSync('expense-quick-add-');
  FileCache cache = FileCache.withManager(
    CacheManager(
      CacheConfig(
        defaultStore: 'file',
        stores: <String, Map<String, dynamic>>{
          'file': <String, dynamic>{'driver': 'file', 'path': dir.path},
        },
      ),
    ),
  );
  tearDownAll(() => dir.deleteSync(recursive: true));

  List<FrequentExpense> candidates = <FrequentExpense>[
    row('Coffee', 5),
    row('coffee', 3),
    row('Lunch', 2),
  ];
  Map<int, String> names = <int, String>{1: 'Food'};

  test('off: plain list, Claude not asked', () async {
    FakeClaudeClient claude = FakeClaudeClient();
    QuickAddPicker picker = QuickAddPicker(claude, cache);
    expect(notes(await picker.pick(1, candidates, names)), <String>[
      'Coffee',
      'coffee',
      'Lunch',
    ]);
    expect(claude.calls, 0);
  });

  test('keeps the pick, drops bad ids, asks once per candidate set', () async {
    FakeClaudeClient claude = FakeClaudeClient()
      ..on = true
      ..answer = <String, Object?>{
        'ids': <Object?>[2, 0, 99, -1, 'x', 0],
      };
    QuickAddPicker picker = QuickAddPicker(claude, cache);
    expect(notes(await picker.pick(2, candidates, names)), <String>[
      'Coffee',
      'Lunch',
    ]);

    // A count went up: same set, so the cached pick is used.
    List<FrequentExpense> more = <FrequentExpense>[
      row('Coffee', 6),
      row('coffee', 3),
      row('Lunch', 2),
    ];
    expect(notes(await picker.pick(2, more, names)), <String>[
      'Coffee',
      'Lunch',
    ]);
    expect(claude.calls, 1);

    // A new candidate: Claude is asked again.
    await picker.pick(2, <FrequentExpense>[...more, row('Taxi', 2)], names);
    expect(claude.calls, 2);
  });

  test('a failed answer gives the plain list and waits before retry', () async {
    FakeClaudeClient claude = FakeClaudeClient()..on = true;
    QuickAddPicker picker = QuickAddPicker(claude, cache);
    expect(notes(await picker.pick(3, candidates, names)).length, 3);
    await picker.pick(3, candidates, names);
    expect(claude.calls, 1);
  });
}
