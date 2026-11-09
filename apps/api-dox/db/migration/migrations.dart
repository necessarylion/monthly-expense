// Made by `dox make:migration` and the `dox migration:*` commands.
// Do not edit, it is made again from the files in this folder.
import 'package:dox_migration/dox_migration.dart';

import '2026_11_08_000000_baseline.dart' as m1;
import '2026_11_08_000001_account_members.dart' as m2;
import '2026_11_09_000000_shopping_items.dart' as m3;
import '2026_11_09_081253_create_mcp_tokens_table.dart' as m4;

/// all Dart migrations of db/migration, sorted by name
final List<MigrationEntry> migrations = <MigrationEntry>[
  MigrationEntry('2026_11_08_000000_baseline', m1.Baseline()),
  MigrationEntry('2026_11_08_000001_account_members', m2.AccountMembers()),
  MigrationEntry('2026_11_09_000000_shopping_items', m3.ShoppingItems()),
  MigrationEntry(
    '2026_11_09_081253_create_mcp_tokens_table',
    m4.CreateMcpTokensTable(),
  ),
];
