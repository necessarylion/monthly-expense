// GENERATED CODE - DO NOT MODIFY BY HAND
// Made by dox_builder. Run `dart run build_runner build`.
// ignore_for_file: type=lint

import 'package:dox_core/dox_core.dart';
import 'package:api_dox/app/http/controllers/account.controller.dart' as i1;
import 'package:api_dox/app/http/controllers/category.controller.dart' as i2;
import 'package:api_dox/app/http/controllers/expense.controller.dart' as i3;
import 'package:api_dox/app/http/controllers/group.controller.dart' as i4;
import 'package:api_dox/app/http/controllers/health.controller.dart' as i5;
import 'package:api_dox/app/http/controllers/mcp.controller.dart' as i6;
import 'package:api_dox/app/http/controllers/me.controller.dart' as i7;
import 'package:api_dox/app/http/controllers/oauth.controller.dart' as i8;
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart'
    as i9;
import 'package:api_dox/app/http/middleware/auth.middleware.dart' as i10;
import 'package:api_dox/app/http/middleware/group.middleware.dart' as i11;
import 'package:api_dox/app/mcp/mcp_tool_registry.dart' as i12;
import 'package:api_dox/app/mcp/tools/category_tools.dart' as i13;
import 'package:api_dox/app/mcp/tools/expense_tools.dart' as i14;
import 'package:api_dox/app/mcp/tools/group_tools.dart' as i15;
import 'package:api_dox/app/mcp/tools/shopping_tools.dart' as i16;
import 'package:api_dox/app/mcp/tools/wallet_tools.dart' as i17;
import 'package:api_dox/app/repositories/account.repository.dart' as i18;
import 'package:api_dox/app/repositories/account_entry.repository.dart' as i19;
import 'package:api_dox/app/repositories/account_member.repository.dart' as i20;
import 'package:api_dox/app/repositories/budget.repository.dart' as i21;
import 'package:api_dox/app/repositories/category.repository.dart' as i22;
import 'package:api_dox/app/repositories/expense.repository.dart' as i23;
import 'package:api_dox/app/repositories/group.repository.dart' as i24;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i25;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i26;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i27;
import 'package:api_dox/app/repositories/user.repository.dart' as i28;
import 'package:api_dox/app/services/account.service.dart' as i29;
import 'package:api_dox/app/services/account_share.service.dart' as i30;
import 'package:api_dox/app/services/budget.service.dart' as i31;
import 'package:api_dox/app/services/category.service.dart' as i32;
import 'package:api_dox/app/services/expense.service.dart' as i33;
import 'package:api_dox/app/services/file_cache.dart' as i34;
import 'package:api_dox/app/services/firebase.service.dart' as i35;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i36;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i37;
import 'package:api_dox/app/services/fx/fx.service.dart' as i38;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i39;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i40;
import 'package:api_dox/app/services/group.service.dart' as i41;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i42;
import 'package:api_dox/app/services/mcp_token.service.dart' as i43;
import 'package:api_dox/app/services/shopping_list.service.dart' as i44;
import 'package:api_dox/app/services/user.service.dart' as i45;
import 'package:api_dox/config/settings.dart' as i46;
import 'package:api_dox/http/static_files.dart' as i47;
import 'package:api_dox/providers/orm_provider.dart' as i48;
import 'package:api_dox/providers/schedule_provider.dart' as i49;
import 'package:api_dox/routes/api.dart' as i50;
import 'package:api_dox/routes/web.dart' as i51;
import 'package:api_dox/app/models/account/account.model.dart' as i52;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i53;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i54;
import 'package:api_dox/app/models/category/category.model.dart' as i55;
import 'package:api_dox/app/models/expense/expense.model.dart' as i56;
import 'package:api_dox/app/models/group/group.model.dart' as i57;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i58;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i59;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i60;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i61;
import 'package:api_dox/app/models/user/user.model.dart' as i62;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i29.AccountService>(),
      c.get<i36.AccountTotalService>(),
      c.get<i38.FxService>(),
      c.get<i30.AccountShareService>(),
    ),
  );
  c.singleton<i2.CategoryController>(
    (IocContainer c) => i2.CategoryController(c.get<i32.CategoryService>()),
  );
  c.singleton<i3.ExpenseController>(
    (IocContainer c) => i3.ExpenseController(c.get<i33.ExpenseService>()),
  );
  c.singleton<i4.GroupController>(
    (IocContainer c) => i4.GroupController(
      c.get<i41.GroupService>(),
      c.get<i31.BudgetService>(),
    ),
  );
  c.singleton<i5.HealthController>((IocContainer c) => i5.HealthController());
  c.singleton<i6.McpController>(
    (IocContainer c) => i6.McpController(
      c.get<i42.McpOAuthService>(),
      c.get<i12.McpToolRegistry>(),
    ),
  );
  c.singleton<i7.MeController>(
    (IocContainer c) => i7.MeController(
      c.get<i42.McpOAuthService>(),
      c.get<i43.McpTokenService>(),
    ),
  );
  c.singleton<i8.OauthController>(
    (IocContainer c) => i8.OauthController(
      c.get<i42.McpOAuthService>(),
      c.get<i43.McpTokenService>(),
    ),
  );
  c.singleton<i9.ShoppingItemController>(
    (IocContainer c) =>
        i9.ShoppingItemController(c.get<i44.ShoppingListService>()),
  );
  c.singleton<i10.AuthMiddleware>(
    (IocContainer c) => i10.AuthMiddleware(
      c.get<i35.FirebaseService>(),
      c.get<i45.UserService>(),
    ),
  );
  c.singleton<i11.GroupMiddleware>(
    (IocContainer c) => i11.GroupMiddleware(c.get<i41.GroupService>()),
  );
  c.singleton<i12.McpToolRegistry>(
    (IocContainer c) => i12.McpToolRegistry(
      c.get<i15.GetMeTool>(),
      c.get<i15.ListGroupsTool>(),
      c.get<i15.CreateGroupTool>(),
      c.get<i15.UpdateGroupTool>(),
      c.get<i15.ListGroupMembersTool>(),
      c.get<i15.InviteGroupMemberTool>(),
      c.get<i15.RemoveGroupMemberTool>(),
      c.get<i15.LeaveGroupTool>(),
      c.get<i15.GetBudgetTool>(),
      c.get<i15.SetBudgetTool>(),
      c.get<i15.GetDefaultWalletTool>(),
      c.get<i15.SetDefaultWalletTool>(),
      c.get<i13.ListCategoriesTool>(),
      c.get<i13.CreateCategoryTool>(),
      c.get<i13.UpdateCategoryTool>(),
      c.get<i13.DeleteCategoryTool>(),
      c.get<i14.AddExpenseTool>(),
      c.get<i14.ListExpensesTool>(),
      c.get<i14.FrequentExpensesTool>(),
      c.get<i14.UpdateExpenseTool>(),
      c.get<i14.DeleteExpenseTool>(),
      c.get<i14.MonthlySummaryTool>(),
      c.get<i17.ListWalletsTool>(),
      c.get<i17.CreateWalletTool>(),
      c.get<i17.UpdateWalletTool>(),
      c.get<i17.DeleteWalletTool>(),
      c.get<i17.WalletTotalTool>(),
      c.get<i17.WalletHistoryTool>(),
      c.get<i17.TransferBetweenWalletsTool>(),
      c.get<i17.ListWalletMembersTool>(),
      c.get<i17.InviteWalletMemberTool>(),
      c.get<i17.RemoveWalletMemberTool>(),
      c.get<i17.ListWalletEntriesTool>(),
      c.get<i17.RecentWalletEntriesTool>(),
      c.get<i17.AddWalletEntryTool>(),
      c.get<i17.UpdateWalletEntryTool>(),
      c.get<i17.DeleteWalletEntryTool>(),
      c.get<i17.AdjustWalletBalanceTool>(),
      c.get<i17.ExchangeRatesTool>(),
      c.get<i16.ListShoppingItemsTool>(),
      c.get<i16.AddShoppingItemTool>(),
      c.get<i16.UpdateShoppingItemTool>(),
      c.get<i16.DeleteShoppingItemTool>(),
      c.get<i16.ClearDoneShoppingItemsTool>(),
    ),
  );
  c.singleton<i13.ListCategoriesTool>(
    (IocContainer c) => i13.ListCategoriesTool(
      c.get<i41.GroupService>(),
      c.get<i32.CategoryService>(),
    ),
  );
  c.singleton<i13.CreateCategoryTool>(
    (IocContainer c) => i13.CreateCategoryTool(
      c.get<i41.GroupService>(),
      c.get<i32.CategoryService>(),
    ),
  );
  c.singleton<i13.UpdateCategoryTool>(
    (IocContainer c) => i13.UpdateCategoryTool(
      c.get<i41.GroupService>(),
      c.get<i32.CategoryService>(),
    ),
  );
  c.singleton<i13.DeleteCategoryTool>(
    (IocContainer c) => i13.DeleteCategoryTool(
      c.get<i41.GroupService>(),
      c.get<i32.CategoryService>(),
    ),
  );
  c.singleton<i14.AddExpenseTool>(
    (IocContainer c) => i14.AddExpenseTool(
      c.get<i41.GroupService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i14.ListExpensesTool>(
    (IocContainer c) => i14.ListExpensesTool(
      c.get<i41.GroupService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i14.FrequentExpensesTool>(
    (IocContainer c) => i14.FrequentExpensesTool(
      c.get<i41.GroupService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i14.UpdateExpenseTool>(
    (IocContainer c) => i14.UpdateExpenseTool(
      c.get<i41.GroupService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i14.DeleteExpenseTool>(
    (IocContainer c) => i14.DeleteExpenseTool(
      c.get<i41.GroupService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i14.MonthlySummaryTool>(
    (IocContainer c) => i14.MonthlySummaryTool(
      c.get<i41.GroupService>(),
      c.get<i32.CategoryService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i15.GetMeTool>(
    (IocContainer c) => i15.GetMeTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.ListGroupsTool>(
    (IocContainer c) => i15.ListGroupsTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.CreateGroupTool>(
    (IocContainer c) => i15.CreateGroupTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.UpdateGroupTool>(
    (IocContainer c) => i15.UpdateGroupTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.ListGroupMembersTool>(
    (IocContainer c) => i15.ListGroupMembersTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.InviteGroupMemberTool>(
    (IocContainer c) => i15.InviteGroupMemberTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.RemoveGroupMemberTool>(
    (IocContainer c) => i15.RemoveGroupMemberTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.LeaveGroupTool>(
    (IocContainer c) => i15.LeaveGroupTool(c.get<i41.GroupService>()),
  );
  c.singleton<i15.GetBudgetTool>(
    (IocContainer c) => i15.GetBudgetTool(
      c.get<i41.GroupService>(),
      c.get<i33.ExpenseService>(),
    ),
  );
  c.singleton<i15.SetBudgetTool>(
    (IocContainer c) => i15.SetBudgetTool(
      c.get<i41.GroupService>(),
      c.get<i31.BudgetService>(),
    ),
  );
  c.singleton<i15.GetDefaultWalletTool>(
    (IocContainer c) => i15.GetDefaultWalletTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i15.SetDefaultWalletTool>(
    (IocContainer c) => i15.SetDefaultWalletTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i16.ListShoppingItemsTool>(
    (IocContainer c) => i16.ListShoppingItemsTool(
      c.get<i41.GroupService>(),
      c.get<i44.ShoppingListService>(),
    ),
  );
  c.singleton<i16.AddShoppingItemTool>(
    (IocContainer c) => i16.AddShoppingItemTool(
      c.get<i41.GroupService>(),
      c.get<i44.ShoppingListService>(),
    ),
  );
  c.singleton<i16.UpdateShoppingItemTool>(
    (IocContainer c) => i16.UpdateShoppingItemTool(
      c.get<i41.GroupService>(),
      c.get<i44.ShoppingListService>(),
    ),
  );
  c.singleton<i16.DeleteShoppingItemTool>(
    (IocContainer c) => i16.DeleteShoppingItemTool(
      c.get<i41.GroupService>(),
      c.get<i44.ShoppingListService>(),
    ),
  );
  c.singleton<i16.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i16.ClearDoneShoppingItemsTool(
      c.get<i41.GroupService>(),
      c.get<i44.ShoppingListService>(),
    ),
  );
  c.singleton<i17.ListWalletsTool>(
    (IocContainer c) => i17.ListWalletsTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.CreateWalletTool>(
    (IocContainer c) => i17.CreateWalletTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.UpdateWalletTool>(
    (IocContainer c) => i17.UpdateWalletTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.DeleteWalletTool>(
    (IocContainer c) => i17.DeleteWalletTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.WalletTotalTool>(
    (IocContainer c) => i17.WalletTotalTool(
      c.get<i41.GroupService>(),
      c.get<i36.AccountTotalService>(),
    ),
  );
  c.singleton<i17.WalletHistoryTool>(
    (IocContainer c) => i17.WalletHistoryTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.TransferBetweenWalletsTool>(
    (IocContainer c) => i17.TransferBetweenWalletsTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.ListWalletMembersTool>(
    (IocContainer c) => i17.ListWalletMembersTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
      c.get<i30.AccountShareService>(),
    ),
  );
  c.singleton<i17.InviteWalletMemberTool>(
    (IocContainer c) => i17.InviteWalletMemberTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
      c.get<i30.AccountShareService>(),
    ),
  );
  c.singleton<i17.RemoveWalletMemberTool>(
    (IocContainer c) => i17.RemoveWalletMemberTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
      c.get<i30.AccountShareService>(),
    ),
  );
  c.singleton<i17.ListWalletEntriesTool>(
    (IocContainer c) => i17.ListWalletEntriesTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.RecentWalletEntriesTool>(
    (IocContainer c) => i17.RecentWalletEntriesTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.AddWalletEntryTool>(
    (IocContainer c) => i17.AddWalletEntryTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.UpdateWalletEntryTool>(
    (IocContainer c) => i17.UpdateWalletEntryTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.DeleteWalletEntryTool>(
    (IocContainer c) => i17.DeleteWalletEntryTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.AdjustWalletBalanceTool>(
    (IocContainer c) => i17.AdjustWalletBalanceTool(
      c.get<i41.GroupService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i17.ExchangeRatesTool>(
    (IocContainer c) => i17.ExchangeRatesTool(
      c.get<i41.GroupService>(),
      c.get<i38.FxService>(),
    ),
  );
  c.singleton<i18.AccountRepository>(
    (IocContainer c) => i18.AccountRepository(),
  );
  c.singleton<i19.AccountEntryRepository>(
    (IocContainer c) => i19.AccountEntryRepository(),
  );
  c.singleton<i20.AccountMemberRepository>(
    (IocContainer c) => i20.AccountMemberRepository(),
  );
  c.singleton<i21.BudgetRepository>((IocContainer c) => i21.BudgetRepository());
  c.singleton<i22.CategoryRepository>(
    (IocContainer c) => i22.CategoryRepository(),
  );
  c.singleton<i23.ExpenseRepository>(
    (IocContainer c) => i23.ExpenseRepository(),
  );
  c.singleton<i24.GroupRepository>((IocContainer c) => i24.GroupRepository());
  c.singleton<i25.GroupMemberRepository>(
    (IocContainer c) => i25.GroupMemberRepository(),
  );
  c.singleton<i26.McpTokenRepository>(
    (IocContainer c) => i26.McpTokenRepository(),
  );
  c.singleton<i27.ShoppingItemRepository>(
    (IocContainer c) => i27.ShoppingItemRepository(),
  );
  c.singleton<i28.UserRepository>((IocContainer c) => i28.UserRepository());
  c.singleton<i29.AccountService>(
    (IocContainer c) => i29.AccountService(
      c.get<i18.AccountRepository>(),
      c.get<i19.AccountEntryRepository>(),
      c.get<i25.GroupMemberRepository>(),
      c.get<i20.AccountMemberRepository>(),
    ),
  );
  c.singleton<i30.AccountShareService>(
    (IocContainer c) => i30.AccountShareService(
      c.get<i20.AccountMemberRepository>(),
      c.get<i28.UserRepository>(),
    ),
  );
  c.singleton<i31.BudgetService>(
    (IocContainer c) => i31.BudgetService(c.get<i21.BudgetRepository>()),
  );
  c.singleton<i32.CategoryService>(
    (IocContainer c) => i32.CategoryService(
      c.get<i22.CategoryRepository>(),
      c.get<i23.ExpenseRepository>(),
    ),
  );
  c.singleton<i33.ExpenseService>(
    (IocContainer c) => i33.ExpenseService(
      c.get<i23.ExpenseRepository>(),
      c.get<i32.CategoryService>(),
      c.get<i31.BudgetService>(),
      c.get<i29.AccountService>(),
    ),
  );
  c.singleton<i34.FileCache>((IocContainer c) => i34.FileCache());
  c.singleton<i35.FirebaseService>(
    (IocContainer c) => i35.FirebaseService(c.get<i46.AppSettings>()),
  );
  c.singleton<i36.AccountTotalService>(
    (IocContainer c) => i36.AccountTotalService(
      c.get<i29.AccountService>(),
      c.get<i38.FxService>(),
    ),
  );
  c.singleton<i37.CoinbaseRateProvider>(
    (IocContainer c) => i37.CoinbaseRateProvider(
      c.get<i34.FileCache>(),
      c.get<i40.HttpFetch>(),
    ),
  );
  c.singleton<i38.FxService>(
    (IocContainer c) => i38.FxService(
      c.get<i37.CoinbaseRateProvider>(),
      c.get<i39.GoldQuoteProvider>(),
    ),
  );
  c.singleton<i39.GoldQuoteProvider>(
    (IocContainer c) =>
        i39.GoldQuoteProvider(c.get<i34.FileCache>(), c.get<i40.HttpFetch>()),
  );
  c.singleton<i40.HttpFetch>((IocContainer c) => i40.HttpFetch());
  c.singleton<i41.GroupService>(
    (IocContainer c) => i41.GroupService(
      c.get<i24.GroupRepository>(),
      c.get<i25.GroupMemberRepository>(),
      c.get<i22.CategoryRepository>(),
      c.get<i28.UserRepository>(),
    ),
  );
  c.singleton<i42.McpOAuthService>(
    (IocContainer c) => i42.McpOAuthService(
      c.get<i46.AppSettings>(),
      c.get<i43.McpTokenService>(),
    ),
  );
  c.singleton<i43.McpTokenService>(
    (IocContainer c) => i43.McpTokenService(
      c.get<i26.McpTokenRepository>(),
      c.get<i28.UserRepository>(),
      c.get<i45.UserService>(),
    ),
  );
  c.singleton<i44.ShoppingListService>(
    (IocContainer c) =>
        i44.ShoppingListService(c.get<i27.ShoppingItemRepository>()),
  );
  c.singleton<i45.UserService>(
    (IocContainer c) => i45.UserService(
      c.get<i28.UserRepository>(),
      c.get<i41.GroupService>(),
      c.get<i30.AccountShareService>(),
      c.get<i46.AppSettings>(),
    ),
  );
  c.singleton<i46.AppSettings>((IocContainer c) => i46.AppSettings());
  c.singleton<i47.StaticFiles>(
    (IocContainer c) => i47.StaticFiles(c.get<i46.AppSettings>()),
  );
  c.provider<i48.ORMProvider>((IocContainer c) => i48.ORMProvider());
  c.provider<i49.ScheduleProvider>((IocContainer c) => i49.ScheduleProvider());
  c.router<i50.ApiRouter>((IocContainer c) => i50.ApiRouter());
  c.router<i51.WebRouter>((IocContainer c) => i51.WebRouter());
  c.bindModel<i52.Account>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i52.Account().find(key);
  });
  c.bindModel<i53.AccountEntry>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i53.AccountEntry().find(key);
  });
  c.bindModel<i54.AccountMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i54.AccountMember().find(key);
  });
  c.bindModel<i55.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i55.Category().find(key);
  });
  c.bindModel<i56.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i56.Expense().find(key);
  });
  c.bindModel<i57.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i57.Group().find(key);
  });
  c.bindModel<i58.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i58.GroupMember().find(key);
  });
  c.bindModel<i59.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i59.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i60.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i60.McpToken().find(key);
  });
  c.bindModel<i61.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i61.ShoppingItem().find(key);
  });
  c.bindModel<i62.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i62.User().find(key);
  });
}
