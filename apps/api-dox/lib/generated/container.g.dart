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
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart'
    as i10;
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i11;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i12;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i13;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i14;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i15;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i16;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i17;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i18;
import 'package:api_dox/app/repositories/account.repository.dart' as i19;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i20;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i21;
import 'package:api_dox/app/repositories/budget.repository.dart' as i22;
import 'package:api_dox/app/repositories/category.repository.dart' as i23;
import 'package:api_dox/app/repositories/expense.repository.dart' as i24;
import 'package:api_dox/app/repositories/group.repository.dart' as i25;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i26;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i27;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i28;
import 'package:api_dox/app/repositories/user.repository.dart' as i29;
import 'package:api_dox/app/services/account.service.dart' as i30;
import 'package:api_dox/app/services/account_share.service.dart' as i31;
import 'package:api_dox/app/services/budget.service.dart' as i32;
import 'package:api_dox/app/services/category.service.dart' as i33;
import 'package:api_dox/app/services/expense.service.dart' as i34;
import 'package:api_dox/app/services/file_cache.dart' as i35;
import 'package:api_dox/app/services/firebase.service.dart' as i36;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i37;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i38;
import 'package:api_dox/app/services/fx/fx.service.dart' as i39;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i40;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i41;
import 'package:api_dox/app/services/group.service.dart' as i42;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i43;
import 'package:api_dox/app/services/mcp_token.service.dart' as i44;
import 'package:api_dox/app/services/shopping_list.service.dart' as i45;
import 'package:api_dox/app/services/user.service.dart' as i46;
import 'package:api_dox/config/settings.dart' as i47;
import 'package:api_dox/http/static_files.dart' as i48;
import 'package:api_dox/providers/orm_provider.dart' as i49;
import 'package:api_dox/providers/schedule_provider.dart' as i50;
import 'package:api_dox/routes/api.dart' as i51;
import 'package:api_dox/routes/web.dart' as i52;
import 'package:api_dox/app/models/account/account.model.dart' as i53;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i54;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i55;
import 'package:api_dox/app/models/category/category.model.dart' as i56;
import 'package:api_dox/app/models/expense/expense.model.dart' as i57;
import 'package:api_dox/app/models/group/group.model.dart' as i58;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i59;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i60;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i61;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i62;
import 'package:api_dox/app/models/user/user.model.dart' as i63;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i30.AccountService>(),
      c.get<i37.AccountTotalService>(),
      c.get<i39.FxService>(),
      c.get<i31.AccountShareService>(),
    ),
  );
  c.singleton<i2.CategoryController>(
    (IocContainer c) => i2.CategoryController(c.get<i33.CategoryService>()),
  );
  c.singleton<i3.ConfigController>(
    (IocContainer c) => i3.ConfigController(c.get<i47.AppSettings>()),
  );
  c.singleton<i4.ExpenseController>(
    (IocContainer c) => i4.ExpenseController(c.get<i34.ExpenseService>()),
  );
  c.singleton<i5.GroupController>(
    (IocContainer c) => i5.GroupController(
      c.get<i42.GroupService>(),
      c.get<i32.BudgetService>(),
    ),
  );
  c.singleton<i6.HealthController>((IocContainer c) => i6.HealthController());
  c.singleton<i7.McpController>(
    (IocContainer c) => i7.McpController(
      c.get<i43.McpOAuthService>(),
      c.get<i13.McpToolRegistry>(),
    ),
  );
  c.singleton<i8.MeController>(
    (IocContainer c) => i8.MeController(
      c.get<i43.McpOAuthService>(),
      c.get<i44.McpTokenService>(),
    ),
  );
  c.singleton<i9.OauthController>(
    (IocContainer c) => i9.OauthController(
      c.get<i43.McpOAuthService>(),
      c.get<i44.McpTokenService>(),
    ),
  );
  c.singleton<i10.ShoppingItemController>(
    (IocContainer c) =>
        i10.ShoppingItemController(c.get<i45.ShoppingListService>()),
  );
  c.singleton<i11.AuthMiddleware>(
    (IocContainer c) => i11.AuthMiddleware(
      c.get<i36.FirebaseService>(),
      c.get<i46.UserService>(),
    ),
  );
  c.singleton<i12.GroupMiddleware>(
    (IocContainer c) => i12.GroupMiddleware(c.get<i42.GroupService>()),
  );
  c.singleton<i13.McpToolRegistry>(
    (IocContainer c) => i13.McpToolRegistry(
      c.get<i16.GetMeTool>(),
      c.get<i16.ListGroupsTool>(),
      c.get<i16.CreateGroupTool>(),
      c.get<i16.UpdateGroupTool>(),
      c.get<i16.ListGroupMembersTool>(),
      c.get<i16.InviteGroupMemberTool>(),
      c.get<i16.RemoveGroupMemberTool>(),
      c.get<i16.LeaveGroupTool>(),
      c.get<i16.GetBudgetTool>(),
      c.get<i16.SetBudgetTool>(),
      c.get<i16.GetDefaultWalletTool>(),
      c.get<i16.SetDefaultWalletTool>(),
      c.get<i14.ListCategoriesTool>(),
      c.get<i14.CreateCategoryTool>(),
      c.get<i14.UpdateCategoryTool>(),
      c.get<i14.DeleteCategoryTool>(),
      c.get<i15.AddExpenseTool>(),
      c.get<i15.ListExpensesTool>(),
      c.get<i15.FrequentExpensesTool>(),
      c.get<i15.UpdateExpenseTool>(),
      c.get<i15.DeleteExpenseTool>(),
      c.get<i15.MonthlySummaryTool>(),
      c.get<i18.ListWalletsTool>(),
      c.get<i18.CreateWalletTool>(),
      c.get<i18.UpdateWalletTool>(),
      c.get<i18.DeleteWalletTool>(),
      c.get<i18.WalletTotalTool>(),
      c.get<i18.WalletHistoryTool>(),
      c.get<i18.TransferBetweenWalletsTool>(),
      c.get<i18.ListWalletMembersTool>(),
      c.get<i18.InviteWalletMemberTool>(),
      c.get<i18.RemoveWalletMemberTool>(),
      c.get<i18.ListWalletEntriesTool>(),
      c.get<i18.RecentWalletEntriesTool>(),
      c.get<i18.AddWalletEntryTool>(),
      c.get<i18.UpdateWalletEntryTool>(),
      c.get<i18.DeleteWalletEntryTool>(),
      c.get<i18.AdjustWalletBalanceTool>(),
      c.get<i18.ExchangeRatesTool>(),
      c.get<i17.ListShoppingItemsTool>(),
      c.get<i17.AddShoppingItemTool>(),
      c.get<i17.UpdateShoppingItemTool>(),
      c.get<i17.DeleteShoppingItemTool>(),
      c.get<i17.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i14.ListCategoriesTool>(
    (IocContainer c) => i14.ListCategoriesTool(
      c.get<i42.GroupService>(),
      c.get<i33.CategoryService>(),
    ),
  );
  c.singleton<i14.CreateCategoryTool>(
    (IocContainer c) => i14.CreateCategoryTool(
      c.get<i42.GroupService>(),
      c.get<i33.CategoryService>(),
    ),
  );
  c.singleton<i14.UpdateCategoryTool>(
    (IocContainer c) => i14.UpdateCategoryTool(
      c.get<i42.GroupService>(),
      c.get<i33.CategoryService>(),
    ),
  );
  c.singleton<i14.DeleteCategoryTool>(
    (IocContainer c) => i14.DeleteCategoryTool(
      c.get<i42.GroupService>(),
      c.get<i33.CategoryService>(),
    ),
  );
  c.singleton<i15.AddExpenseTool>(
    (IocContainer c) => i15.AddExpenseTool(
      c.get<i42.GroupService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i15.ListExpensesTool>(
    (IocContainer c) => i15.ListExpensesTool(
      c.get<i42.GroupService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i15.FrequentExpensesTool>(
    (IocContainer c) => i15.FrequentExpensesTool(
      c.get<i42.GroupService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i15.UpdateExpenseTool>(
    (IocContainer c) => i15.UpdateExpenseTool(
      c.get<i42.GroupService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i15.DeleteExpenseTool>(
    (IocContainer c) => i15.DeleteExpenseTool(
      c.get<i42.GroupService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i15.MonthlySummaryTool>(
    (IocContainer c) => i15.MonthlySummaryTool(
      c.get<i42.GroupService>(),
      c.get<i33.CategoryService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i16.GetMeTool>(
    (IocContainer c) => i16.GetMeTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.ListGroupsTool>(
    (IocContainer c) => i16.ListGroupsTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.CreateGroupTool>(
    (IocContainer c) => i16.CreateGroupTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.UpdateGroupTool>(
    (IocContainer c) => i16.UpdateGroupTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.ListGroupMembersTool>(
    (IocContainer c) => i16.ListGroupMembersTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.InviteGroupMemberTool>(
    (IocContainer c) => i16.InviteGroupMemberTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.RemoveGroupMemberTool>(
    (IocContainer c) => i16.RemoveGroupMemberTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.LeaveGroupTool>(
    (IocContainer c) => i16.LeaveGroupTool(c.get<i42.GroupService>()),
  );
  c.singleton<i16.GetBudgetTool>(
    (IocContainer c) => i16.GetBudgetTool(
      c.get<i42.GroupService>(),
      c.get<i34.ExpenseService>(),
    ),
  );
  c.singleton<i16.SetBudgetTool>(
    (IocContainer c) => i16.SetBudgetTool(
      c.get<i42.GroupService>(),
      c.get<i32.BudgetService>(),
    ),
  );
  c.singleton<i16.GetDefaultWalletTool>(
    (IocContainer c) => i16.GetDefaultWalletTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i16.SetDefaultWalletTool>(
    (IocContainer c) => i16.SetDefaultWalletTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i17.ListShoppingItemsTool>(
    (IocContainer c) => i17.ListShoppingItemsTool(
      c.get<i42.GroupService>(),
      c.get<i45.ShoppingListService>(),
    ),
  );
  c.singleton<i17.AddShoppingItemTool>(
    (IocContainer c) => i17.AddShoppingItemTool(
      c.get<i42.GroupService>(),
      c.get<i45.ShoppingListService>(),
    ),
  );
  c.singleton<i17.UpdateShoppingItemTool>(
    (IocContainer c) => i17.UpdateShoppingItemTool(
      c.get<i42.GroupService>(),
      c.get<i45.ShoppingListService>(),
    ),
  );
  c.singleton<i17.DeleteShoppingItemTool>(
    (IocContainer c) => i17.DeleteShoppingItemTool(
      c.get<i42.GroupService>(),
      c.get<i45.ShoppingListService>(),
    ),
  );
  c.singleton<i17.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i17.ClearDoneShoppingItemsTool(
      c.get<i42.GroupService>(),
      c.get<i45.ShoppingListService>(),
    ),
  );
  c.singleton<i18.ListWalletsTool>(
    (IocContainer c) => i18.ListWalletsTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.CreateWalletTool>(
    (IocContainer c) => i18.CreateWalletTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.UpdateWalletTool>(
    (IocContainer c) => i18.UpdateWalletTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.DeleteWalletTool>(
    (IocContainer c) => i18.DeleteWalletTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.WalletTotalTool>(
    (IocContainer c) => i18.WalletTotalTool(
      c.get<i42.GroupService>(),
      c.get<i37.AccountTotalService>(),
    ),
  );
  c.singleton<i18.WalletHistoryTool>(
    (IocContainer c) => i18.WalletHistoryTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.TransferBetweenWalletsTool>(
    (IocContainer c) => i18.TransferBetweenWalletsTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.ListWalletMembersTool>(
    (IocContainer c) => i18.ListWalletMembersTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
      c.get<i31.AccountShareService>(),
    ),
  );
  c.singleton<i18.InviteWalletMemberTool>(
    (IocContainer c) => i18.InviteWalletMemberTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
      c.get<i31.AccountShareService>(),
    ),
  );
  c.singleton<i18.RemoveWalletMemberTool>(
    (IocContainer c) => i18.RemoveWalletMemberTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
      c.get<i31.AccountShareService>(),
    ),
  );
  c.singleton<i18.ListWalletEntriesTool>(
    (IocContainer c) => i18.ListWalletEntriesTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.RecentWalletEntriesTool>(
    (IocContainer c) => i18.RecentWalletEntriesTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.AddWalletEntryTool>(
    (IocContainer c) => i18.AddWalletEntryTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.UpdateWalletEntryTool>(
    (IocContainer c) => i18.UpdateWalletEntryTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.DeleteWalletEntryTool>(
    (IocContainer c) => i18.DeleteWalletEntryTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.AdjustWalletBalanceTool>(
    (IocContainer c) => i18.AdjustWalletBalanceTool(
      c.get<i42.GroupService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i18.ExchangeRatesTool>(
    (IocContainer c) => i18.ExchangeRatesTool(
      c.get<i42.GroupService>(),
      c.get<i39.FxService>(),
    ),
  );
  c.singleton<i19.AccountRepository>(
    (IocContainer c) => i19.AccountRepository(),
  );
  c.singleton<i20.AccountEntryRepository>(
    (IocContainer c) => i20.AccountEntryRepository(),
  );
  c.singleton<i21.AccountMemberRepository>(
    (IocContainer c) => i21.AccountMemberRepository(),
  );
  c.singleton<i22.BudgetRepository>((IocContainer c) => i22.BudgetRepository());
  c.singleton<i23.CategoryRepository>(
    (IocContainer c) => i23.CategoryRepository(),
  );
  c.singleton<i24.ExpenseRepository>(
    (IocContainer c) => i24.ExpenseRepository(),
  );
  c.singleton<i25.GroupRepository>((IocContainer c) => i25.GroupRepository());
  c.singleton<i26.GroupMemberRepository>(
    (IocContainer c) => i26.GroupMemberRepository(),
  );
  c.singleton<i27.McpTokenRepository>(
    (IocContainer c) => i27.McpTokenRepository(),
  );
  c.singleton<i28.ShoppingItemRepository>(
    (IocContainer c) => i28.ShoppingItemRepository(),
  );
  c.singleton<i29.UserRepository>((IocContainer c) => i29.UserRepository());
  c.singleton<i30.AccountService>(
    (IocContainer c) => i30.AccountService(
      c.get<i19.AccountRepository>(),
      c.get<i20.AccountEntryRepository>(),
      c.get<i26.GroupMemberRepository>(),
      c.get<i21.AccountMemberRepository>(),
    ),
  );
  c.singleton<i31.AccountShareService>(
    (IocContainer c) => i31.AccountShareService(
      c.get<i21.AccountMemberRepository>(),
      c.get<i29.UserRepository>(),
    ),
  );
  c.singleton<i32.BudgetService>(
    (IocContainer c) => i32.BudgetService(c.get<i22.BudgetRepository>()),
  );
  c.singleton<i33.CategoryService>(
    (IocContainer c) => i33.CategoryService(
      c.get<i23.CategoryRepository>(),
      c.get<i24.ExpenseRepository>(),
    ),
  );
  c.singleton<i34.ExpenseService>(
    (IocContainer c) => i34.ExpenseService(
      c.get<i24.ExpenseRepository>(),
      c.get<i33.CategoryService>(),
      c.get<i32.BudgetService>(),
      c.get<i30.AccountService>(),
    ),
  );
  c.singleton<i35.FileCache>((IocContainer c) => i35.FileCache());
  c.singleton<i36.FirebaseService>(
    (IocContainer c) => i36.FirebaseService(c.get<i47.AppSettings>()),
  );
  c.singleton<i37.AccountTotalService>(
    (IocContainer c) => i37.AccountTotalService(
      c.get<i30.AccountService>(),
      c.get<i39.FxService>(),
    ),
  );
  c.singleton<i38.CoinbaseRateProvider>(
    (IocContainer c) => i38.CoinbaseRateProvider(
      c.get<i35.FileCache>(),
      c.get<i41.HttpFetch>(),
    ),
  );
  c.singleton<i39.FxService>(
    (IocContainer c) => i39.FxService(
      c.get<i38.CoinbaseRateProvider>(),
      c.get<i40.GoldQuoteProvider>(),
    ),
  );
  c.singleton<i40.GoldQuoteProvider>(
    (IocContainer c) =>
        i40.GoldQuoteProvider(c.get<i35.FileCache>(), c.get<i41.HttpFetch>()),
  );
  c.singleton<i41.HttpFetch>((IocContainer c) => i41.HttpFetch());
  c.singleton<i42.GroupService>(
    (IocContainer c) => i42.GroupService(
      c.get<i25.GroupRepository>(),
      c.get<i26.GroupMemberRepository>(),
      c.get<i23.CategoryRepository>(),
      c.get<i29.UserRepository>(),
    ),
  );
  c.singleton<i43.McpOAuthService>(
    (IocContainer c) => i43.McpOAuthService(
      c.get<i47.AppSettings>(),
      c.get<i44.McpTokenService>(),
    ),
  );
  c.singleton<i44.McpTokenService>(
    (IocContainer c) => i44.McpTokenService(
      c.get<i27.McpTokenRepository>(),
      c.get<i29.UserRepository>(),
      c.get<i46.UserService>(),
    ),
  );
  c.singleton<i45.ShoppingListService>(
    (IocContainer c) =>
        i45.ShoppingListService(c.get<i28.ShoppingItemRepository>()),
  );
  c.singleton<i46.UserService>(
    (IocContainer c) => i46.UserService(
      c.get<i29.UserRepository>(),
      c.get<i42.GroupService>(),
      c.get<i31.AccountShareService>(),
      c.get<i47.AppSettings>(),
    ),
  );
  c.singleton<i47.AppSettings>((IocContainer c) => i47.AppSettings());
  c.singleton<i48.StaticFiles>(
    (IocContainer c) => i48.StaticFiles(c.get<i47.AppSettings>()),
  );
  c.provider<i49.ORMProvider>((IocContainer c) => i49.ORMProvider());
  c.provider<i50.ScheduleProvider>((IocContainer c) => i50.ScheduleProvider());
  c.router<i51.ApiRouter>((IocContainer c) => i51.ApiRouter());
  c.router<i52.WebRouter>((IocContainer c) => i52.WebRouter());
  c.bindModel<i53.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i53.Account().find(key);
  });
  c.bindModel<i54.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i54.AccountEntry().find(key);
  });
  c.bindModel<i55.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i55.AccountMember().find(key);
  });
  c.bindModel<i56.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i56.Category().find(key);
  });
  c.bindModel<i57.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i57.Expense().find(key);
  });
  c.bindModel<i58.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i58.Group().find(key);
  });
  c.bindModel<i59.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i59.GroupMember().find(key);
  });
  c.bindModel<i60.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i60.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i61.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i61.McpToken().find(key);
  });
  c.bindModel<i62.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i62.ShoppingItem().find(key);
  });
  c.bindModel<i63.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i63.User().find(key);
  });
}
