/// Every Dox model, one per table (`lib/models/<name>/<name>.model.dart`,
/// the layout of `dox make:model`). Run `dart run build_runner build` after
/// a change.
///
/// Dates are text, as the old APIs stored them: `YYYY-MM-DD` for dates and
/// `YYYY-MM-DD HH:MM:SS` (UTC) for timestamps. The `TimestampText` and
/// `DateText` casts keep them that way on SQLite and Postgres, so the
/// models turn off the built-in `DateTime` timestamps. Money is cents.
library;

export 'account/account.model.dart';
export 'account_entry/account_entry.model.dart';
export 'account_member/account_member.model.dart';
export 'category/category.model.dart';
export 'expense/expense.model.dart';
export 'group/group.model.dart';
export 'group_member/group_member.model.dart';
export 'group_monthly_budget/group_monthly_budget.model.dart';
export 'mcp_token/mcp_token.model.dart';
export 'shopping_item/shopping_item.model.dart';
export 'user/user.model.dart';
