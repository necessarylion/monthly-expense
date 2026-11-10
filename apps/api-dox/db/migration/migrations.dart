// Made by `dox make:migration` and the `dox migration:*` commands.
// Do not edit, it is made again from the files in this folder.
import 'package:dox_migration/dox_migration.dart';

import '2026_11_08_000000_baseline.dart' as m1;
import '2026_11_08_000001_account_members.dart' as m2;
import '2026_11_09_000000_shopping_items.dart' as m3;
import '2026_11_09_081253_create_mcp_tokens_table.dart' as m4;
import '2026_11_09_130754_create_passkeys_table.dart' as m5;
import '2026_11_09_134300_add_budgets_and_payers.dart' as m6;
import '2026_11_09_134301_create_recurring_expenses_table.dart' as m7;
import '2026_11_09_135608_add_split_to_groups.dart' as m8;
import '2026_11_09_140558_add_kind_to_groups.dart' as m9;
import '2026_11_09_141633_add_trip_dates_to_groups.dart' as m10;
import '2026_11_10_210626_add_totp_to_users.dart' as m11;

/// all Dart migrations of db/migration, sorted by name
final List<MigrationEntry> migrations = <MigrationEntry>[
  MigrationEntry('2026_11_08_000000_baseline', m1.Baseline()),
  MigrationEntry('2026_11_08_000001_account_members', m2.AccountMembers()),
  MigrationEntry('2026_11_09_000000_shopping_items', m3.ShoppingItems()),
  MigrationEntry(
    '2026_11_09_081253_create_mcp_tokens_table',
    m4.CreateMcpTokensTable(),
  ),
  MigrationEntry(
    '2026_11_09_130754_create_passkeys_table',
    m5.CreatePasskeysTable(),
  ),
  MigrationEntry(
    '2026_11_09_134300_add_budgets_and_payers',
    m6.AddBudgetsAndPayers(),
  ),
  MigrationEntry(
    '2026_11_09_134301_create_recurring_expenses_table',
    m7.CreateRecurringExpensesTable(),
  ),
  MigrationEntry(
    '2026_11_09_135608_add_split_to_groups',
    m8.AddSplitToGroups(),
  ),
  MigrationEntry('2026_11_09_140558_add_kind_to_groups', m9.AddKindToGroups()),
  MigrationEntry(
    '2026_11_09_141633_add_trip_dates_to_groups',
    m10.AddTripDatesToGroups(),
  ),
  MigrationEntry('2026_11_10_210626_add_totp_to_users', m11.AddTotpToUsers()),
];
