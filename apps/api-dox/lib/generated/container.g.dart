// GENERATED CODE - DO NOT MODIFY BY HAND
// Made by dox_builder. Run `dart run build_runner build`.
// ignore_for_file: type=lint

import 'package:dox_core/dox_core.dart';
import 'package:api_dox/app/http/controllers/account.controller.dart' as i1;
import 'package:api_dox/app/http/controllers/auth.controller.dart' as i2;
import 'package:api_dox/app/http/controllers/category.controller.dart' as i3;
import 'package:api_dox/app/http/controllers/config.controller.dart' as i4;
import 'package:api_dox/app/http/controllers/expense.controller.dart' as i5;
import 'package:api_dox/app/http/controllers/group.controller.dart' as i6;
import 'package:api_dox/app/http/controllers/health.controller.dart' as i7;
import 'package:api_dox/app/http/controllers/insight.controller.dart' as i8;
import 'package:api_dox/app/http/controllers/mcp.controller.dart' as i9;
import 'package:api_dox/app/http/controllers/me.controller.dart' as i10;
import 'package:api_dox/app/http/controllers/oauth.controller.dart' as i11;
import 'package:api_dox/app/http/controllers/passkey.controller.dart' as i12;
import 'package:api_dox/app/http/controllers/recurring.controller.dart' as i13;
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart'
    as i14;
import 'package:api_dox/app/http/controllers/smart_add.controller.dart' as i15;
import 'package:api_dox/app/http/controllers/totp.controller.dart' as i16;
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i17;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i18;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i19;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i20;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i21;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i22;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i23;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i24;
import 'package:api_dox/app/repositories/account.repository.dart' as i25;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i26;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i27;
import 'package:api_dox/app/repositories/api_token.repository.dart' as i28;
import 'package:api_dox/app/repositories/budget.repository.dart' as i29;
import 'package:api_dox/app/repositories/category.repository.dart' as i30;
import 'package:api_dox/app/repositories/expense.repository.dart' as i31;
import 'package:api_dox/app/repositories/group.repository.dart' as i32;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i33;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i34;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i35;
import 'package:api_dox/app/repositories/recurring_expense.repository.dart'
    as i36;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i37;
import 'package:api_dox/app/repositories/user.repository.dart' as i38;
import 'package:api_dox/app/services/account.service.dart' as i39;
import 'package:api_dox/app/services/account_share.service.dart' as i40;
import 'package:api_dox/app/services/ai/claude_client.dart' as i41;
import 'package:api_dox/app/services/ai/expense_categorizer.dart' as i42;
import 'package:api_dox/app/services/ai/month_insight.service.dart' as i43;
import 'package:api_dox/app/services/ai/quick_add_picker.dart' as i44;
import 'package:api_dox/app/services/ai/smart_add.service.dart' as i45;
import 'package:api_dox/app/services/api_token.service.dart' as i46;
import 'package:api_dox/app/services/budget.service.dart' as i47;
import 'package:api_dox/app/services/category.service.dart' as i48;
import 'package:api_dox/app/services/expense.service.dart' as i49;
import 'package:api_dox/app/services/file_cache.dart' as i50;
import 'package:api_dox/app/services/firebase.service.dart' as i51;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i52;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i53;
import 'package:api_dox/app/services/fx/fx.service.dart' as i54;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i55;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i56;
import 'package:api_dox/app/services/group.service.dart' as i57;
import 'package:api_dox/app/services/live.service.dart' as i58;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i59;
import 'package:api_dox/app/services/mcp_token.service.dart' as i60;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i61;
import 'package:api_dox/app/services/recurring.service.dart' as i62;
import 'package:api_dox/app/services/report.service.dart' as i63;
import 'package:api_dox/app/services/shopping_list.service.dart' as i64;
import 'package:api_dox/app/services/totp/totp.service.dart' as i65;
import 'package:api_dox/app/services/user.service.dart' as i66;
import 'package:api_dox/config/settings.dart' as i67;
import 'package:api_dox/http/static_files.dart' as i68;
import 'package:api_dox/providers/orm_provider.dart' as i69;
import 'package:api_dox/providers/schedule_provider.dart' as i70;
import 'package:api_dox/providers/socket_io_provider.dart' as i71;
import 'package:api_dox/routes/api.dart' as i72;
import 'package:api_dox/routes/web.dart' as i73;
import 'package:api_dox/app/models/account/account.model.dart' as i74;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i75;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i76;
import 'package:api_dox/app/models/api_token/api_token.model.dart' as i77;
import 'package:api_dox/app/models/category/category.model.dart' as i78;
import 'package:api_dox/app/models/expense/expense.model.dart' as i79;
import 'package:api_dox/app/models/group/group.model.dart' as i80;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i81;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i82;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i83;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i84;
import 'package:api_dox/app/models/recurring_expense/recurring_expense.model.dart'
    as i85;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i86;
import 'package:api_dox/app/models/user/user.model.dart' as i87;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i39.AccountService>(),
      c.get<i52.AccountTotalService>(),
      c.get<i54.FxService>(),
      c.get<i40.AccountShareService>(),
    ),
  );
  c.singleton<i2.AuthController>(
    (IocContainer c) => i2.AuthController(c.get<i46.ApiTokenService>()),
  );
  c.singleton<i3.CategoryController>(
    (IocContainer c) => i3.CategoryController(c.get<i48.CategoryService>()),
  );
  c.singleton<i4.ConfigController>(
    (IocContainer c) => i4.ConfigController(c.get<i67.AppSettings>()),
  );
  c.singleton<i5.ExpenseController>(
    (IocContainer c) => i5.ExpenseController(
      c.get<i49.ExpenseService>(),
      c.get<i63.ReportService>(),
    ),
  );
  c.singleton<i6.GroupController>(
    (IocContainer c) => i6.GroupController(
      c.get<i57.GroupService>(),
      c.get<i47.BudgetService>(),
    ),
  );
  c.singleton<i7.HealthController>((IocContainer c) => i7.HealthController());
  c.singleton<i8.InsightController>(
    (IocContainer c) => i8.InsightController(c.get<i43.MonthInsightService>()),
  );
  c.singleton<i9.McpController>(
    (IocContainer c) => i9.McpController(
      c.get<i59.McpOAuthService>(),
      c.get<i19.McpToolRegistry>(),
    ),
  );
  c.singleton<i10.MeController>(
    (IocContainer c) => i10.MeController(
      c.get<i59.McpOAuthService>(),
      c.get<i60.McpTokenService>(),
    ),
  );
  c.singleton<i11.OauthController>(
    (IocContainer c) => i11.OauthController(
      c.get<i59.McpOAuthService>(),
      c.get<i60.McpTokenService>(),
    ),
  );
  c.singleton<i12.PasskeyController>(
    (IocContainer c) => i12.PasskeyController(c.get<i61.PasskeyService>()),
  );
  c.singleton<i13.RecurringController>(
    (IocContainer c) => i13.RecurringController(c.get<i62.RecurringService>()),
  );
  c.singleton<i14.ShoppingItemController>(
    (IocContainer c) =>
        i14.ShoppingItemController(c.get<i64.ShoppingListService>()),
  );
  c.singleton<i15.SmartAddController>(
    (IocContainer c) => i15.SmartAddController(c.get<i45.SmartAddService>()),
  );
  c.singleton<i16.TotpController>(
    (IocContainer c) => i16.TotpController(c.get<i65.TotpService>()),
  );
  c.singleton<i17.AuthMiddleware>(
    (IocContainer c) => i17.AuthMiddleware(c.get<i46.ApiTokenService>()),
  );
  c.singleton<i18.GroupMiddleware>(
    (IocContainer c) => i18.GroupMiddleware(c.get<i57.GroupService>()),
  );
  c.singleton<i19.McpToolRegistry>(
    (IocContainer c) => i19.McpToolRegistry(
      c.get<i22.GetMeTool>(),
      c.get<i22.ListGroupsTool>(),
      c.get<i22.CreateGroupTool>(),
      c.get<i22.UpdateGroupTool>(),
      c.get<i22.ListGroupMembersTool>(),
      c.get<i22.InviteGroupMemberTool>(),
      c.get<i22.RemoveGroupMemberTool>(),
      c.get<i22.LeaveGroupTool>(),
      c.get<i22.GetBudgetTool>(),
      c.get<i22.SetBudgetTool>(),
      c.get<i22.GetDefaultWalletTool>(),
      c.get<i22.SetDefaultWalletTool>(),
      c.get<i20.ListCategoriesTool>(),
      c.get<i20.CreateCategoryTool>(),
      c.get<i20.UpdateCategoryTool>(),
      c.get<i20.DeleteCategoryTool>(),
      c.get<i21.AddExpenseTool>(),
      c.get<i21.ListExpensesTool>(),
      c.get<i21.FrequentExpensesTool>(),
      c.get<i21.UpdateExpenseTool>(),
      c.get<i21.DeleteExpenseTool>(),
      c.get<i21.MonthlySummaryTool>(),
      c.get<i24.ListWalletsTool>(),
      c.get<i24.CreateWalletTool>(),
      c.get<i24.UpdateWalletTool>(),
      c.get<i24.DeleteWalletTool>(),
      c.get<i24.WalletTotalTool>(),
      c.get<i24.WalletHistoryTool>(),
      c.get<i24.TransferBetweenWalletsTool>(),
      c.get<i24.ListWalletMembersTool>(),
      c.get<i24.InviteWalletMemberTool>(),
      c.get<i24.RemoveWalletMemberTool>(),
      c.get<i24.ListWalletEntriesTool>(),
      c.get<i24.RecentWalletEntriesTool>(),
      c.get<i24.AddWalletEntryTool>(),
      c.get<i24.UpdateWalletEntryTool>(),
      c.get<i24.DeleteWalletEntryTool>(),
      c.get<i24.AdjustWalletBalanceTool>(),
      c.get<i24.ExchangeRatesTool>(),
      c.get<i23.ListShoppingItemsTool>(),
      c.get<i23.AddShoppingItemTool>(),
      c.get<i23.UpdateShoppingItemTool>(),
      c.get<i23.DeleteShoppingItemTool>(),
      c.get<i23.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i20.ListCategoriesTool>(
    (IocContainer c) => i20.ListCategoriesTool(
      c.get<i57.GroupService>(),
      c.get<i48.CategoryService>(),
    ),
  );
  c.singleton<i20.CreateCategoryTool>(
    (IocContainer c) => i20.CreateCategoryTool(
      c.get<i57.GroupService>(),
      c.get<i48.CategoryService>(),
    ),
  );
  c.singleton<i20.UpdateCategoryTool>(
    (IocContainer c) => i20.UpdateCategoryTool(
      c.get<i57.GroupService>(),
      c.get<i48.CategoryService>(),
    ),
  );
  c.singleton<i20.DeleteCategoryTool>(
    (IocContainer c) => i20.DeleteCategoryTool(
      c.get<i57.GroupService>(),
      c.get<i48.CategoryService>(),
    ),
  );
  c.singleton<i21.AddExpenseTool>(
    (IocContainer c) => i21.AddExpenseTool(
      c.get<i57.GroupService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i21.ListExpensesTool>(
    (IocContainer c) => i21.ListExpensesTool(
      c.get<i57.GroupService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i21.FrequentExpensesTool>(
    (IocContainer c) => i21.FrequentExpensesTool(
      c.get<i57.GroupService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i21.UpdateExpenseTool>(
    (IocContainer c) => i21.UpdateExpenseTool(
      c.get<i57.GroupService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i21.DeleteExpenseTool>(
    (IocContainer c) => i21.DeleteExpenseTool(
      c.get<i57.GroupService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i21.MonthlySummaryTool>(
    (IocContainer c) => i21.MonthlySummaryTool(
      c.get<i57.GroupService>(),
      c.get<i48.CategoryService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i22.GetMeTool>(
    (IocContainer c) => i22.GetMeTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.ListGroupsTool>(
    (IocContainer c) => i22.ListGroupsTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.CreateGroupTool>(
    (IocContainer c) => i22.CreateGroupTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.UpdateGroupTool>(
    (IocContainer c) => i22.UpdateGroupTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.ListGroupMembersTool>(
    (IocContainer c) => i22.ListGroupMembersTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.InviteGroupMemberTool>(
    (IocContainer c) => i22.InviteGroupMemberTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.RemoveGroupMemberTool>(
    (IocContainer c) => i22.RemoveGroupMemberTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.LeaveGroupTool>(
    (IocContainer c) => i22.LeaveGroupTool(c.get<i57.GroupService>()),
  );
  c.singleton<i22.GetBudgetTool>(
    (IocContainer c) => i22.GetBudgetTool(
      c.get<i57.GroupService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i22.SetBudgetTool>(
    (IocContainer c) => i22.SetBudgetTool(
      c.get<i57.GroupService>(),
      c.get<i47.BudgetService>(),
    ),
  );
  c.singleton<i22.GetDefaultWalletTool>(
    (IocContainer c) => i22.GetDefaultWalletTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i22.SetDefaultWalletTool>(
    (IocContainer c) => i22.SetDefaultWalletTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i23.ListShoppingItemsTool>(
    (IocContainer c) => i23.ListShoppingItemsTool(
      c.get<i57.GroupService>(),
      c.get<i64.ShoppingListService>(),
    ),
  );
  c.singleton<i23.AddShoppingItemTool>(
    (IocContainer c) => i23.AddShoppingItemTool(
      c.get<i57.GroupService>(),
      c.get<i64.ShoppingListService>(),
    ),
  );
  c.singleton<i23.UpdateShoppingItemTool>(
    (IocContainer c) => i23.UpdateShoppingItemTool(
      c.get<i57.GroupService>(),
      c.get<i64.ShoppingListService>(),
    ),
  );
  c.singleton<i23.DeleteShoppingItemTool>(
    (IocContainer c) => i23.DeleteShoppingItemTool(
      c.get<i57.GroupService>(),
      c.get<i64.ShoppingListService>(),
    ),
  );
  c.singleton<i23.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i23.ClearDoneShoppingItemsTool(
      c.get<i57.GroupService>(),
      c.get<i64.ShoppingListService>(),
    ),
  );
  c.singleton<i24.ListWalletsTool>(
    (IocContainer c) => i24.ListWalletsTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.CreateWalletTool>(
    (IocContainer c) => i24.CreateWalletTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.UpdateWalletTool>(
    (IocContainer c) => i24.UpdateWalletTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.DeleteWalletTool>(
    (IocContainer c) => i24.DeleteWalletTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.WalletTotalTool>(
    (IocContainer c) => i24.WalletTotalTool(
      c.get<i57.GroupService>(),
      c.get<i52.AccountTotalService>(),
    ),
  );
  c.singleton<i24.WalletHistoryTool>(
    (IocContainer c) => i24.WalletHistoryTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.TransferBetweenWalletsTool>(
    (IocContainer c) => i24.TransferBetweenWalletsTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.ListWalletMembersTool>(
    (IocContainer c) => i24.ListWalletMembersTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
      c.get<i40.AccountShareService>(),
    ),
  );
  c.singleton<i24.InviteWalletMemberTool>(
    (IocContainer c) => i24.InviteWalletMemberTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
      c.get<i40.AccountShareService>(),
    ),
  );
  c.singleton<i24.RemoveWalletMemberTool>(
    (IocContainer c) => i24.RemoveWalletMemberTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
      c.get<i40.AccountShareService>(),
    ),
  );
  c.singleton<i24.ListWalletEntriesTool>(
    (IocContainer c) => i24.ListWalletEntriesTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.RecentWalletEntriesTool>(
    (IocContainer c) => i24.RecentWalletEntriesTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.AddWalletEntryTool>(
    (IocContainer c) => i24.AddWalletEntryTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.UpdateWalletEntryTool>(
    (IocContainer c) => i24.UpdateWalletEntryTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.DeleteWalletEntryTool>(
    (IocContainer c) => i24.DeleteWalletEntryTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.AdjustWalletBalanceTool>(
    (IocContainer c) => i24.AdjustWalletBalanceTool(
      c.get<i57.GroupService>(),
      c.get<i39.AccountService>(),
    ),
  );
  c.singleton<i24.ExchangeRatesTool>(
    (IocContainer c) => i24.ExchangeRatesTool(
      c.get<i57.GroupService>(),
      c.get<i54.FxService>(),
    ),
  );
  c.singleton<i25.AccountRepository>(
    (IocContainer c) => i25.AccountRepository(),
  );
  c.singleton<i26.AccountEntryRepository>(
    (IocContainer c) => i26.AccountEntryRepository(),
  );
  c.singleton<i27.AccountMemberRepository>(
    (IocContainer c) => i27.AccountMemberRepository(),
  );
  c.singleton<i28.ApiTokenRepository>(
    (IocContainer c) => i28.ApiTokenRepository(),
  );
  c.singleton<i29.BudgetRepository>((IocContainer c) => i29.BudgetRepository());
  c.singleton<i30.CategoryRepository>(
    (IocContainer c) => i30.CategoryRepository(),
  );
  c.singleton<i31.ExpenseRepository>(
    (IocContainer c) => i31.ExpenseRepository(),
  );
  c.singleton<i32.GroupRepository>((IocContainer c) => i32.GroupRepository());
  c.singleton<i33.GroupMemberRepository>(
    (IocContainer c) => i33.GroupMemberRepository(),
  );
  c.singleton<i34.McpTokenRepository>(
    (IocContainer c) => i34.McpTokenRepository(),
  );
  c.singleton<i35.PasskeyRepository>(
    (IocContainer c) => i35.PasskeyRepository(),
  );
  c.singleton<i36.RecurringExpenseRepository>(
    (IocContainer c) => i36.RecurringExpenseRepository(),
  );
  c.singleton<i37.ShoppingItemRepository>(
    (IocContainer c) => i37.ShoppingItemRepository(),
  );
  c.singleton<i38.UserRepository>((IocContainer c) => i38.UserRepository());
  c.singleton<i39.AccountService>(
    (IocContainer c) => i39.AccountService(
      c.get<i25.AccountRepository>(),
      c.get<i26.AccountEntryRepository>(),
      c.get<i33.GroupMemberRepository>(),
      c.get<i27.AccountMemberRepository>(),
      c.get<i40.AccountShareService>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i40.AccountShareService>(
    (IocContainer c) => i40.AccountShareService(
      c.get<i27.AccountMemberRepository>(),
      c.get<i38.UserRepository>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i41.ClaudeClient>(
    (IocContainer c) => i41.ClaudeClient(c.get<i67.AppSettings>()),
  );
  c.singleton<i42.ExpenseCategorizer>(
    (IocContainer c) => i42.ExpenseCategorizer(
      c.get<i41.ClaudeClient>(),
      c.get<i31.ExpenseRepository>(),
    ),
  );
  c.singleton<i43.MonthInsightService>(
    (IocContainer c) => i43.MonthInsightService(
      c.get<i49.ExpenseService>(),
      c.get<i48.CategoryService>(),
      c.get<i41.ClaudeClient>(),
      c.get<i50.FileCache>(),
    ),
  );
  c.singleton<i44.QuickAddPicker>(
    (IocContainer c) =>
        i44.QuickAddPicker(c.get<i41.ClaudeClient>(), c.get<i50.FileCache>()),
  );
  c.singleton<i45.SmartAddService>(
    (IocContainer c) => i45.SmartAddService(
      c.get<i41.ClaudeClient>(),
      c.get<i39.AccountService>(),
      c.get<i49.ExpenseService>(),
    ),
  );
  c.singleton<i46.ApiTokenService>(
    (IocContainer c) => i46.ApiTokenService(
      c.get<i28.ApiTokenRepository>(),
      c.get<i38.UserRepository>(),
      c.get<i66.UserService>(),
      c.get<i51.FirebaseService>(),
    ),
  );
  c.singleton<i47.BudgetService>(
    (IocContainer c) => i47.BudgetService(
      c.get<i29.BudgetRepository>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i48.CategoryService>(
    (IocContainer c) => i48.CategoryService(
      c.get<i30.CategoryRepository>(),
      c.get<i31.ExpenseRepository>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i49.ExpenseService>(
    (IocContainer c) => i49.ExpenseService(
      c.get<i31.ExpenseRepository>(),
      c.get<i48.CategoryService>(),
      c.get<i47.BudgetService>(),
      c.get<i39.AccountService>(),
      c.get<i58.LiveService>(),
      c.get<i44.QuickAddPicker>(),
      c.get<i42.ExpenseCategorizer>(),
    ),
  );
  c.singleton<i50.FileCache>((IocContainer c) => i50.FileCache());
  c.singleton<i51.FirebaseService>(
    (IocContainer c) => i51.FirebaseService(c.get<i67.AppSettings>()),
  );
  c.singleton<i52.AccountTotalService>(
    (IocContainer c) => i52.AccountTotalService(
      c.get<i39.AccountService>(),
      c.get<i54.FxService>(),
    ),
  );
  c.singleton<i53.CoinbaseRateProvider>(
    (IocContainer c) => i53.CoinbaseRateProvider(
      c.get<i50.FileCache>(),
      c.get<i56.HttpFetch>(),
    ),
  );
  c.singleton<i54.FxService>(
    (IocContainer c) => i54.FxService(
      c.get<i53.CoinbaseRateProvider>(),
      c.get<i55.GoldQuoteProvider>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i55.GoldQuoteProvider>(
    (IocContainer c) =>
        i55.GoldQuoteProvider(c.get<i50.FileCache>(), c.get<i56.HttpFetch>()),
  );
  c.singleton<i56.HttpFetch>((IocContainer c) => i56.HttpFetch());
  c.singleton<i57.GroupService>(
    (IocContainer c) => i57.GroupService(
      c.get<i32.GroupRepository>(),
      c.get<i33.GroupMemberRepository>(),
      c.get<i30.CategoryRepository>(),
      c.get<i38.UserRepository>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i58.LiveService>(
    (IocContainer c) => i58.LiveService(
      c.get<i33.GroupMemberRepository>(),
      c.get<i25.AccountRepository>(),
      c.get<i27.AccountMemberRepository>(),
      c.get<i26.AccountEntryRepository>(),
    ),
  );
  c.singleton<i59.McpOAuthService>(
    (IocContainer c) => i59.McpOAuthService(
      c.get<i67.AppSettings>(),
      c.get<i60.McpTokenService>(),
    ),
  );
  c.singleton<i60.McpTokenService>(
    (IocContainer c) => i60.McpTokenService(
      c.get<i34.McpTokenRepository>(),
      c.get<i38.UserRepository>(),
      c.get<i66.UserService>(),
    ),
  );
  c.singleton<i61.PasskeyService>(
    (IocContainer c) => i61.PasskeyService(
      c.get<i35.PasskeyRepository>(),
      c.get<i38.UserRepository>(),
      c.get<i66.UserService>(),
      c.get<i46.ApiTokenService>(),
      c.get<i67.AppSettings>(),
    ),
  );
  c.singleton<i62.RecurringService>(
    (IocContainer c) => i62.RecurringService(
      c.get<i36.RecurringExpenseRepository>(),
      c.get<i49.ExpenseService>(),
      c.get<i48.CategoryService>(),
      c.get<i39.AccountService>(),
      c.get<i38.UserRepository>(),
      c.get<i32.GroupRepository>(),
      c.get<i33.GroupMemberRepository>(),
    ),
  );
  c.singleton<i63.ReportService>(
    (IocContainer c) => i63.ReportService(
      c.get<i31.ExpenseRepository>(),
      c.get<i33.GroupMemberRepository>(),
      c.get<i38.UserRepository>(),
    ),
  );
  c.singleton<i64.ShoppingListService>(
    (IocContainer c) => i64.ShoppingListService(
      c.get<i37.ShoppingItemRepository>(),
      c.get<i58.LiveService>(),
    ),
  );
  c.singleton<i65.TotpService>(
    (IocContainer c) => i65.TotpService(
      c.get<i38.UserRepository>(),
      c.get<i46.ApiTokenService>(),
    ),
  );
  c.singleton<i66.UserService>(
    (IocContainer c) => i66.UserService(
      c.get<i38.UserRepository>(),
      c.get<i57.GroupService>(),
      c.get<i40.AccountShareService>(),
      c.get<i67.AppSettings>(),
    ),
  );
  c.singleton<i67.AppSettings>((IocContainer c) => i67.AppSettings());
  c.singleton<i68.StaticFiles>(
    (IocContainer c) => i68.StaticFiles(c.get<i67.AppSettings>()),
  );
  c.provider<i69.ORMProvider>((IocContainer c) => i69.ORMProvider());
  c.provider<i70.ScheduleProvider>((IocContainer c) => i70.ScheduleProvider());
  c.provider<i71.AppSocketIoProvider>(
    (IocContainer c) => i71.AppSocketIoProvider(),
  );
  c.router<i72.ApiRouter>((IocContainer c) => i72.ApiRouter());
  c.router<i73.WebRouter>((IocContainer c) => i73.WebRouter());
  c.bindModel<i74.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i74.Account().find(key);
  });
  c.bindModel<i75.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i75.AccountEntry().find(key);
  });
  c.bindModel<i76.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i76.AccountMember().find(key);
  });
  c.bindModel<i77.ApiToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i77.ApiToken().find(key);
  });
  c.bindModel<i78.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i78.Category().find(key);
  });
  c.bindModel<i79.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i79.Expense().find(key);
  });
  c.bindModel<i80.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i80.Group().find(key);
  });
  c.bindModel<i81.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i81.GroupMember().find(key);
  });
  c.bindModel<i82.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i82.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i83.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i83.McpToken().find(key);
  });
  c.bindModel<i84.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i84.Passkey().find(key);
  });
  c.bindModel<i85.RecurringExpense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i85.RecurringExpense().find(key);
  });
  c.bindModel<i86.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i86.ShoppingItem().find(key);
  });
  c.bindModel<i87.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i87.User().find(key);
  });
}
