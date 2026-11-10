// GENERATED CODE - DO NOT MODIFY BY HAND
// Made by dox_builder. Run `dart run build_runner build`.
// ignore_for_file: type=lint

import 'package:dox_core/dox_core.dart';
import 'package:api_dox/app/http/controllers/account.controller.dart' as i1;
import 'package:api_dox/app/http/controllers/category.controller.dart' as i2;
import 'package:api_dox/app/http/controllers/config.controller.dart' as i3;
import 'package:api_dox/app/http/controllers/expense.controller.dart' as i4;
import 'package:api_dox/app/http/controllers/group.controller.dart' as i5;
import 'package:api_dox/app/http/controllers/health.controller.dart' as i6;
import 'package:api_dox/app/http/controllers/mcp.controller.dart' as i7;
import 'package:api_dox/app/http/controllers/me.controller.dart' as i8;
import 'package:api_dox/app/http/controllers/oauth.controller.dart' as i9;
import 'package:api_dox/app/http/controllers/passkey.controller.dart' as i10;
import 'package:api_dox/app/http/controllers/recurring.controller.dart' as i11;
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart'
    as i12;
import 'package:api_dox/app/http/controllers/totp.controller.dart' as i13;
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i14;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i15;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i16;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i17;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i18;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i19;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i20;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i21;
import 'package:api_dox/app/repositories/account.repository.dart' as i22;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i23;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i24;
import 'package:api_dox/app/repositories/budget.repository.dart' as i25;
import 'package:api_dox/app/repositories/category.repository.dart' as i26;
import 'package:api_dox/app/repositories/expense.repository.dart' as i27;
import 'package:api_dox/app/repositories/group.repository.dart' as i28;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i29;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i30;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i31;
import 'package:api_dox/app/repositories/recurring_expense.repository.dart'
    as i32;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i33;
import 'package:api_dox/app/repositories/user.repository.dart' as i34;
import 'package:api_dox/app/services/account.service.dart' as i35;
import 'package:api_dox/app/services/account_share.service.dart' as i36;
import 'package:api_dox/app/services/ai/claude_client.dart' as i37;
import 'package:api_dox/app/services/ai/quick_add_picker.dart' as i38;
import 'package:api_dox/app/services/budget.service.dart' as i39;
import 'package:api_dox/app/services/category.service.dart' as i40;
import 'package:api_dox/app/services/expense.service.dart' as i41;
import 'package:api_dox/app/services/file_cache.dart' as i42;
import 'package:api_dox/app/services/firebase.service.dart' as i43;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i44;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i45;
import 'package:api_dox/app/services/fx/fx.service.dart' as i46;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i47;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i48;
import 'package:api_dox/app/services/group.service.dart' as i49;
import 'package:api_dox/app/services/live.service.dart' as i50;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i51;
import 'package:api_dox/app/services/mcp_token.service.dart' as i52;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i53;
import 'package:api_dox/app/services/recurring.service.dart' as i54;
import 'package:api_dox/app/services/report.service.dart' as i55;
import 'package:api_dox/app/services/shopping_list.service.dart' as i56;
import 'package:api_dox/app/services/totp/totp.service.dart' as i57;
import 'package:api_dox/app/services/user.service.dart' as i58;
import 'package:api_dox/config/settings.dart' as i59;
import 'package:api_dox/http/static_files.dart' as i60;
import 'package:api_dox/providers/orm_provider.dart' as i61;
import 'package:api_dox/providers/schedule_provider.dart' as i62;
import 'package:api_dox/providers/socket_io_provider.dart' as i63;
import 'package:api_dox/routes/api.dart' as i64;
import 'package:api_dox/routes/web.dart' as i65;
import 'package:api_dox/app/models/account/account.model.dart' as i66;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i67;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i68;
import 'package:api_dox/app/models/category/category.model.dart' as i69;
import 'package:api_dox/app/models/expense/expense.model.dart' as i70;
import 'package:api_dox/app/models/group/group.model.dart' as i71;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i72;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i73;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i74;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i75;
import 'package:api_dox/app/models/recurring_expense/recurring_expense.model.dart'
    as i76;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i77;
import 'package:api_dox/app/models/user/user.model.dart' as i78;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i35.AccountService>(),
      c.get<i44.AccountTotalService>(),
      c.get<i46.FxService>(),
      c.get<i36.AccountShareService>(),
    ),
  );
  c.singleton<i2.CategoryController>(
    (IocContainer c) => i2.CategoryController(c.get<i40.CategoryService>()),
  );
  c.singleton<i3.ConfigController>(
    (IocContainer c) => i3.ConfigController(c.get<i59.AppSettings>()),
  );
  c.singleton<i4.ExpenseController>(
    (IocContainer c) => i4.ExpenseController(
      c.get<i41.ExpenseService>(),
      c.get<i55.ReportService>(),
    ),
  );
  c.singleton<i5.GroupController>(
    (IocContainer c) => i5.GroupController(
      c.get<i49.GroupService>(),
      c.get<i39.BudgetService>(),
    ),
  );
  c.singleton<i6.HealthController>((IocContainer c) => i6.HealthController());
  c.singleton<i7.McpController>(
    (IocContainer c) => i7.McpController(
      c.get<i51.McpOAuthService>(),
      c.get<i16.McpToolRegistry>(),
    ),
  );
  c.singleton<i8.MeController>(
    (IocContainer c) => i8.MeController(
      c.get<i51.McpOAuthService>(),
      c.get<i52.McpTokenService>(),
    ),
  );
  c.singleton<i9.OauthController>(
    (IocContainer c) => i9.OauthController(
      c.get<i51.McpOAuthService>(),
      c.get<i52.McpTokenService>(),
    ),
  );
  c.singleton<i10.PasskeyController>(
    (IocContainer c) => i10.PasskeyController(c.get<i53.PasskeyService>()),
  );
  c.singleton<i11.RecurringController>(
    (IocContainer c) => i11.RecurringController(c.get<i54.RecurringService>()),
  );
  c.singleton<i12.ShoppingItemController>(
    (IocContainer c) =>
        i12.ShoppingItemController(c.get<i56.ShoppingListService>()),
  );
  c.singleton<i13.TotpController>(
    (IocContainer c) => i13.TotpController(c.get<i57.TotpService>()),
  );
  c.singleton<i14.AuthMiddleware>(
    (IocContainer c) => i14.AuthMiddleware(
      c.get<i43.FirebaseService>(),
      c.get<i58.UserService>(),
    ),
  );
  c.singleton<i15.GroupMiddleware>(
    (IocContainer c) => i15.GroupMiddleware(c.get<i49.GroupService>()),
  );
  c.singleton<i16.McpToolRegistry>(
    (IocContainer c) => i16.McpToolRegistry(
      c.get<i19.GetMeTool>(),
      c.get<i19.ListGroupsTool>(),
      c.get<i19.CreateGroupTool>(),
      c.get<i19.UpdateGroupTool>(),
      c.get<i19.ListGroupMembersTool>(),
      c.get<i19.InviteGroupMemberTool>(),
      c.get<i19.RemoveGroupMemberTool>(),
      c.get<i19.LeaveGroupTool>(),
      c.get<i19.GetBudgetTool>(),
      c.get<i19.SetBudgetTool>(),
      c.get<i19.GetDefaultWalletTool>(),
      c.get<i19.SetDefaultWalletTool>(),
      c.get<i17.ListCategoriesTool>(),
      c.get<i17.CreateCategoryTool>(),
      c.get<i17.UpdateCategoryTool>(),
      c.get<i17.DeleteCategoryTool>(),
      c.get<i18.AddExpenseTool>(),
      c.get<i18.ListExpensesTool>(),
      c.get<i18.FrequentExpensesTool>(),
      c.get<i18.UpdateExpenseTool>(),
      c.get<i18.DeleteExpenseTool>(),
      c.get<i18.MonthlySummaryTool>(),
      c.get<i21.ListWalletsTool>(),
      c.get<i21.CreateWalletTool>(),
      c.get<i21.UpdateWalletTool>(),
      c.get<i21.DeleteWalletTool>(),
      c.get<i21.WalletTotalTool>(),
      c.get<i21.WalletHistoryTool>(),
      c.get<i21.TransferBetweenWalletsTool>(),
      c.get<i21.ListWalletMembersTool>(),
      c.get<i21.InviteWalletMemberTool>(),
      c.get<i21.RemoveWalletMemberTool>(),
      c.get<i21.ListWalletEntriesTool>(),
      c.get<i21.RecentWalletEntriesTool>(),
      c.get<i21.AddWalletEntryTool>(),
      c.get<i21.UpdateWalletEntryTool>(),
      c.get<i21.DeleteWalletEntryTool>(),
      c.get<i21.AdjustWalletBalanceTool>(),
      c.get<i21.ExchangeRatesTool>(),
      c.get<i20.ListShoppingItemsTool>(),
      c.get<i20.AddShoppingItemTool>(),
      c.get<i20.UpdateShoppingItemTool>(),
      c.get<i20.DeleteShoppingItemTool>(),
      c.get<i20.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i17.ListCategoriesTool>(
    (IocContainer c) => i17.ListCategoriesTool(
      c.get<i49.GroupService>(),
      c.get<i40.CategoryService>(),
    ),
  );
  c.singleton<i17.CreateCategoryTool>(
    (IocContainer c) => i17.CreateCategoryTool(
      c.get<i49.GroupService>(),
      c.get<i40.CategoryService>(),
    ),
  );
  c.singleton<i17.UpdateCategoryTool>(
    (IocContainer c) => i17.UpdateCategoryTool(
      c.get<i49.GroupService>(),
      c.get<i40.CategoryService>(),
    ),
  );
  c.singleton<i17.DeleteCategoryTool>(
    (IocContainer c) => i17.DeleteCategoryTool(
      c.get<i49.GroupService>(),
      c.get<i40.CategoryService>(),
    ),
  );
  c.singleton<i18.AddExpenseTool>(
    (IocContainer c) => i18.AddExpenseTool(
      c.get<i49.GroupService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i18.ListExpensesTool>(
    (IocContainer c) => i18.ListExpensesTool(
      c.get<i49.GroupService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i18.FrequentExpensesTool>(
    (IocContainer c) => i18.FrequentExpensesTool(
      c.get<i49.GroupService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i18.UpdateExpenseTool>(
    (IocContainer c) => i18.UpdateExpenseTool(
      c.get<i49.GroupService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i18.DeleteExpenseTool>(
    (IocContainer c) => i18.DeleteExpenseTool(
      c.get<i49.GroupService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i18.MonthlySummaryTool>(
    (IocContainer c) => i18.MonthlySummaryTool(
      c.get<i49.GroupService>(),
      c.get<i40.CategoryService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i19.GetMeTool>(
    (IocContainer c) => i19.GetMeTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.ListGroupsTool>(
    (IocContainer c) => i19.ListGroupsTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.CreateGroupTool>(
    (IocContainer c) => i19.CreateGroupTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.UpdateGroupTool>(
    (IocContainer c) => i19.UpdateGroupTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.ListGroupMembersTool>(
    (IocContainer c) => i19.ListGroupMembersTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.InviteGroupMemberTool>(
    (IocContainer c) => i19.InviteGroupMemberTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.RemoveGroupMemberTool>(
    (IocContainer c) => i19.RemoveGroupMemberTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.LeaveGroupTool>(
    (IocContainer c) => i19.LeaveGroupTool(c.get<i49.GroupService>()),
  );
  c.singleton<i19.GetBudgetTool>(
    (IocContainer c) => i19.GetBudgetTool(
      c.get<i49.GroupService>(),
      c.get<i41.ExpenseService>(),
    ),
  );
  c.singleton<i19.SetBudgetTool>(
    (IocContainer c) => i19.SetBudgetTool(
      c.get<i49.GroupService>(),
      c.get<i39.BudgetService>(),
    ),
  );
  c.singleton<i19.GetDefaultWalletTool>(
    (IocContainer c) => i19.GetDefaultWalletTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i19.SetDefaultWalletTool>(
    (IocContainer c) => i19.SetDefaultWalletTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i20.ListShoppingItemsTool>(
    (IocContainer c) => i20.ListShoppingItemsTool(
      c.get<i49.GroupService>(),
      c.get<i56.ShoppingListService>(),
    ),
  );
  c.singleton<i20.AddShoppingItemTool>(
    (IocContainer c) => i20.AddShoppingItemTool(
      c.get<i49.GroupService>(),
      c.get<i56.ShoppingListService>(),
    ),
  );
  c.singleton<i20.UpdateShoppingItemTool>(
    (IocContainer c) => i20.UpdateShoppingItemTool(
      c.get<i49.GroupService>(),
      c.get<i56.ShoppingListService>(),
    ),
  );
  c.singleton<i20.DeleteShoppingItemTool>(
    (IocContainer c) => i20.DeleteShoppingItemTool(
      c.get<i49.GroupService>(),
      c.get<i56.ShoppingListService>(),
    ),
  );
  c.singleton<i20.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i20.ClearDoneShoppingItemsTool(
      c.get<i49.GroupService>(),
      c.get<i56.ShoppingListService>(),
    ),
  );
  c.singleton<i21.ListWalletsTool>(
    (IocContainer c) => i21.ListWalletsTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.CreateWalletTool>(
    (IocContainer c) => i21.CreateWalletTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.UpdateWalletTool>(
    (IocContainer c) => i21.UpdateWalletTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.DeleteWalletTool>(
    (IocContainer c) => i21.DeleteWalletTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.WalletTotalTool>(
    (IocContainer c) => i21.WalletTotalTool(
      c.get<i49.GroupService>(),
      c.get<i44.AccountTotalService>(),
    ),
  );
  c.singleton<i21.WalletHistoryTool>(
    (IocContainer c) => i21.WalletHistoryTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.TransferBetweenWalletsTool>(
    (IocContainer c) => i21.TransferBetweenWalletsTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.ListWalletMembersTool>(
    (IocContainer c) => i21.ListWalletMembersTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
      c.get<i36.AccountShareService>(),
    ),
  );
  c.singleton<i21.InviteWalletMemberTool>(
    (IocContainer c) => i21.InviteWalletMemberTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
      c.get<i36.AccountShareService>(),
    ),
  );
  c.singleton<i21.RemoveWalletMemberTool>(
    (IocContainer c) => i21.RemoveWalletMemberTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
      c.get<i36.AccountShareService>(),
    ),
  );
  c.singleton<i21.ListWalletEntriesTool>(
    (IocContainer c) => i21.ListWalletEntriesTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.RecentWalletEntriesTool>(
    (IocContainer c) => i21.RecentWalletEntriesTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.AddWalletEntryTool>(
    (IocContainer c) => i21.AddWalletEntryTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.UpdateWalletEntryTool>(
    (IocContainer c) => i21.UpdateWalletEntryTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.DeleteWalletEntryTool>(
    (IocContainer c) => i21.DeleteWalletEntryTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.AdjustWalletBalanceTool>(
    (IocContainer c) => i21.AdjustWalletBalanceTool(
      c.get<i49.GroupService>(),
      c.get<i35.AccountService>(),
    ),
  );
  c.singleton<i21.ExchangeRatesTool>(
    (IocContainer c) => i21.ExchangeRatesTool(
      c.get<i49.GroupService>(),
      c.get<i46.FxService>(),
    ),
  );
  c.singleton<i22.AccountRepository>(
    (IocContainer c) => i22.AccountRepository(),
  );
  c.singleton<i23.AccountEntryRepository>(
    (IocContainer c) => i23.AccountEntryRepository(),
  );
  c.singleton<i24.AccountMemberRepository>(
    (IocContainer c) => i24.AccountMemberRepository(),
  );
  c.singleton<i25.BudgetRepository>((IocContainer c) => i25.BudgetRepository());
  c.singleton<i26.CategoryRepository>(
    (IocContainer c) => i26.CategoryRepository(),
  );
  c.singleton<i27.ExpenseRepository>(
    (IocContainer c) => i27.ExpenseRepository(),
  );
  c.singleton<i28.GroupRepository>((IocContainer c) => i28.GroupRepository());
  c.singleton<i29.GroupMemberRepository>(
    (IocContainer c) => i29.GroupMemberRepository(),
  );
  c.singleton<i30.McpTokenRepository>(
    (IocContainer c) => i30.McpTokenRepository(),
  );
  c.singleton<i31.PasskeyRepository>(
    (IocContainer c) => i31.PasskeyRepository(),
  );
  c.singleton<i32.RecurringExpenseRepository>(
    (IocContainer c) => i32.RecurringExpenseRepository(),
  );
  c.singleton<i33.ShoppingItemRepository>(
    (IocContainer c) => i33.ShoppingItemRepository(),
  );
  c.singleton<i34.UserRepository>((IocContainer c) => i34.UserRepository());
  c.singleton<i35.AccountService>(
    (IocContainer c) => i35.AccountService(
      c.get<i22.AccountRepository>(),
      c.get<i23.AccountEntryRepository>(),
      c.get<i29.GroupMemberRepository>(),
      c.get<i24.AccountMemberRepository>(),
      c.get<i36.AccountShareService>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i36.AccountShareService>(
    (IocContainer c) => i36.AccountShareService(
      c.get<i24.AccountMemberRepository>(),
      c.get<i34.UserRepository>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i37.ClaudeClient>(
    (IocContainer c) => i37.ClaudeClient(c.get<i59.AppSettings>()),
  );
  c.singleton<i38.QuickAddPicker>(
    (IocContainer c) =>
        i38.QuickAddPicker(c.get<i37.ClaudeClient>(), c.get<i42.FileCache>()),
  );
  c.singleton<i39.BudgetService>(
    (IocContainer c) => i39.BudgetService(
      c.get<i25.BudgetRepository>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i40.CategoryService>(
    (IocContainer c) => i40.CategoryService(
      c.get<i26.CategoryRepository>(),
      c.get<i27.ExpenseRepository>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i41.ExpenseService>(
    (IocContainer c) => i41.ExpenseService(
      c.get<i27.ExpenseRepository>(),
      c.get<i40.CategoryService>(),
      c.get<i39.BudgetService>(),
      c.get<i35.AccountService>(),
      c.get<i50.LiveService>(),
      c.get<i38.QuickAddPicker>(),
    ),
  );
  c.singleton<i42.FileCache>((IocContainer c) => i42.FileCache());
  c.singleton<i43.FirebaseService>(
    (IocContainer c) => i43.FirebaseService(c.get<i59.AppSettings>()),
  );
  c.singleton<i44.AccountTotalService>(
    (IocContainer c) => i44.AccountTotalService(
      c.get<i35.AccountService>(),
      c.get<i46.FxService>(),
    ),
  );
  c.singleton<i45.CoinbaseRateProvider>(
    (IocContainer c) => i45.CoinbaseRateProvider(
      c.get<i42.FileCache>(),
      c.get<i48.HttpFetch>(),
    ),
  );
  c.singleton<i46.FxService>(
    (IocContainer c) => i46.FxService(
      c.get<i45.CoinbaseRateProvider>(),
      c.get<i47.GoldQuoteProvider>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i47.GoldQuoteProvider>(
    (IocContainer c) =>
        i47.GoldQuoteProvider(c.get<i42.FileCache>(), c.get<i48.HttpFetch>()),
  );
  c.singleton<i48.HttpFetch>((IocContainer c) => i48.HttpFetch());
  c.singleton<i49.GroupService>(
    (IocContainer c) => i49.GroupService(
      c.get<i28.GroupRepository>(),
      c.get<i29.GroupMemberRepository>(),
      c.get<i26.CategoryRepository>(),
      c.get<i34.UserRepository>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i50.LiveService>(
    (IocContainer c) => i50.LiveService(
      c.get<i29.GroupMemberRepository>(),
      c.get<i22.AccountRepository>(),
      c.get<i24.AccountMemberRepository>(),
      c.get<i23.AccountEntryRepository>(),
    ),
  );
  c.singleton<i51.McpOAuthService>(
    (IocContainer c) => i51.McpOAuthService(
      c.get<i59.AppSettings>(),
      c.get<i52.McpTokenService>(),
    ),
  );
  c.singleton<i52.McpTokenService>(
    (IocContainer c) => i52.McpTokenService(
      c.get<i30.McpTokenRepository>(),
      c.get<i34.UserRepository>(),
      c.get<i58.UserService>(),
    ),
  );
  c.singleton<i53.PasskeyService>(
    (IocContainer c) => i53.PasskeyService(
      c.get<i31.PasskeyRepository>(),
      c.get<i34.UserRepository>(),
      c.get<i58.UserService>(),
      c.get<i43.FirebaseService>(),
      c.get<i59.AppSettings>(),
    ),
  );
  c.singleton<i54.RecurringService>(
    (IocContainer c) => i54.RecurringService(
      c.get<i32.RecurringExpenseRepository>(),
      c.get<i41.ExpenseService>(),
      c.get<i40.CategoryService>(),
      c.get<i35.AccountService>(),
      c.get<i34.UserRepository>(),
      c.get<i28.GroupRepository>(),
      c.get<i29.GroupMemberRepository>(),
    ),
  );
  c.singleton<i55.ReportService>(
    (IocContainer c) => i55.ReportService(
      c.get<i27.ExpenseRepository>(),
      c.get<i29.GroupMemberRepository>(),
      c.get<i34.UserRepository>(),
    ),
  );
  c.singleton<i56.ShoppingListService>(
    (IocContainer c) => i56.ShoppingListService(
      c.get<i33.ShoppingItemRepository>(),
      c.get<i50.LiveService>(),
    ),
  );
  c.singleton<i57.TotpService>(
    (IocContainer c) => i57.TotpService(
      c.get<i34.UserRepository>(),
      c.get<i43.FirebaseService>(),
    ),
  );
  c.singleton<i58.UserService>(
    (IocContainer c) => i58.UserService(
      c.get<i34.UserRepository>(),
      c.get<i49.GroupService>(),
      c.get<i36.AccountShareService>(),
      c.get<i59.AppSettings>(),
    ),
  );
  c.singleton<i59.AppSettings>((IocContainer c) => i59.AppSettings());
  c.singleton<i60.StaticFiles>(
    (IocContainer c) => i60.StaticFiles(c.get<i59.AppSettings>()),
  );
  c.provider<i61.ORMProvider>((IocContainer c) => i61.ORMProvider());
  c.provider<i62.ScheduleProvider>((IocContainer c) => i62.ScheduleProvider());
  c.provider<i63.AppSocketIoProvider>(
    (IocContainer c) => i63.AppSocketIoProvider(),
  );
  c.router<i64.ApiRouter>((IocContainer c) => i64.ApiRouter());
  c.router<i65.WebRouter>((IocContainer c) => i65.WebRouter());
  c.bindModel<i66.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i66.Account().find(key);
  });
  c.bindModel<i67.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i67.AccountEntry().find(key);
  });
  c.bindModel<i68.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i68.AccountMember().find(key);
  });
  c.bindModel<i69.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i69.Category().find(key);
  });
  c.bindModel<i70.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i70.Expense().find(key);
  });
  c.bindModel<i71.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i71.Group().find(key);
  });
  c.bindModel<i72.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i72.GroupMember().find(key);
  });
  c.bindModel<i73.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i73.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i74.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i74.McpToken().find(key);
  });
  c.bindModel<i75.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i75.Passkey().find(key);
  });
  c.bindModel<i76.RecurringExpense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i76.RecurringExpense().find(key);
  });
  c.bindModel<i77.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i77.ShoppingItem().find(key);
  });
  c.bindModel<i78.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i78.User().find(key);
  });
}
