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
import 'package:api_dox/app/http/controllers/mcp.controller.dart' as i8;
import 'package:api_dox/app/http/controllers/me.controller.dart' as i9;
import 'package:api_dox/app/http/controllers/oauth.controller.dart' as i10;
import 'package:api_dox/app/http/controllers/passkey.controller.dart' as i11;
import 'package:api_dox/app/http/controllers/recurring.controller.dart' as i12;
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart'
    as i13;
import 'package:api_dox/app/http/controllers/totp.controller.dart' as i14;
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i15;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i16;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i17;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i18;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i19;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i20;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i21;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i22;
import 'package:api_dox/app/repositories/account.repository.dart' as i23;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i24;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i25;
import 'package:api_dox/app/repositories/budget.repository.dart' as i26;
import 'package:api_dox/app/repositories/category.repository.dart' as i27;
import 'package:api_dox/app/repositories/expense.repository.dart' as i28;
import 'package:api_dox/app/repositories/group.repository.dart' as i29;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i30;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i31;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i32;
import 'package:api_dox/app/repositories/recurring_expense.repository.dart'
    as i33;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i34;
import 'package:api_dox/app/repositories/user.repository.dart' as i35;
import 'package:api_dox/app/services/account.service.dart' as i36;
import 'package:api_dox/app/services/account_share.service.dart' as i37;
import 'package:api_dox/app/services/ai/claude_client.dart' as i38;
import 'package:api_dox/app/services/ai/quick_add_picker.dart' as i39;
import 'package:api_dox/app/services/api_token.service.dart' as i40;
import 'package:api_dox/app/services/budget.service.dart' as i41;
import 'package:api_dox/app/services/category.service.dart' as i42;
import 'package:api_dox/app/services/expense.service.dart' as i43;
import 'package:api_dox/app/services/file_cache.dart' as i44;
import 'package:api_dox/app/services/firebase.service.dart' as i45;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i46;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i47;
import 'package:api_dox/app/services/fx/fx.service.dart' as i48;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i49;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i50;
import 'package:api_dox/app/services/group.service.dart' as i51;
import 'package:api_dox/app/services/live.service.dart' as i52;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i53;
import 'package:api_dox/app/services/mcp_token.service.dart' as i54;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i55;
import 'package:api_dox/app/services/recurring.service.dart' as i56;
import 'package:api_dox/app/services/report.service.dart' as i57;
import 'package:api_dox/app/services/shopping_list.service.dart' as i58;
import 'package:api_dox/app/services/totp/totp.service.dart' as i59;
import 'package:api_dox/app/services/user.service.dart' as i60;
import 'package:api_dox/config/settings.dart' as i61;
import 'package:api_dox/http/static_files.dart' as i62;
import 'package:api_dox/providers/auth_provider.dart' as i63;
import 'package:api_dox/providers/orm_provider.dart' as i64;
import 'package:api_dox/providers/schedule_provider.dart' as i65;
import 'package:api_dox/providers/socket_io_provider.dart' as i66;
import 'package:api_dox/routes/api.dart' as i67;
import 'package:api_dox/routes/web.dart' as i68;
import 'package:api_dox/app/models/account/account.model.dart' as i69;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i70;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i71;
import 'package:api_dox/app/models/category/category.model.dart' as i72;
import 'package:api_dox/app/models/expense/expense.model.dart' as i73;
import 'package:api_dox/app/models/group/group.model.dart' as i74;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i75;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i76;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i77;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i78;
import 'package:api_dox/app/models/recurring_expense/recurring_expense.model.dart'
    as i79;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i80;
import 'package:api_dox/app/models/user/user.model.dart' as i81;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i36.AccountService>(),
      c.get<i46.AccountTotalService>(),
      c.get<i48.FxService>(),
      c.get<i37.AccountShareService>(),
    ),
  );
  c.singleton<i2.AuthController>(
    (IocContainer c) => i2.AuthController(c.get<i40.ApiTokenService>()),
  );
  c.singleton<i3.CategoryController>(
    (IocContainer c) => i3.CategoryController(c.get<i42.CategoryService>()),
  );
  c.singleton<i4.ConfigController>(
    (IocContainer c) => i4.ConfigController(c.get<i61.AppSettings>()),
  );
  c.singleton<i5.ExpenseController>(
    (IocContainer c) => i5.ExpenseController(
      c.get<i43.ExpenseService>(),
      c.get<i57.ReportService>(),
    ),
  );
  c.singleton<i6.GroupController>(
    (IocContainer c) => i6.GroupController(
      c.get<i51.GroupService>(),
      c.get<i41.BudgetService>(),
    ),
  );
  c.singleton<i7.HealthController>((IocContainer c) => i7.HealthController());
  c.singleton<i8.McpController>(
    (IocContainer c) => i8.McpController(
      c.get<i53.McpOAuthService>(),
      c.get<i17.McpToolRegistry>(),
    ),
  );
  c.singleton<i9.MeController>(
    (IocContainer c) => i9.MeController(
      c.get<i53.McpOAuthService>(),
      c.get<i54.McpTokenService>(),
    ),
  );
  c.singleton<i10.OauthController>(
    (IocContainer c) => i10.OauthController(
      c.get<i53.McpOAuthService>(),
      c.get<i54.McpTokenService>(),
    ),
  );
  c.singleton<i11.PasskeyController>(
    (IocContainer c) => i11.PasskeyController(c.get<i55.PasskeyService>()),
  );
  c.singleton<i12.RecurringController>(
    (IocContainer c) => i12.RecurringController(c.get<i56.RecurringService>()),
  );
  c.singleton<i13.ShoppingItemController>(
    (IocContainer c) =>
        i13.ShoppingItemController(c.get<i58.ShoppingListService>()),
  );
  c.singleton<i14.TotpController>(
    (IocContainer c) => i14.TotpController(c.get<i59.TotpService>()),
  );
  c.singleton<i15.AuthMiddleware>(
    (IocContainer c) => i15.AuthMiddleware(c.get<i40.ApiTokenService>()),
  );
  c.singleton<i16.GroupMiddleware>(
    (IocContainer c) => i16.GroupMiddleware(c.get<i51.GroupService>()),
  );
  c.singleton<i17.McpToolRegistry>(
    (IocContainer c) => i17.McpToolRegistry(
      c.get<i20.GetMeTool>(),
      c.get<i20.ListGroupsTool>(),
      c.get<i20.CreateGroupTool>(),
      c.get<i20.UpdateGroupTool>(),
      c.get<i20.ListGroupMembersTool>(),
      c.get<i20.InviteGroupMemberTool>(),
      c.get<i20.RemoveGroupMemberTool>(),
      c.get<i20.LeaveGroupTool>(),
      c.get<i20.GetBudgetTool>(),
      c.get<i20.SetBudgetTool>(),
      c.get<i20.GetDefaultWalletTool>(),
      c.get<i20.SetDefaultWalletTool>(),
      c.get<i18.ListCategoriesTool>(),
      c.get<i18.CreateCategoryTool>(),
      c.get<i18.UpdateCategoryTool>(),
      c.get<i18.DeleteCategoryTool>(),
      c.get<i19.AddExpenseTool>(),
      c.get<i19.ListExpensesTool>(),
      c.get<i19.FrequentExpensesTool>(),
      c.get<i19.UpdateExpenseTool>(),
      c.get<i19.DeleteExpenseTool>(),
      c.get<i19.MonthlySummaryTool>(),
      c.get<i22.ListWalletsTool>(),
      c.get<i22.CreateWalletTool>(),
      c.get<i22.UpdateWalletTool>(),
      c.get<i22.DeleteWalletTool>(),
      c.get<i22.WalletTotalTool>(),
      c.get<i22.WalletHistoryTool>(),
      c.get<i22.TransferBetweenWalletsTool>(),
      c.get<i22.ListWalletMembersTool>(),
      c.get<i22.InviteWalletMemberTool>(),
      c.get<i22.RemoveWalletMemberTool>(),
      c.get<i22.ListWalletEntriesTool>(),
      c.get<i22.RecentWalletEntriesTool>(),
      c.get<i22.AddWalletEntryTool>(),
      c.get<i22.UpdateWalletEntryTool>(),
      c.get<i22.DeleteWalletEntryTool>(),
      c.get<i22.AdjustWalletBalanceTool>(),
      c.get<i22.ExchangeRatesTool>(),
      c.get<i21.ListShoppingItemsTool>(),
      c.get<i21.AddShoppingItemTool>(),
      c.get<i21.UpdateShoppingItemTool>(),
      c.get<i21.DeleteShoppingItemTool>(),
      c.get<i21.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i18.ListCategoriesTool>(
    (IocContainer c) => i18.ListCategoriesTool(
      c.get<i51.GroupService>(),
      c.get<i42.CategoryService>(),
    ),
  );
  c.singleton<i18.CreateCategoryTool>(
    (IocContainer c) => i18.CreateCategoryTool(
      c.get<i51.GroupService>(),
      c.get<i42.CategoryService>(),
    ),
  );
  c.singleton<i18.UpdateCategoryTool>(
    (IocContainer c) => i18.UpdateCategoryTool(
      c.get<i51.GroupService>(),
      c.get<i42.CategoryService>(),
    ),
  );
  c.singleton<i18.DeleteCategoryTool>(
    (IocContainer c) => i18.DeleteCategoryTool(
      c.get<i51.GroupService>(),
      c.get<i42.CategoryService>(),
    ),
  );
  c.singleton<i19.AddExpenseTool>(
    (IocContainer c) => i19.AddExpenseTool(
      c.get<i51.GroupService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i19.ListExpensesTool>(
    (IocContainer c) => i19.ListExpensesTool(
      c.get<i51.GroupService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i19.FrequentExpensesTool>(
    (IocContainer c) => i19.FrequentExpensesTool(
      c.get<i51.GroupService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i19.UpdateExpenseTool>(
    (IocContainer c) => i19.UpdateExpenseTool(
      c.get<i51.GroupService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i19.DeleteExpenseTool>(
    (IocContainer c) => i19.DeleteExpenseTool(
      c.get<i51.GroupService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i19.MonthlySummaryTool>(
    (IocContainer c) => i19.MonthlySummaryTool(
      c.get<i51.GroupService>(),
      c.get<i42.CategoryService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i20.GetMeTool>(
    (IocContainer c) => i20.GetMeTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.ListGroupsTool>(
    (IocContainer c) => i20.ListGroupsTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.CreateGroupTool>(
    (IocContainer c) => i20.CreateGroupTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.UpdateGroupTool>(
    (IocContainer c) => i20.UpdateGroupTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.ListGroupMembersTool>(
    (IocContainer c) => i20.ListGroupMembersTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.InviteGroupMemberTool>(
    (IocContainer c) => i20.InviteGroupMemberTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.RemoveGroupMemberTool>(
    (IocContainer c) => i20.RemoveGroupMemberTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.LeaveGroupTool>(
    (IocContainer c) => i20.LeaveGroupTool(c.get<i51.GroupService>()),
  );
  c.singleton<i20.GetBudgetTool>(
    (IocContainer c) => i20.GetBudgetTool(
      c.get<i51.GroupService>(),
      c.get<i43.ExpenseService>(),
    ),
  );
  c.singleton<i20.SetBudgetTool>(
    (IocContainer c) => i20.SetBudgetTool(
      c.get<i51.GroupService>(),
      c.get<i41.BudgetService>(),
    ),
  );
  c.singleton<i20.GetDefaultWalletTool>(
    (IocContainer c) => i20.GetDefaultWalletTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i20.SetDefaultWalletTool>(
    (IocContainer c) => i20.SetDefaultWalletTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i21.ListShoppingItemsTool>(
    (IocContainer c) => i21.ListShoppingItemsTool(
      c.get<i51.GroupService>(),
      c.get<i58.ShoppingListService>(),
    ),
  );
  c.singleton<i21.AddShoppingItemTool>(
    (IocContainer c) => i21.AddShoppingItemTool(
      c.get<i51.GroupService>(),
      c.get<i58.ShoppingListService>(),
    ),
  );
  c.singleton<i21.UpdateShoppingItemTool>(
    (IocContainer c) => i21.UpdateShoppingItemTool(
      c.get<i51.GroupService>(),
      c.get<i58.ShoppingListService>(),
    ),
  );
  c.singleton<i21.DeleteShoppingItemTool>(
    (IocContainer c) => i21.DeleteShoppingItemTool(
      c.get<i51.GroupService>(),
      c.get<i58.ShoppingListService>(),
    ),
  );
  c.singleton<i21.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i21.ClearDoneShoppingItemsTool(
      c.get<i51.GroupService>(),
      c.get<i58.ShoppingListService>(),
    ),
  );
  c.singleton<i22.ListWalletsTool>(
    (IocContainer c) => i22.ListWalletsTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.CreateWalletTool>(
    (IocContainer c) => i22.CreateWalletTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.UpdateWalletTool>(
    (IocContainer c) => i22.UpdateWalletTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.DeleteWalletTool>(
    (IocContainer c) => i22.DeleteWalletTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.WalletTotalTool>(
    (IocContainer c) => i22.WalletTotalTool(
      c.get<i51.GroupService>(),
      c.get<i46.AccountTotalService>(),
    ),
  );
  c.singleton<i22.WalletHistoryTool>(
    (IocContainer c) => i22.WalletHistoryTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.TransferBetweenWalletsTool>(
    (IocContainer c) => i22.TransferBetweenWalletsTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.ListWalletMembersTool>(
    (IocContainer c) => i22.ListWalletMembersTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
      c.get<i37.AccountShareService>(),
    ),
  );
  c.singleton<i22.InviteWalletMemberTool>(
    (IocContainer c) => i22.InviteWalletMemberTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
      c.get<i37.AccountShareService>(),
    ),
  );
  c.singleton<i22.RemoveWalletMemberTool>(
    (IocContainer c) => i22.RemoveWalletMemberTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
      c.get<i37.AccountShareService>(),
    ),
  );
  c.singleton<i22.ListWalletEntriesTool>(
    (IocContainer c) => i22.ListWalletEntriesTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.RecentWalletEntriesTool>(
    (IocContainer c) => i22.RecentWalletEntriesTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.AddWalletEntryTool>(
    (IocContainer c) => i22.AddWalletEntryTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.UpdateWalletEntryTool>(
    (IocContainer c) => i22.UpdateWalletEntryTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.DeleteWalletEntryTool>(
    (IocContainer c) => i22.DeleteWalletEntryTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.AdjustWalletBalanceTool>(
    (IocContainer c) => i22.AdjustWalletBalanceTool(
      c.get<i51.GroupService>(),
      c.get<i36.AccountService>(),
    ),
  );
  c.singleton<i22.ExchangeRatesTool>(
    (IocContainer c) => i22.ExchangeRatesTool(
      c.get<i51.GroupService>(),
      c.get<i48.FxService>(),
    ),
  );
  c.singleton<i23.AccountRepository>(
    (IocContainer c) => i23.AccountRepository(),
  );
  c.singleton<i24.AccountEntryRepository>(
    (IocContainer c) => i24.AccountEntryRepository(),
  );
  c.singleton<i25.AccountMemberRepository>(
    (IocContainer c) => i25.AccountMemberRepository(),
  );
  c.singleton<i26.BudgetRepository>((IocContainer c) => i26.BudgetRepository());
  c.singleton<i27.CategoryRepository>(
    (IocContainer c) => i27.CategoryRepository(),
  );
  c.singleton<i28.ExpenseRepository>(
    (IocContainer c) => i28.ExpenseRepository(),
  );
  c.singleton<i29.GroupRepository>((IocContainer c) => i29.GroupRepository());
  c.singleton<i30.GroupMemberRepository>(
    (IocContainer c) => i30.GroupMemberRepository(),
  );
  c.singleton<i31.McpTokenRepository>(
    (IocContainer c) => i31.McpTokenRepository(),
  );
  c.singleton<i32.PasskeyRepository>(
    (IocContainer c) => i32.PasskeyRepository(),
  );
  c.singleton<i33.RecurringExpenseRepository>(
    (IocContainer c) => i33.RecurringExpenseRepository(),
  );
  c.singleton<i34.ShoppingItemRepository>(
    (IocContainer c) => i34.ShoppingItemRepository(),
  );
  c.singleton<i35.UserRepository>((IocContainer c) => i35.UserRepository());
  c.singleton<i36.AccountService>(
    (IocContainer c) => i36.AccountService(
      c.get<i23.AccountRepository>(),
      c.get<i24.AccountEntryRepository>(),
      c.get<i30.GroupMemberRepository>(),
      c.get<i25.AccountMemberRepository>(),
      c.get<i37.AccountShareService>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i37.AccountShareService>(
    (IocContainer c) => i37.AccountShareService(
      c.get<i25.AccountMemberRepository>(),
      c.get<i35.UserRepository>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i38.ClaudeClient>(
    (IocContainer c) => i38.ClaudeClient(c.get<i61.AppSettings>()),
  );
  c.singleton<i39.QuickAddPicker>(
    (IocContainer c) =>
        i39.QuickAddPicker(c.get<i38.ClaudeClient>(), c.get<i44.FileCache>()),
  );
  c.singleton<i40.ApiTokenService>(
    (IocContainer c) => i40.ApiTokenService(
      c.get<i60.UserService>(),
      c.get<i45.FirebaseService>(),
    ),
  );
  c.singleton<i41.BudgetService>(
    (IocContainer c) => i41.BudgetService(
      c.get<i26.BudgetRepository>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i42.CategoryService>(
    (IocContainer c) => i42.CategoryService(
      c.get<i27.CategoryRepository>(),
      c.get<i28.ExpenseRepository>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i43.ExpenseService>(
    (IocContainer c) => i43.ExpenseService(
      c.get<i28.ExpenseRepository>(),
      c.get<i42.CategoryService>(),
      c.get<i41.BudgetService>(),
      c.get<i36.AccountService>(),
      c.get<i52.LiveService>(),
      c.get<i39.QuickAddPicker>(),
    ),
  );
  c.singleton<i44.FileCache>((IocContainer c) => i44.FileCache());
  c.singleton<i45.FirebaseService>(
    (IocContainer c) => i45.FirebaseService(c.get<i61.AppSettings>()),
  );
  c.singleton<i46.AccountTotalService>(
    (IocContainer c) => i46.AccountTotalService(
      c.get<i36.AccountService>(),
      c.get<i48.FxService>(),
    ),
  );
  c.singleton<i47.CoinbaseRateProvider>(
    (IocContainer c) => i47.CoinbaseRateProvider(
      c.get<i44.FileCache>(),
      c.get<i50.HttpFetch>(),
    ),
  );
  c.singleton<i48.FxService>(
    (IocContainer c) => i48.FxService(
      c.get<i47.CoinbaseRateProvider>(),
      c.get<i49.GoldQuoteProvider>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i49.GoldQuoteProvider>(
    (IocContainer c) =>
        i49.GoldQuoteProvider(c.get<i44.FileCache>(), c.get<i50.HttpFetch>()),
  );
  c.singleton<i50.HttpFetch>((IocContainer c) => i50.HttpFetch());
  c.singleton<i51.GroupService>(
    (IocContainer c) => i51.GroupService(
      c.get<i29.GroupRepository>(),
      c.get<i30.GroupMemberRepository>(),
      c.get<i27.CategoryRepository>(),
      c.get<i35.UserRepository>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i52.LiveService>(
    (IocContainer c) => i52.LiveService(
      c.get<i30.GroupMemberRepository>(),
      c.get<i23.AccountRepository>(),
      c.get<i25.AccountMemberRepository>(),
      c.get<i24.AccountEntryRepository>(),
    ),
  );
  c.singleton<i53.McpOAuthService>(
    (IocContainer c) => i53.McpOAuthService(
      c.get<i61.AppSettings>(),
      c.get<i54.McpTokenService>(),
    ),
  );
  c.singleton<i54.McpTokenService>(
    (IocContainer c) => i54.McpTokenService(
      c.get<i31.McpTokenRepository>(),
      c.get<i35.UserRepository>(),
      c.get<i60.UserService>(),
    ),
  );
  c.singleton<i55.PasskeyService>(
    (IocContainer c) => i55.PasskeyService(
      c.get<i32.PasskeyRepository>(),
      c.get<i35.UserRepository>(),
      c.get<i60.UserService>(),
      c.get<i40.ApiTokenService>(),
      c.get<i61.AppSettings>(),
    ),
  );
  c.singleton<i56.RecurringService>(
    (IocContainer c) => i56.RecurringService(
      c.get<i33.RecurringExpenseRepository>(),
      c.get<i43.ExpenseService>(),
      c.get<i42.CategoryService>(),
      c.get<i36.AccountService>(),
      c.get<i35.UserRepository>(),
      c.get<i29.GroupRepository>(),
      c.get<i30.GroupMemberRepository>(),
    ),
  );
  c.singleton<i57.ReportService>(
    (IocContainer c) => i57.ReportService(
      c.get<i28.ExpenseRepository>(),
      c.get<i30.GroupMemberRepository>(),
      c.get<i35.UserRepository>(),
    ),
  );
  c.singleton<i58.ShoppingListService>(
    (IocContainer c) => i58.ShoppingListService(
      c.get<i34.ShoppingItemRepository>(),
      c.get<i52.LiveService>(),
    ),
  );
  c.singleton<i59.TotpService>(
    (IocContainer c) => i59.TotpService(
      c.get<i35.UserRepository>(),
      c.get<i40.ApiTokenService>(),
    ),
  );
  c.singleton<i60.UserService>(
    (IocContainer c) => i60.UserService(
      c.get<i35.UserRepository>(),
      c.get<i51.GroupService>(),
      c.get<i37.AccountShareService>(),
      c.get<i61.AppSettings>(),
    ),
  );
  c.singleton<i61.AppSettings>((IocContainer c) => i61.AppSettings());
  c.singleton<i62.StaticFiles>(
    (IocContainer c) => i62.StaticFiles(c.get<i61.AppSettings>()),
  );
  c.provider<i63.AppAuthProvider>((IocContainer c) => i63.AppAuthProvider());
  c.provider<i64.ORMProvider>((IocContainer c) => i64.ORMProvider());
  c.provider<i65.ScheduleProvider>((IocContainer c) => i65.ScheduleProvider());
  c.provider<i66.AppSocketIoProvider>(
    (IocContainer c) => i66.AppSocketIoProvider(),
  );
  c.router<i67.ApiRouter>((IocContainer c) => i67.ApiRouter());
  c.router<i68.WebRouter>((IocContainer c) => i68.WebRouter());
  c.bindModel<i69.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i69.Account().find(key);
  });
  c.bindModel<i70.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i70.AccountEntry().find(key);
  });
  c.bindModel<i71.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i71.AccountMember().find(key);
  });
  c.bindModel<i72.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i72.Category().find(key);
  });
  c.bindModel<i73.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i73.Expense().find(key);
  });
  c.bindModel<i74.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i74.Group().find(key);
  });
  c.bindModel<i75.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i75.GroupMember().find(key);
  });
  c.bindModel<i76.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i76.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i77.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i77.McpToken().find(key);
  });
  c.bindModel<i78.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i78.Passkey().find(key);
  });
  c.bindModel<i79.RecurringExpense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i79.RecurringExpense().find(key);
  });
  c.bindModel<i80.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i80.ShoppingItem().find(key);
  });
  c.bindModel<i81.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i81.User().find(key);
  });
}
