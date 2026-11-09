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
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart'
    as i11;
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i12;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i13;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i14;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i15;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i16;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i17;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i18;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i19;
import 'package:api_dox/app/repositories/account.repository.dart' as i20;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i21;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i22;
import 'package:api_dox/app/repositories/budget.repository.dart' as i23;
import 'package:api_dox/app/repositories/category.repository.dart' as i24;
import 'package:api_dox/app/repositories/expense.repository.dart' as i25;
import 'package:api_dox/app/repositories/group.repository.dart' as i26;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i27;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i28;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i29;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i30;
import 'package:api_dox/app/repositories/user.repository.dart' as i31;
import 'package:api_dox/app/services/account.service.dart' as i32;
import 'package:api_dox/app/services/account_share.service.dart' as i33;
import 'package:api_dox/app/services/budget.service.dart' as i34;
import 'package:api_dox/app/services/category.service.dart' as i35;
import 'package:api_dox/app/services/expense.service.dart' as i36;
import 'package:api_dox/app/services/file_cache.dart' as i37;
import 'package:api_dox/app/services/firebase.service.dart' as i38;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i39;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i40;
import 'package:api_dox/app/services/fx/fx.service.dart' as i41;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i42;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i43;
import 'package:api_dox/app/services/group.service.dart' as i44;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i45;
import 'package:api_dox/app/services/mcp_token.service.dart' as i46;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i47;
import 'package:api_dox/app/services/shopping_list.service.dart' as i48;
import 'package:api_dox/app/services/user.service.dart' as i49;
import 'package:api_dox/config/settings.dart' as i50;
import 'package:api_dox/http/static_files.dart' as i51;
import 'package:api_dox/providers/orm_provider.dart' as i52;
import 'package:api_dox/providers/schedule_provider.dart' as i53;
import 'package:api_dox/routes/api.dart' as i54;
import 'package:api_dox/routes/web.dart' as i55;
import 'package:api_dox/app/models/account/account.model.dart' as i56;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i57;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i58;
import 'package:api_dox/app/models/category/category.model.dart' as i59;
import 'package:api_dox/app/models/expense/expense.model.dart' as i60;
import 'package:api_dox/app/models/group/group.model.dart' as i61;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i62;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i63;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i64;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i65;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i66;
import 'package:api_dox/app/models/user/user.model.dart' as i67;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i32.AccountService>(),
      c.get<i39.AccountTotalService>(),
      c.get<i41.FxService>(),
      c.get<i33.AccountShareService>(),
    ),
  );
  c.singleton<i2.CategoryController>(
    (IocContainer c) => i2.CategoryController(c.get<i35.CategoryService>()),
  );
  c.singleton<i3.ConfigController>(
    (IocContainer c) => i3.ConfigController(c.get<i50.AppSettings>()),
  );
  c.singleton<i4.ExpenseController>(
    (IocContainer c) => i4.ExpenseController(c.get<i36.ExpenseService>()),
  );
  c.singleton<i5.GroupController>(
    (IocContainer c) => i5.GroupController(
      c.get<i44.GroupService>(),
      c.get<i34.BudgetService>(),
    ),
  );
  c.singleton<i6.HealthController>((IocContainer c) => i6.HealthController());
  c.singleton<i7.McpController>(
    (IocContainer c) => i7.McpController(
      c.get<i45.McpOAuthService>(),
      c.get<i14.McpToolRegistry>(),
    ),
  );
  c.singleton<i8.MeController>(
    (IocContainer c) => i8.MeController(
      c.get<i45.McpOAuthService>(),
      c.get<i46.McpTokenService>(),
    ),
  );
  c.singleton<i9.OauthController>(
    (IocContainer c) => i9.OauthController(
      c.get<i45.McpOAuthService>(),
      c.get<i46.McpTokenService>(),
    ),
  );
  c.singleton<i10.PasskeyController>(
    (IocContainer c) => i10.PasskeyController(c.get<i47.PasskeyService>()),
  );
  c.singleton<i11.ShoppingItemController>(
    (IocContainer c) =>
        i11.ShoppingItemController(c.get<i48.ShoppingListService>()),
  );
  c.singleton<i12.AuthMiddleware>(
    (IocContainer c) => i12.AuthMiddleware(
      c.get<i38.FirebaseService>(),
      c.get<i49.UserService>(),
    ),
  );
  c.singleton<i13.GroupMiddleware>(
    (IocContainer c) => i13.GroupMiddleware(c.get<i44.GroupService>()),
  );
  c.singleton<i14.McpToolRegistry>(
    (IocContainer c) => i14.McpToolRegistry(
      c.get<i17.GetMeTool>(),
      c.get<i17.ListGroupsTool>(),
      c.get<i17.CreateGroupTool>(),
      c.get<i17.UpdateGroupTool>(),
      c.get<i17.ListGroupMembersTool>(),
      c.get<i17.InviteGroupMemberTool>(),
      c.get<i17.RemoveGroupMemberTool>(),
      c.get<i17.LeaveGroupTool>(),
      c.get<i17.GetBudgetTool>(),
      c.get<i17.SetBudgetTool>(),
      c.get<i17.GetDefaultWalletTool>(),
      c.get<i17.SetDefaultWalletTool>(),
      c.get<i15.ListCategoriesTool>(),
      c.get<i15.CreateCategoryTool>(),
      c.get<i15.UpdateCategoryTool>(),
      c.get<i15.DeleteCategoryTool>(),
      c.get<i16.AddExpenseTool>(),
      c.get<i16.ListExpensesTool>(),
      c.get<i16.FrequentExpensesTool>(),
      c.get<i16.UpdateExpenseTool>(),
      c.get<i16.DeleteExpenseTool>(),
      c.get<i16.MonthlySummaryTool>(),
      c.get<i19.ListWalletsTool>(),
      c.get<i19.CreateWalletTool>(),
      c.get<i19.UpdateWalletTool>(),
      c.get<i19.DeleteWalletTool>(),
      c.get<i19.WalletTotalTool>(),
      c.get<i19.WalletHistoryTool>(),
      c.get<i19.TransferBetweenWalletsTool>(),
      c.get<i19.ListWalletMembersTool>(),
      c.get<i19.InviteWalletMemberTool>(),
      c.get<i19.RemoveWalletMemberTool>(),
      c.get<i19.ListWalletEntriesTool>(),
      c.get<i19.RecentWalletEntriesTool>(),
      c.get<i19.AddWalletEntryTool>(),
      c.get<i19.UpdateWalletEntryTool>(),
      c.get<i19.DeleteWalletEntryTool>(),
      c.get<i19.AdjustWalletBalanceTool>(),
      c.get<i19.ExchangeRatesTool>(),
      c.get<i18.ListShoppingItemsTool>(),
      c.get<i18.AddShoppingItemTool>(),
      c.get<i18.UpdateShoppingItemTool>(),
      c.get<i18.DeleteShoppingItemTool>(),
      c.get<i18.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i15.ListCategoriesTool>(
    (IocContainer c) => i15.ListCategoriesTool(
      c.get<i44.GroupService>(),
      c.get<i35.CategoryService>(),
    ),
  );
  c.singleton<i15.CreateCategoryTool>(
    (IocContainer c) => i15.CreateCategoryTool(
      c.get<i44.GroupService>(),
      c.get<i35.CategoryService>(),
    ),
  );
  c.singleton<i15.UpdateCategoryTool>(
    (IocContainer c) => i15.UpdateCategoryTool(
      c.get<i44.GroupService>(),
      c.get<i35.CategoryService>(),
    ),
  );
  c.singleton<i15.DeleteCategoryTool>(
    (IocContainer c) => i15.DeleteCategoryTool(
      c.get<i44.GroupService>(),
      c.get<i35.CategoryService>(),
    ),
  );
  c.singleton<i16.AddExpenseTool>(
    (IocContainer c) => i16.AddExpenseTool(
      c.get<i44.GroupService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i16.ListExpensesTool>(
    (IocContainer c) => i16.ListExpensesTool(
      c.get<i44.GroupService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i16.FrequentExpensesTool>(
    (IocContainer c) => i16.FrequentExpensesTool(
      c.get<i44.GroupService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i16.UpdateExpenseTool>(
    (IocContainer c) => i16.UpdateExpenseTool(
      c.get<i44.GroupService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i16.DeleteExpenseTool>(
    (IocContainer c) => i16.DeleteExpenseTool(
      c.get<i44.GroupService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i16.MonthlySummaryTool>(
    (IocContainer c) => i16.MonthlySummaryTool(
      c.get<i44.GroupService>(),
      c.get<i35.CategoryService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i17.GetMeTool>(
    (IocContainer c) => i17.GetMeTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.ListGroupsTool>(
    (IocContainer c) => i17.ListGroupsTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.CreateGroupTool>(
    (IocContainer c) => i17.CreateGroupTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.UpdateGroupTool>(
    (IocContainer c) => i17.UpdateGroupTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.ListGroupMembersTool>(
    (IocContainer c) => i17.ListGroupMembersTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.InviteGroupMemberTool>(
    (IocContainer c) => i17.InviteGroupMemberTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.RemoveGroupMemberTool>(
    (IocContainer c) => i17.RemoveGroupMemberTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.LeaveGroupTool>(
    (IocContainer c) => i17.LeaveGroupTool(c.get<i44.GroupService>()),
  );
  c.singleton<i17.GetBudgetTool>(
    (IocContainer c) => i17.GetBudgetTool(
      c.get<i44.GroupService>(),
      c.get<i36.ExpenseService>(),
    ),
  );
  c.singleton<i17.SetBudgetTool>(
    (IocContainer c) => i17.SetBudgetTool(
      c.get<i44.GroupService>(),
      c.get<i34.BudgetService>(),
    ),
  );
  c.singleton<i17.GetDefaultWalletTool>(
    (IocContainer c) => i17.GetDefaultWalletTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i17.SetDefaultWalletTool>(
    (IocContainer c) => i17.SetDefaultWalletTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i18.ListShoppingItemsTool>(
    (IocContainer c) => i18.ListShoppingItemsTool(
      c.get<i44.GroupService>(),
      c.get<i48.ShoppingListService>(),
    ),
  );
  c.singleton<i18.AddShoppingItemTool>(
    (IocContainer c) => i18.AddShoppingItemTool(
      c.get<i44.GroupService>(),
      c.get<i48.ShoppingListService>(),
    ),
  );
  c.singleton<i18.UpdateShoppingItemTool>(
    (IocContainer c) => i18.UpdateShoppingItemTool(
      c.get<i44.GroupService>(),
      c.get<i48.ShoppingListService>(),
    ),
  );
  c.singleton<i18.DeleteShoppingItemTool>(
    (IocContainer c) => i18.DeleteShoppingItemTool(
      c.get<i44.GroupService>(),
      c.get<i48.ShoppingListService>(),
    ),
  );
  c.singleton<i18.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i18.ClearDoneShoppingItemsTool(
      c.get<i44.GroupService>(),
      c.get<i48.ShoppingListService>(),
    ),
  );
  c.singleton<i19.ListWalletsTool>(
    (IocContainer c) => i19.ListWalletsTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.CreateWalletTool>(
    (IocContainer c) => i19.CreateWalletTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.UpdateWalletTool>(
    (IocContainer c) => i19.UpdateWalletTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.DeleteWalletTool>(
    (IocContainer c) => i19.DeleteWalletTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.WalletTotalTool>(
    (IocContainer c) => i19.WalletTotalTool(
      c.get<i44.GroupService>(),
      c.get<i39.AccountTotalService>(),
    ),
  );
  c.singleton<i19.WalletHistoryTool>(
    (IocContainer c) => i19.WalletHistoryTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.TransferBetweenWalletsTool>(
    (IocContainer c) => i19.TransferBetweenWalletsTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.ListWalletMembersTool>(
    (IocContainer c) => i19.ListWalletMembersTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
      c.get<i33.AccountShareService>(),
    ),
  );
  c.singleton<i19.InviteWalletMemberTool>(
    (IocContainer c) => i19.InviteWalletMemberTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
      c.get<i33.AccountShareService>(),
    ),
  );
  c.singleton<i19.RemoveWalletMemberTool>(
    (IocContainer c) => i19.RemoveWalletMemberTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
      c.get<i33.AccountShareService>(),
    ),
  );
  c.singleton<i19.ListWalletEntriesTool>(
    (IocContainer c) => i19.ListWalletEntriesTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.RecentWalletEntriesTool>(
    (IocContainer c) => i19.RecentWalletEntriesTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.AddWalletEntryTool>(
    (IocContainer c) => i19.AddWalletEntryTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.UpdateWalletEntryTool>(
    (IocContainer c) => i19.UpdateWalletEntryTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.DeleteWalletEntryTool>(
    (IocContainer c) => i19.DeleteWalletEntryTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.AdjustWalletBalanceTool>(
    (IocContainer c) => i19.AdjustWalletBalanceTool(
      c.get<i44.GroupService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i19.ExchangeRatesTool>(
    (IocContainer c) => i19.ExchangeRatesTool(
      c.get<i44.GroupService>(),
      c.get<i41.FxService>(),
    ),
  );
  c.singleton<i20.AccountRepository>(
    (IocContainer c) => i20.AccountRepository(),
  );
  c.singleton<i21.AccountEntryRepository>(
    (IocContainer c) => i21.AccountEntryRepository(),
  );
  c.singleton<i22.AccountMemberRepository>(
    (IocContainer c) => i22.AccountMemberRepository(),
  );
  c.singleton<i23.BudgetRepository>((IocContainer c) => i23.BudgetRepository());
  c.singleton<i24.CategoryRepository>(
    (IocContainer c) => i24.CategoryRepository(),
  );
  c.singleton<i25.ExpenseRepository>(
    (IocContainer c) => i25.ExpenseRepository(),
  );
  c.singleton<i26.GroupRepository>((IocContainer c) => i26.GroupRepository());
  c.singleton<i27.GroupMemberRepository>(
    (IocContainer c) => i27.GroupMemberRepository(),
  );
  c.singleton<i28.McpTokenRepository>(
    (IocContainer c) => i28.McpTokenRepository(),
  );
  c.singleton<i29.PasskeyRepository>(
    (IocContainer c) => i29.PasskeyRepository(),
  );
  c.singleton<i30.ShoppingItemRepository>(
    (IocContainer c) => i30.ShoppingItemRepository(),
  );
  c.singleton<i31.UserRepository>((IocContainer c) => i31.UserRepository());
  c.singleton<i32.AccountService>(
    (IocContainer c) => i32.AccountService(
      c.get<i20.AccountRepository>(),
      c.get<i21.AccountEntryRepository>(),
      c.get<i27.GroupMemberRepository>(),
      c.get<i22.AccountMemberRepository>(),
    ),
  );
  c.singleton<i33.AccountShareService>(
    (IocContainer c) => i33.AccountShareService(
      c.get<i22.AccountMemberRepository>(),
      c.get<i31.UserRepository>(),
    ),
  );
  c.singleton<i34.BudgetService>(
    (IocContainer c) => i34.BudgetService(c.get<i23.BudgetRepository>()),
  );
  c.singleton<i35.CategoryService>(
    (IocContainer c) => i35.CategoryService(
      c.get<i24.CategoryRepository>(),
      c.get<i25.ExpenseRepository>(),
    ),
  );
  c.singleton<i36.ExpenseService>(
    (IocContainer c) => i36.ExpenseService(
      c.get<i25.ExpenseRepository>(),
      c.get<i35.CategoryService>(),
      c.get<i34.BudgetService>(),
      c.get<i32.AccountService>(),
    ),
  );
  c.singleton<i37.FileCache>((IocContainer c) => i37.FileCache());
  c.singleton<i38.FirebaseService>(
    (IocContainer c) => i38.FirebaseService(c.get<i50.AppSettings>()),
  );
  c.singleton<i39.AccountTotalService>(
    (IocContainer c) => i39.AccountTotalService(
      c.get<i32.AccountService>(),
      c.get<i41.FxService>(),
    ),
  );
  c.singleton<i40.CoinbaseRateProvider>(
    (IocContainer c) => i40.CoinbaseRateProvider(
      c.get<i37.FileCache>(),
      c.get<i43.HttpFetch>(),
    ),
  );
  c.singleton<i41.FxService>(
    (IocContainer c) => i41.FxService(
      c.get<i40.CoinbaseRateProvider>(),
      c.get<i42.GoldQuoteProvider>(),
    ),
  );
  c.singleton<i42.GoldQuoteProvider>(
    (IocContainer c) =>
        i42.GoldQuoteProvider(c.get<i37.FileCache>(), c.get<i43.HttpFetch>()),
  );
  c.singleton<i43.HttpFetch>((IocContainer c) => i43.HttpFetch());
  c.singleton<i44.GroupService>(
    (IocContainer c) => i44.GroupService(
      c.get<i26.GroupRepository>(),
      c.get<i27.GroupMemberRepository>(),
      c.get<i24.CategoryRepository>(),
      c.get<i31.UserRepository>(),
    ),
  );
  c.singleton<i45.McpOAuthService>(
    (IocContainer c) => i45.McpOAuthService(
      c.get<i50.AppSettings>(),
      c.get<i46.McpTokenService>(),
    ),
  );
  c.singleton<i46.McpTokenService>(
    (IocContainer c) => i46.McpTokenService(
      c.get<i28.McpTokenRepository>(),
      c.get<i31.UserRepository>(),
      c.get<i49.UserService>(),
    ),
  );
  c.singleton<i47.PasskeyService>(
    (IocContainer c) => i47.PasskeyService(
      c.get<i29.PasskeyRepository>(),
      c.get<i31.UserRepository>(),
      c.get<i49.UserService>(),
      c.get<i38.FirebaseService>(),
      c.get<i50.AppSettings>(),
    ),
  );
  c.singleton<i48.ShoppingListService>(
    (IocContainer c) =>
        i48.ShoppingListService(c.get<i30.ShoppingItemRepository>()),
  );
  c.singleton<i49.UserService>(
    (IocContainer c) => i49.UserService(
      c.get<i31.UserRepository>(),
      c.get<i44.GroupService>(),
      c.get<i33.AccountShareService>(),
      c.get<i50.AppSettings>(),
    ),
  );
  c.singleton<i50.AppSettings>((IocContainer c) => i50.AppSettings());
  c.singleton<i51.StaticFiles>(
    (IocContainer c) => i51.StaticFiles(c.get<i50.AppSettings>()),
  );
  c.provider<i52.ORMProvider>((IocContainer c) => i52.ORMProvider());
  c.provider<i53.ScheduleProvider>((IocContainer c) => i53.ScheduleProvider());
  c.router<i54.ApiRouter>((IocContainer c) => i54.ApiRouter());
  c.router<i55.WebRouter>((IocContainer c) => i55.WebRouter());
  c.bindModel<i56.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i56.Account().find(key);
  });
  c.bindModel<i57.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i57.AccountEntry().find(key);
  });
  c.bindModel<i58.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i58.AccountMember().find(key);
  });
  c.bindModel<i59.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i59.Category().find(key);
  });
  c.bindModel<i60.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i60.Expense().find(key);
  });
  c.bindModel<i61.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i61.Group().find(key);
  });
  c.bindModel<i62.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i62.GroupMember().find(key);
  });
  c.bindModel<i63.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i63.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i64.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i64.McpToken().find(key);
  });
  c.bindModel<i65.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i65.Passkey().find(key);
  });
  c.bindModel<i66.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i66.ShoppingItem().find(key);
  });
  c.bindModel<i67.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i67.User().find(key);
  });
}
