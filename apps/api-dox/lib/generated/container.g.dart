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
import 'package:api_dox/app/repositories/budget.repository.dart' as i28;
import 'package:api_dox/app/repositories/category.repository.dart' as i29;
import 'package:api_dox/app/repositories/expense.repository.dart' as i30;
import 'package:api_dox/app/repositories/group.repository.dart' as i31;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i32;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i33;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i34;
import 'package:api_dox/app/repositories/recurring_expense.repository.dart'
    as i35;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i36;
import 'package:api_dox/app/repositories/user.repository.dart' as i37;
import 'package:api_dox/app/services/account.service.dart' as i38;
import 'package:api_dox/app/services/account_share.service.dart' as i39;
import 'package:api_dox/app/services/ai/claude_client.dart' as i40;
import 'package:api_dox/app/services/ai/expense_categorizer.dart' as i41;
import 'package:api_dox/app/services/ai/month_insight.service.dart' as i42;
import 'package:api_dox/app/services/ai/quick_add_picker.dart' as i43;
import 'package:api_dox/app/services/ai/smart_add.service.dart' as i44;
import 'package:api_dox/app/services/api_token.service.dart' as i45;
import 'package:api_dox/app/services/budget.service.dart' as i46;
import 'package:api_dox/app/services/category.service.dart' as i47;
import 'package:api_dox/app/services/expense.service.dart' as i48;
import 'package:api_dox/app/services/file_cache.dart' as i49;
import 'package:api_dox/app/services/firebase.service.dart' as i50;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i51;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i52;
import 'package:api_dox/app/services/fx/fx.service.dart' as i53;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i54;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i55;
import 'package:api_dox/app/services/group.service.dart' as i56;
import 'package:api_dox/app/services/live.service.dart' as i57;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i58;
import 'package:api_dox/app/services/mcp_token.service.dart' as i59;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i60;
import 'package:api_dox/app/services/recurring.service.dart' as i61;
import 'package:api_dox/app/services/report.service.dart' as i62;
import 'package:api_dox/app/services/shopping_list.service.dart' as i63;
import 'package:api_dox/app/services/totp/totp.service.dart' as i64;
import 'package:api_dox/app/services/user.service.dart' as i65;
import 'package:api_dox/config/settings.dart' as i66;
import 'package:api_dox/http/static_files.dart' as i67;
import 'package:api_dox/routes/api.dart' as i68;
import 'package:api_dox/routes/web.dart' as i69;
import 'package:api_dox/app/models/account/account.model.dart' as i70;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i71;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i72;
import 'package:api_dox/app/models/category/category.model.dart' as i73;
import 'package:api_dox/app/models/expense/expense.model.dart' as i74;
import 'package:api_dox/app/models/group/group.model.dart' as i75;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i76;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i77;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i78;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i79;
import 'package:api_dox/app/models/recurring_expense/recurring_expense.model.dart'
    as i80;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i81;
import 'package:api_dox/app/models/user/user.model.dart' as i82;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i38.AccountService>(),
      c.get<i51.AccountTotalService>(),
      c.get<i53.FxService>(),
      c.get<i39.AccountShareService>(),
    ),
  );
  c.singleton<i2.AuthController>(
    (IocContainer c) => i2.AuthController(c.get<i45.ApiTokenService>()),
  );
  c.singleton<i3.CategoryController>(
    (IocContainer c) => i3.CategoryController(c.get<i47.CategoryService>()),
  );
  c.singleton<i4.ConfigController>(
    (IocContainer c) => i4.ConfigController(c.get<i66.AppSettings>()),
  );
  c.singleton<i5.ExpenseController>(
    (IocContainer c) => i5.ExpenseController(
      c.get<i48.ExpenseService>(),
      c.get<i62.ReportService>(),
    ),
  );
  c.singleton<i6.GroupController>(
    (IocContainer c) => i6.GroupController(
      c.get<i56.GroupService>(),
      c.get<i46.BudgetService>(),
    ),
  );
  c.singleton<i7.HealthController>((IocContainer c) => i7.HealthController());
  c.singleton<i8.InsightController>(
    (IocContainer c) => i8.InsightController(c.get<i42.MonthInsightService>()),
  );
  c.singleton<i9.McpController>(
    (IocContainer c) => i9.McpController(
      c.get<i58.McpOAuthService>(),
      c.get<i19.McpToolRegistry>(),
    ),
  );
  c.singleton<i10.MeController>(
    (IocContainer c) => i10.MeController(
      c.get<i58.McpOAuthService>(),
      c.get<i59.McpTokenService>(),
    ),
  );
  c.singleton<i11.OauthController>(
    (IocContainer c) => i11.OauthController(
      c.get<i58.McpOAuthService>(),
      c.get<i59.McpTokenService>(),
    ),
  );
  c.singleton<i12.PasskeyController>(
    (IocContainer c) => i12.PasskeyController(c.get<i60.PasskeyService>()),
  );
  c.singleton<i13.RecurringController>(
    (IocContainer c) => i13.RecurringController(c.get<i61.RecurringService>()),
  );
  c.singleton<i14.ShoppingItemController>(
    (IocContainer c) =>
        i14.ShoppingItemController(c.get<i63.ShoppingListService>()),
  );
  c.singleton<i15.SmartAddController>(
    (IocContainer c) => i15.SmartAddController(c.get<i44.SmartAddService>()),
  );
  c.singleton<i16.TotpController>(
    (IocContainer c) => i16.TotpController(c.get<i64.TotpService>()),
  );
  c.singleton<i17.AuthMiddleware>(
    (IocContainer c) => i17.AuthMiddleware(c.get<i45.ApiTokenService>()),
  );
  c.singleton<i18.GroupMiddleware>(
    (IocContainer c) => i18.GroupMiddleware(c.get<i56.GroupService>()),
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
      c.get<i56.GroupService>(),
      c.get<i47.CategoryService>(),
    ),
  );
  c.singleton<i20.CreateCategoryTool>(
    (IocContainer c) => i20.CreateCategoryTool(
      c.get<i56.GroupService>(),
      c.get<i47.CategoryService>(),
    ),
  );
  c.singleton<i20.UpdateCategoryTool>(
    (IocContainer c) => i20.UpdateCategoryTool(
      c.get<i56.GroupService>(),
      c.get<i47.CategoryService>(),
    ),
  );
  c.singleton<i20.DeleteCategoryTool>(
    (IocContainer c) => i20.DeleteCategoryTool(
      c.get<i56.GroupService>(),
      c.get<i47.CategoryService>(),
    ),
  );
  c.singleton<i21.AddExpenseTool>(
    (IocContainer c) => i21.AddExpenseTool(
      c.get<i56.GroupService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i21.ListExpensesTool>(
    (IocContainer c) => i21.ListExpensesTool(
      c.get<i56.GroupService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i21.FrequentExpensesTool>(
    (IocContainer c) => i21.FrequentExpensesTool(
      c.get<i56.GroupService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i21.UpdateExpenseTool>(
    (IocContainer c) => i21.UpdateExpenseTool(
      c.get<i56.GroupService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i21.DeleteExpenseTool>(
    (IocContainer c) => i21.DeleteExpenseTool(
      c.get<i56.GroupService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i21.MonthlySummaryTool>(
    (IocContainer c) => i21.MonthlySummaryTool(
      c.get<i56.GroupService>(),
      c.get<i47.CategoryService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i22.GetMeTool>(
    (IocContainer c) => i22.GetMeTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.ListGroupsTool>(
    (IocContainer c) => i22.ListGroupsTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.CreateGroupTool>(
    (IocContainer c) => i22.CreateGroupTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.UpdateGroupTool>(
    (IocContainer c) => i22.UpdateGroupTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.ListGroupMembersTool>(
    (IocContainer c) => i22.ListGroupMembersTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.InviteGroupMemberTool>(
    (IocContainer c) => i22.InviteGroupMemberTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.RemoveGroupMemberTool>(
    (IocContainer c) => i22.RemoveGroupMemberTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.LeaveGroupTool>(
    (IocContainer c) => i22.LeaveGroupTool(c.get<i56.GroupService>()),
  );
  c.singleton<i22.GetBudgetTool>(
    (IocContainer c) => i22.GetBudgetTool(
      c.get<i56.GroupService>(),
      c.get<i48.ExpenseService>(),
    ),
  );
  c.singleton<i22.SetBudgetTool>(
    (IocContainer c) => i22.SetBudgetTool(
      c.get<i56.GroupService>(),
      c.get<i46.BudgetService>(),
    ),
  );
  c.singleton<i22.GetDefaultWalletTool>(
    (IocContainer c) => i22.GetDefaultWalletTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i22.SetDefaultWalletTool>(
    (IocContainer c) => i22.SetDefaultWalletTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i23.ListShoppingItemsTool>(
    (IocContainer c) => i23.ListShoppingItemsTool(
      c.get<i56.GroupService>(),
      c.get<i63.ShoppingListService>(),
    ),
  );
  c.singleton<i23.AddShoppingItemTool>(
    (IocContainer c) => i23.AddShoppingItemTool(
      c.get<i56.GroupService>(),
      c.get<i63.ShoppingListService>(),
    ),
  );
  c.singleton<i23.UpdateShoppingItemTool>(
    (IocContainer c) => i23.UpdateShoppingItemTool(
      c.get<i56.GroupService>(),
      c.get<i63.ShoppingListService>(),
    ),
  );
  c.singleton<i23.DeleteShoppingItemTool>(
    (IocContainer c) => i23.DeleteShoppingItemTool(
      c.get<i56.GroupService>(),
      c.get<i63.ShoppingListService>(),
    ),
  );
  c.singleton<i23.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i23.ClearDoneShoppingItemsTool(
      c.get<i56.GroupService>(),
      c.get<i63.ShoppingListService>(),
    ),
  );
  c.singleton<i24.ListWalletsTool>(
    (IocContainer c) => i24.ListWalletsTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.CreateWalletTool>(
    (IocContainer c) => i24.CreateWalletTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.UpdateWalletTool>(
    (IocContainer c) => i24.UpdateWalletTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.DeleteWalletTool>(
    (IocContainer c) => i24.DeleteWalletTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.WalletTotalTool>(
    (IocContainer c) => i24.WalletTotalTool(
      c.get<i56.GroupService>(),
      c.get<i51.AccountTotalService>(),
    ),
  );
  c.singleton<i24.WalletHistoryTool>(
    (IocContainer c) => i24.WalletHistoryTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.TransferBetweenWalletsTool>(
    (IocContainer c) => i24.TransferBetweenWalletsTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.ListWalletMembersTool>(
    (IocContainer c) => i24.ListWalletMembersTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
      c.get<i39.AccountShareService>(),
    ),
  );
  c.singleton<i24.InviteWalletMemberTool>(
    (IocContainer c) => i24.InviteWalletMemberTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
      c.get<i39.AccountShareService>(),
    ),
  );
  c.singleton<i24.RemoveWalletMemberTool>(
    (IocContainer c) => i24.RemoveWalletMemberTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
      c.get<i39.AccountShareService>(),
    ),
  );
  c.singleton<i24.ListWalletEntriesTool>(
    (IocContainer c) => i24.ListWalletEntriesTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.RecentWalletEntriesTool>(
    (IocContainer c) => i24.RecentWalletEntriesTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.AddWalletEntryTool>(
    (IocContainer c) => i24.AddWalletEntryTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.UpdateWalletEntryTool>(
    (IocContainer c) => i24.UpdateWalletEntryTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.DeleteWalletEntryTool>(
    (IocContainer c) => i24.DeleteWalletEntryTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.AdjustWalletBalanceTool>(
    (IocContainer c) => i24.AdjustWalletBalanceTool(
      c.get<i56.GroupService>(),
      c.get<i38.AccountService>(),
    ),
  );
  c.singleton<i24.ExchangeRatesTool>(
    (IocContainer c) => i24.ExchangeRatesTool(
      c.get<i56.GroupService>(),
      c.get<i53.FxService>(),
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
  c.singleton<i28.BudgetRepository>((IocContainer c) => i28.BudgetRepository());
  c.singleton<i29.CategoryRepository>(
    (IocContainer c) => i29.CategoryRepository(),
  );
  c.singleton<i30.ExpenseRepository>(
    (IocContainer c) => i30.ExpenseRepository(),
  );
  c.singleton<i31.GroupRepository>((IocContainer c) => i31.GroupRepository());
  c.singleton<i32.GroupMemberRepository>(
    (IocContainer c) => i32.GroupMemberRepository(),
  );
  c.singleton<i33.McpTokenRepository>(
    (IocContainer c) => i33.McpTokenRepository(),
  );
  c.singleton<i34.PasskeyRepository>(
    (IocContainer c) => i34.PasskeyRepository(),
  );
  c.singleton<i35.RecurringExpenseRepository>(
    (IocContainer c) => i35.RecurringExpenseRepository(),
  );
  c.singleton<i36.ShoppingItemRepository>(
    (IocContainer c) => i36.ShoppingItemRepository(),
  );
  c.singleton<i37.UserRepository>((IocContainer c) => i37.UserRepository());
  c.singleton<i38.AccountService>(
    (IocContainer c) => i38.AccountService(
      c.get<i25.AccountRepository>(),
      c.get<i26.AccountEntryRepository>(),
      c.get<i32.GroupMemberRepository>(),
      c.get<i27.AccountMemberRepository>(),
      c.get<i39.AccountShareService>(),
      c.get<i57.LiveService>(),
      c.get<i30.ExpenseRepository>(),
    ),
  );
  c.singleton<i39.AccountShareService>(
    (IocContainer c) => i39.AccountShareService(
      c.get<i27.AccountMemberRepository>(),
      c.get<i37.UserRepository>(),
      c.get<i57.LiveService>(),
    ),
  );
  c.singleton<i40.ClaudeClient>(
    (IocContainer c) => i40.ClaudeClient(c.get<i66.AppSettings>()),
  );
  c.singleton<i41.ExpenseCategorizer>(
    (IocContainer c) => i41.ExpenseCategorizer(
      c.get<i40.ClaudeClient>(),
      c.get<i30.ExpenseRepository>(),
    ),
  );
  c.singleton<i42.MonthInsightService>(
    (IocContainer c) => i42.MonthInsightService(
      c.get<i48.ExpenseService>(),
      c.get<i47.CategoryService>(),
      c.get<i40.ClaudeClient>(),
      c.get<i49.FileCache>(),
    ),
  );
  c.singleton<i43.QuickAddPicker>(
    (IocContainer c) =>
        i43.QuickAddPicker(c.get<i40.ClaudeClient>(), c.get<i49.FileCache>()),
  );
  c.singleton<i44.SmartAddService>(
    (IocContainer c) => i44.SmartAddService(
      c.get<i40.ClaudeClient>(),
      c.get<i38.AccountService>(),
      c.get<i48.ExpenseService>(),
      c.get<i47.CategoryService>(),
      c.get<i41.ExpenseCategorizer>(),
    ),
  );
  c.singleton<i45.ApiTokenService>(
    (IocContainer c) => i45.ApiTokenService(
      c.get<i65.UserService>(),
      c.get<i50.FirebaseService>(),
    ),
  );
  c.singleton<i46.BudgetService>(
    (IocContainer c) => i46.BudgetService(
      c.get<i28.BudgetRepository>(),
      c.get<i57.LiveService>(),
    ),
  );
  c.singleton<i47.CategoryService>(
    (IocContainer c) => i47.CategoryService(
      c.get<i29.CategoryRepository>(),
      c.get<i30.ExpenseRepository>(),
      c.get<i57.LiveService>(),
    ),
  );
  c.singleton<i48.ExpenseService>(
    (IocContainer c) => i48.ExpenseService(
      c.get<i30.ExpenseRepository>(),
      c.get<i47.CategoryService>(),
      c.get<i46.BudgetService>(),
      c.get<i38.AccountService>(),
      c.get<i57.LiveService>(),
      c.get<i43.QuickAddPicker>(),
      c.get<i41.ExpenseCategorizer>(),
    ),
  );
  c.singleton<i49.FileCache>((IocContainer c) => i49.FileCache());
  c.singleton<i50.FirebaseService>(
    (IocContainer c) => i50.FirebaseService(c.get<i66.AppSettings>()),
  );
  c.singleton<i51.AccountTotalService>(
    (IocContainer c) => i51.AccountTotalService(
      c.get<i38.AccountService>(),
      c.get<i53.FxService>(),
    ),
  );
  c.singleton<i52.CoinbaseRateProvider>(
    (IocContainer c) => i52.CoinbaseRateProvider(
      c.get<i49.FileCache>(),
      c.get<i55.HttpFetch>(),
    ),
  );
  c.singleton<i53.FxService>(
    (IocContainer c) => i53.FxService(
      c.get<i52.CoinbaseRateProvider>(),
      c.get<i54.GoldQuoteProvider>(),
      c.get<i57.LiveService>(),
    ),
  );
  c.singleton<i54.GoldQuoteProvider>(
    (IocContainer c) =>
        i54.GoldQuoteProvider(c.get<i49.FileCache>(), c.get<i55.HttpFetch>()),
  );
  c.singleton<i55.HttpFetch>((IocContainer c) => i55.HttpFetch());
  c.singleton<i56.GroupService>(
    (IocContainer c) => i56.GroupService(
      c.get<i31.GroupRepository>(),
      c.get<i32.GroupMemberRepository>(),
      c.get<i29.CategoryRepository>(),
      c.get<i37.UserRepository>(),
      c.get<i57.LiveService>(),
    ),
  );
  c.singleton<i57.LiveService>(
    (IocContainer c) => i57.LiveService(
      c.get<i32.GroupMemberRepository>(),
      c.get<i25.AccountRepository>(),
      c.get<i27.AccountMemberRepository>(),
      c.get<i26.AccountEntryRepository>(),
    ),
  );
  c.singleton<i58.McpOAuthService>(
    (IocContainer c) => i58.McpOAuthService(
      c.get<i66.AppSettings>(),
      c.get<i59.McpTokenService>(),
    ),
  );
  c.singleton<i59.McpTokenService>(
    (IocContainer c) => i59.McpTokenService(
      c.get<i33.McpTokenRepository>(),
      c.get<i37.UserRepository>(),
      c.get<i65.UserService>(),
    ),
  );
  c.singleton<i60.PasskeyService>(
    (IocContainer c) => i60.PasskeyService(
      c.get<i34.PasskeyRepository>(),
      c.get<i37.UserRepository>(),
      c.get<i65.UserService>(),
      c.get<i45.ApiTokenService>(),
      c.get<i66.AppSettings>(),
    ),
  );
  c.singleton<i61.RecurringService>(
    (IocContainer c) => i61.RecurringService(
      c.get<i35.RecurringExpenseRepository>(),
      c.get<i48.ExpenseService>(),
      c.get<i47.CategoryService>(),
      c.get<i38.AccountService>(),
      c.get<i37.UserRepository>(),
      c.get<i31.GroupRepository>(),
      c.get<i32.GroupMemberRepository>(),
    ),
  );
  c.singleton<i62.ReportService>(
    (IocContainer c) => i62.ReportService(
      c.get<i30.ExpenseRepository>(),
      c.get<i32.GroupMemberRepository>(),
      c.get<i37.UserRepository>(),
    ),
  );
  c.singleton<i63.ShoppingListService>(
    (IocContainer c) => i63.ShoppingListService(
      c.get<i36.ShoppingItemRepository>(),
      c.get<i57.LiveService>(),
    ),
  );
  c.singleton<i64.TotpService>(
    (IocContainer c) => i64.TotpService(
      c.get<i37.UserRepository>(),
      c.get<i45.ApiTokenService>(),
    ),
  );
  c.singleton<i65.UserService>(
    (IocContainer c) => i65.UserService(
      c.get<i37.UserRepository>(),
      c.get<i56.GroupService>(),
      c.get<i39.AccountShareService>(),
      c.get<i66.AppSettings>(),
    ),
  );
  c.singleton<i66.AppSettings>((IocContainer c) => i66.AppSettings());
  c.singleton<i67.StaticFiles>(
    (IocContainer c) => i67.StaticFiles(c.get<i66.AppSettings>()),
  );
  c.router<i68.ApiRouter>((IocContainer c) => i68.ApiRouter());
  c.router<i69.WebRouter>((IocContainer c) => i69.WebRouter());
  c.bindModel<i70.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i70.Account().find(key);
  });
  c.bindModel<i71.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i71.AccountEntry().find(key);
  });
  c.bindModel<i72.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i72.AccountMember().find(key);
  });
  c.bindModel<i73.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i73.Category().find(key);
  });
  c.bindModel<i74.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i74.Expense().find(key);
  });
  c.bindModel<i75.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i75.Group().find(key);
  });
  c.bindModel<i76.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i76.GroupMember().find(key);
  });
  c.bindModel<i77.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i77.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i78.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i78.McpToken().find(key);
  });
  c.bindModel<i79.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i79.Passkey().find(key);
  });
  c.bindModel<i80.RecurringExpense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i80.RecurringExpense().find(key);
  });
  c.bindModel<i81.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i81.ShoppingItem().find(key);
  });
  c.bindModel<i82.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i82.User().find(key);
  });
}
