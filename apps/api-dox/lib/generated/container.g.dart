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
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i13;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i14;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i15;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i16;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i17;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i18;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i19;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i20;
import 'package:api_dox/app/repositories/account.repository.dart' as i21;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i22;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i23;
import 'package:api_dox/app/repositories/budget.repository.dart' as i24;
import 'package:api_dox/app/repositories/category.repository.dart' as i25;
import 'package:api_dox/app/repositories/expense.repository.dart' as i26;
import 'package:api_dox/app/repositories/group.repository.dart' as i27;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i28;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i29;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i30;
import 'package:api_dox/app/repositories/recurring_expense.repository.dart'
    as i31;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i32;
import 'package:api_dox/app/repositories/user.repository.dart' as i33;
import 'package:api_dox/app/services/account.service.dart' as i34;
import 'package:api_dox/app/services/account_share.service.dart' as i35;
import 'package:api_dox/app/services/budget.service.dart' as i36;
import 'package:api_dox/app/services/category.service.dart' as i37;
import 'package:api_dox/app/services/expense.service.dart' as i38;
import 'package:api_dox/app/services/file_cache.dart' as i39;
import 'package:api_dox/app/services/firebase.service.dart' as i40;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i41;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i42;
import 'package:api_dox/app/services/fx/fx.service.dart' as i43;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i44;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i45;
import 'package:api_dox/app/services/group.service.dart' as i46;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i47;
import 'package:api_dox/app/services/mcp_token.service.dart' as i48;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i49;
import 'package:api_dox/app/services/recurring.service.dart' as i50;
import 'package:api_dox/app/services/report.service.dart' as i51;
import 'package:api_dox/app/services/shopping_list.service.dart' as i52;
import 'package:api_dox/app/services/user.service.dart' as i53;
import 'package:api_dox/config/settings.dart' as i54;
import 'package:api_dox/http/static_files.dart' as i55;
import 'package:api_dox/providers/orm_provider.dart' as i56;
import 'package:api_dox/providers/schedule_provider.dart' as i57;
import 'package:api_dox/routes/api.dart' as i58;
import 'package:api_dox/routes/web.dart' as i59;
import 'package:api_dox/app/models/account/account.model.dart' as i60;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i61;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i62;
import 'package:api_dox/app/models/category/category.model.dart' as i63;
import 'package:api_dox/app/models/expense/expense.model.dart' as i64;
import 'package:api_dox/app/models/group/group.model.dart' as i65;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i66;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i67;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i68;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i69;
import 'package:api_dox/app/models/recurring_expense/recurring_expense.model.dart'
    as i70;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i71;
import 'package:api_dox/app/models/user/user.model.dart' as i72;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i34.AccountService>(),
      c.get<i41.AccountTotalService>(),
      c.get<i43.FxService>(),
      c.get<i35.AccountShareService>(),
    ),
  );
  c.singleton<i2.CategoryController>(
    (IocContainer c) => i2.CategoryController(c.get<i37.CategoryService>()),
  );
  c.singleton<i3.ConfigController>(
    (IocContainer c) => i3.ConfigController(c.get<i54.AppSettings>()),
  );
  c.singleton<i4.ExpenseController>(
    (IocContainer c) => i4.ExpenseController(
      c.get<i38.ExpenseService>(),
      c.get<i51.ReportService>(),
    ),
  );
  c.singleton<i5.GroupController>(
    (IocContainer c) => i5.GroupController(
      c.get<i46.GroupService>(),
      c.get<i36.BudgetService>(),
    ),
  );
  c.singleton<i6.HealthController>((IocContainer c) => i6.HealthController());
  c.singleton<i7.McpController>(
    (IocContainer c) => i7.McpController(
      c.get<i47.McpOAuthService>(),
      c.get<i15.McpToolRegistry>(),
    ),
  );
  c.singleton<i8.MeController>(
    (IocContainer c) => i8.MeController(
      c.get<i47.McpOAuthService>(),
      c.get<i48.McpTokenService>(),
    ),
  );
  c.singleton<i9.OauthController>(
    (IocContainer c) => i9.OauthController(
      c.get<i47.McpOAuthService>(),
      c.get<i48.McpTokenService>(),
    ),
  );
  c.singleton<i10.PasskeyController>(
    (IocContainer c) => i10.PasskeyController(c.get<i49.PasskeyService>()),
  );
  c.singleton<i11.RecurringController>(
    (IocContainer c) => i11.RecurringController(c.get<i50.RecurringService>()),
  );
  c.singleton<i12.ShoppingItemController>(
    (IocContainer c) =>
        i12.ShoppingItemController(c.get<i52.ShoppingListService>()),
  );
  c.singleton<i13.AuthMiddleware>(
    (IocContainer c) => i13.AuthMiddleware(
      c.get<i40.FirebaseService>(),
      c.get<i53.UserService>(),
    ),
  );
  c.singleton<i14.GroupMiddleware>(
    (IocContainer c) => i14.GroupMiddleware(c.get<i46.GroupService>()),
  );
  c.singleton<i15.McpToolRegistry>(
    (IocContainer c) => i15.McpToolRegistry(
      c.get<i18.GetMeTool>(),
      c.get<i18.ListGroupsTool>(),
      c.get<i18.CreateGroupTool>(),
      c.get<i18.UpdateGroupTool>(),
      c.get<i18.ListGroupMembersTool>(),
      c.get<i18.InviteGroupMemberTool>(),
      c.get<i18.RemoveGroupMemberTool>(),
      c.get<i18.LeaveGroupTool>(),
      c.get<i18.GetBudgetTool>(),
      c.get<i18.SetBudgetTool>(),
      c.get<i18.GetDefaultWalletTool>(),
      c.get<i18.SetDefaultWalletTool>(),
      c.get<i16.ListCategoriesTool>(),
      c.get<i16.CreateCategoryTool>(),
      c.get<i16.UpdateCategoryTool>(),
      c.get<i16.DeleteCategoryTool>(),
      c.get<i17.AddExpenseTool>(),
      c.get<i17.ListExpensesTool>(),
      c.get<i17.FrequentExpensesTool>(),
      c.get<i17.UpdateExpenseTool>(),
      c.get<i17.DeleteExpenseTool>(),
      c.get<i17.MonthlySummaryTool>(),
      c.get<i20.ListWalletsTool>(),
      c.get<i20.CreateWalletTool>(),
      c.get<i20.UpdateWalletTool>(),
      c.get<i20.DeleteWalletTool>(),
      c.get<i20.WalletTotalTool>(),
      c.get<i20.WalletHistoryTool>(),
      c.get<i20.TransferBetweenWalletsTool>(),
      c.get<i20.ListWalletMembersTool>(),
      c.get<i20.InviteWalletMemberTool>(),
      c.get<i20.RemoveWalletMemberTool>(),
      c.get<i20.ListWalletEntriesTool>(),
      c.get<i20.RecentWalletEntriesTool>(),
      c.get<i20.AddWalletEntryTool>(),
      c.get<i20.UpdateWalletEntryTool>(),
      c.get<i20.DeleteWalletEntryTool>(),
      c.get<i20.AdjustWalletBalanceTool>(),
      c.get<i20.ExchangeRatesTool>(),
      c.get<i19.ListShoppingItemsTool>(),
      c.get<i19.AddShoppingItemTool>(),
      c.get<i19.UpdateShoppingItemTool>(),
      c.get<i19.DeleteShoppingItemTool>(),
      c.get<i19.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i16.ListCategoriesTool>(
    (IocContainer c) => i16.ListCategoriesTool(
      c.get<i46.GroupService>(),
      c.get<i37.CategoryService>(),
    ),
  );
  c.singleton<i16.CreateCategoryTool>(
    (IocContainer c) => i16.CreateCategoryTool(
      c.get<i46.GroupService>(),
      c.get<i37.CategoryService>(),
    ),
  );
  c.singleton<i16.UpdateCategoryTool>(
    (IocContainer c) => i16.UpdateCategoryTool(
      c.get<i46.GroupService>(),
      c.get<i37.CategoryService>(),
    ),
  );
  c.singleton<i16.DeleteCategoryTool>(
    (IocContainer c) => i16.DeleteCategoryTool(
      c.get<i46.GroupService>(),
      c.get<i37.CategoryService>(),
    ),
  );
  c.singleton<i17.AddExpenseTool>(
    (IocContainer c) => i17.AddExpenseTool(
      c.get<i46.GroupService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i17.ListExpensesTool>(
    (IocContainer c) => i17.ListExpensesTool(
      c.get<i46.GroupService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i17.FrequentExpensesTool>(
    (IocContainer c) => i17.FrequentExpensesTool(
      c.get<i46.GroupService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i17.UpdateExpenseTool>(
    (IocContainer c) => i17.UpdateExpenseTool(
      c.get<i46.GroupService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i17.DeleteExpenseTool>(
    (IocContainer c) => i17.DeleteExpenseTool(
      c.get<i46.GroupService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i17.MonthlySummaryTool>(
    (IocContainer c) => i17.MonthlySummaryTool(
      c.get<i46.GroupService>(),
      c.get<i37.CategoryService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i18.GetMeTool>(
    (IocContainer c) => i18.GetMeTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.ListGroupsTool>(
    (IocContainer c) => i18.ListGroupsTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.CreateGroupTool>(
    (IocContainer c) => i18.CreateGroupTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.UpdateGroupTool>(
    (IocContainer c) => i18.UpdateGroupTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.ListGroupMembersTool>(
    (IocContainer c) => i18.ListGroupMembersTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.InviteGroupMemberTool>(
    (IocContainer c) => i18.InviteGroupMemberTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.RemoveGroupMemberTool>(
    (IocContainer c) => i18.RemoveGroupMemberTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.LeaveGroupTool>(
    (IocContainer c) => i18.LeaveGroupTool(c.get<i46.GroupService>()),
  );
  c.singleton<i18.GetBudgetTool>(
    (IocContainer c) => i18.GetBudgetTool(
      c.get<i46.GroupService>(),
      c.get<i38.ExpenseService>(),
    ),
  );
  c.singleton<i18.SetBudgetTool>(
    (IocContainer c) => i18.SetBudgetTool(
      c.get<i46.GroupService>(),
      c.get<i36.BudgetService>(),
    ),
  );
  c.singleton<i18.GetDefaultWalletTool>(
    (IocContainer c) => i18.GetDefaultWalletTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i18.SetDefaultWalletTool>(
    (IocContainer c) => i18.SetDefaultWalletTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i19.ListShoppingItemsTool>(
    (IocContainer c) => i19.ListShoppingItemsTool(
      c.get<i46.GroupService>(),
      c.get<i52.ShoppingListService>(),
    ),
  );
  c.singleton<i19.AddShoppingItemTool>(
    (IocContainer c) => i19.AddShoppingItemTool(
      c.get<i46.GroupService>(),
      c.get<i52.ShoppingListService>(),
    ),
  );
  c.singleton<i19.UpdateShoppingItemTool>(
    (IocContainer c) => i19.UpdateShoppingItemTool(
      c.get<i46.GroupService>(),
      c.get<i52.ShoppingListService>(),
    ),
  );
  c.singleton<i19.DeleteShoppingItemTool>(
    (IocContainer c) => i19.DeleteShoppingItemTool(
      c.get<i46.GroupService>(),
      c.get<i52.ShoppingListService>(),
    ),
  );
  c.singleton<i19.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i19.ClearDoneShoppingItemsTool(
      c.get<i46.GroupService>(),
      c.get<i52.ShoppingListService>(),
    ),
  );
  c.singleton<i20.ListWalletsTool>(
    (IocContainer c) => i20.ListWalletsTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.CreateWalletTool>(
    (IocContainer c) => i20.CreateWalletTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.UpdateWalletTool>(
    (IocContainer c) => i20.UpdateWalletTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.DeleteWalletTool>(
    (IocContainer c) => i20.DeleteWalletTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.WalletTotalTool>(
    (IocContainer c) => i20.WalletTotalTool(
      c.get<i46.GroupService>(),
      c.get<i41.AccountTotalService>(),
    ),
  );
  c.singleton<i20.WalletHistoryTool>(
    (IocContainer c) => i20.WalletHistoryTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.TransferBetweenWalletsTool>(
    (IocContainer c) => i20.TransferBetweenWalletsTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.ListWalletMembersTool>(
    (IocContainer c) => i20.ListWalletMembersTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
      c.get<i35.AccountShareService>(),
    ),
  );
  c.singleton<i20.InviteWalletMemberTool>(
    (IocContainer c) => i20.InviteWalletMemberTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
      c.get<i35.AccountShareService>(),
    ),
  );
  c.singleton<i20.RemoveWalletMemberTool>(
    (IocContainer c) => i20.RemoveWalletMemberTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
      c.get<i35.AccountShareService>(),
    ),
  );
  c.singleton<i20.ListWalletEntriesTool>(
    (IocContainer c) => i20.ListWalletEntriesTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.RecentWalletEntriesTool>(
    (IocContainer c) => i20.RecentWalletEntriesTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.AddWalletEntryTool>(
    (IocContainer c) => i20.AddWalletEntryTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.UpdateWalletEntryTool>(
    (IocContainer c) => i20.UpdateWalletEntryTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.DeleteWalletEntryTool>(
    (IocContainer c) => i20.DeleteWalletEntryTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.AdjustWalletBalanceTool>(
    (IocContainer c) => i20.AdjustWalletBalanceTool(
      c.get<i46.GroupService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i20.ExchangeRatesTool>(
    (IocContainer c) => i20.ExchangeRatesTool(
      c.get<i46.GroupService>(),
      c.get<i43.FxService>(),
    ),
  );
  c.singleton<i21.AccountRepository>(
    (IocContainer c) => i21.AccountRepository(),
  );
  c.singleton<i22.AccountEntryRepository>(
    (IocContainer c) => i22.AccountEntryRepository(),
  );
  c.singleton<i23.AccountMemberRepository>(
    (IocContainer c) => i23.AccountMemberRepository(),
  );
  c.singleton<i24.BudgetRepository>((IocContainer c) => i24.BudgetRepository());
  c.singleton<i25.CategoryRepository>(
    (IocContainer c) => i25.CategoryRepository(),
  );
  c.singleton<i26.ExpenseRepository>(
    (IocContainer c) => i26.ExpenseRepository(),
  );
  c.singleton<i27.GroupRepository>((IocContainer c) => i27.GroupRepository());
  c.singleton<i28.GroupMemberRepository>(
    (IocContainer c) => i28.GroupMemberRepository(),
  );
  c.singleton<i29.McpTokenRepository>(
    (IocContainer c) => i29.McpTokenRepository(),
  );
  c.singleton<i30.PasskeyRepository>(
    (IocContainer c) => i30.PasskeyRepository(),
  );
  c.singleton<i31.RecurringExpenseRepository>(
    (IocContainer c) => i31.RecurringExpenseRepository(),
  );
  c.singleton<i32.ShoppingItemRepository>(
    (IocContainer c) => i32.ShoppingItemRepository(),
  );
  c.singleton<i33.UserRepository>((IocContainer c) => i33.UserRepository());
  c.singleton<i34.AccountService>(
    (IocContainer c) => i34.AccountService(
      c.get<i21.AccountRepository>(),
      c.get<i22.AccountEntryRepository>(),
      c.get<i28.GroupMemberRepository>(),
      c.get<i23.AccountMemberRepository>(),
    ),
  );
  c.singleton<i35.AccountShareService>(
    (IocContainer c) => i35.AccountShareService(
      c.get<i23.AccountMemberRepository>(),
      c.get<i33.UserRepository>(),
    ),
  );
  c.singleton<i36.BudgetService>(
    (IocContainer c) => i36.BudgetService(c.get<i24.BudgetRepository>()),
  );
  c.singleton<i37.CategoryService>(
    (IocContainer c) => i37.CategoryService(
      c.get<i25.CategoryRepository>(),
      c.get<i26.ExpenseRepository>(),
    ),
  );
  c.singleton<i38.ExpenseService>(
    (IocContainer c) => i38.ExpenseService(
      c.get<i26.ExpenseRepository>(),
      c.get<i37.CategoryService>(),
      c.get<i36.BudgetService>(),
      c.get<i34.AccountService>(),
    ),
  );
  c.singleton<i39.FileCache>((IocContainer c) => i39.FileCache());
  c.singleton<i40.FirebaseService>(
    (IocContainer c) => i40.FirebaseService(c.get<i54.AppSettings>()),
  );
  c.singleton<i41.AccountTotalService>(
    (IocContainer c) => i41.AccountTotalService(
      c.get<i34.AccountService>(),
      c.get<i43.FxService>(),
    ),
  );
  c.singleton<i42.CoinbaseRateProvider>(
    (IocContainer c) => i42.CoinbaseRateProvider(
      c.get<i39.FileCache>(),
      c.get<i45.HttpFetch>(),
    ),
  );
  c.singleton<i43.FxService>(
    (IocContainer c) => i43.FxService(
      c.get<i42.CoinbaseRateProvider>(),
      c.get<i44.GoldQuoteProvider>(),
    ),
  );
  c.singleton<i44.GoldQuoteProvider>(
    (IocContainer c) =>
        i44.GoldQuoteProvider(c.get<i39.FileCache>(), c.get<i45.HttpFetch>()),
  );
  c.singleton<i45.HttpFetch>((IocContainer c) => i45.HttpFetch());
  c.singleton<i46.GroupService>(
    (IocContainer c) => i46.GroupService(
      c.get<i27.GroupRepository>(),
      c.get<i28.GroupMemberRepository>(),
      c.get<i25.CategoryRepository>(),
      c.get<i33.UserRepository>(),
    ),
  );
  c.singleton<i47.McpOAuthService>(
    (IocContainer c) => i47.McpOAuthService(
      c.get<i54.AppSettings>(),
      c.get<i48.McpTokenService>(),
    ),
  );
  c.singleton<i48.McpTokenService>(
    (IocContainer c) => i48.McpTokenService(
      c.get<i29.McpTokenRepository>(),
      c.get<i33.UserRepository>(),
      c.get<i53.UserService>(),
    ),
  );
  c.singleton<i49.PasskeyService>(
    (IocContainer c) => i49.PasskeyService(
      c.get<i30.PasskeyRepository>(),
      c.get<i33.UserRepository>(),
      c.get<i53.UserService>(),
      c.get<i40.FirebaseService>(),
      c.get<i54.AppSettings>(),
    ),
  );
  c.singleton<i50.RecurringService>(
    (IocContainer c) => i50.RecurringService(
      c.get<i31.RecurringExpenseRepository>(),
      c.get<i38.ExpenseService>(),
      c.get<i37.CategoryService>(),
      c.get<i34.AccountService>(),
      c.get<i33.UserRepository>(),
      c.get<i27.GroupRepository>(),
      c.get<i28.GroupMemberRepository>(),
    ),
  );
  c.singleton<i51.ReportService>(
    (IocContainer c) => i51.ReportService(
      c.get<i26.ExpenseRepository>(),
      c.get<i28.GroupMemberRepository>(),
      c.get<i33.UserRepository>(),
    ),
  );
  c.singleton<i52.ShoppingListService>(
    (IocContainer c) =>
        i52.ShoppingListService(c.get<i32.ShoppingItemRepository>()),
  );
  c.singleton<i53.UserService>(
    (IocContainer c) => i53.UserService(
      c.get<i33.UserRepository>(),
      c.get<i46.GroupService>(),
      c.get<i35.AccountShareService>(),
      c.get<i54.AppSettings>(),
    ),
  );
  c.singleton<i54.AppSettings>((IocContainer c) => i54.AppSettings());
  c.singleton<i55.StaticFiles>(
    (IocContainer c) => i55.StaticFiles(c.get<i54.AppSettings>()),
  );
  c.provider<i56.ORMProvider>((IocContainer c) => i56.ORMProvider());
  c.provider<i57.ScheduleProvider>((IocContainer c) => i57.ScheduleProvider());
  c.router<i58.ApiRouter>((IocContainer c) => i58.ApiRouter());
  c.router<i59.WebRouter>((IocContainer c) => i59.WebRouter());
  c.bindModel<i60.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i60.Account().find(key);
  });
  c.bindModel<i61.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i61.AccountEntry().find(key);
  });
  c.bindModel<i62.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i62.AccountMember().find(key);
  });
  c.bindModel<i63.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i63.Category().find(key);
  });
  c.bindModel<i64.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i64.Expense().find(key);
  });
  c.bindModel<i65.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i65.Group().find(key);
  });
  c.bindModel<i66.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i66.GroupMember().find(key);
  });
  c.bindModel<i67.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i67.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i68.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i68.McpToken().find(key);
  });
  c.bindModel<i69.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i69.Passkey().find(key);
  });
  c.bindModel<i70.RecurringExpense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i70.RecurringExpense().find(key);
  });
  c.bindModel<i71.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i71.ShoppingItem().find(key);
  });
  c.bindModel<i72.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i72.User().find(key);
  });
}
