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
import 'package:api_dox/app/repositories/api_token.repository.dart' as i26;
import 'package:api_dox/app/repositories/budget.repository.dart' as i27;
import 'package:api_dox/app/repositories/category.repository.dart' as i28;
import 'package:api_dox/app/repositories/expense.repository.dart' as i29;
import 'package:api_dox/app/repositories/group.repository.dart' as i30;
import 'package:api_dox/app/repositories/group_member.repository.dart' as i31;
import 'package:api_dox/app/repositories/mcp_token.repository.dart' as i32;
import 'package:api_dox/app/repositories/passkey.repository.dart' as i33;
import 'package:api_dox/app/repositories/recurring_expense.repository.dart'
    as i34;
import 'package:api_dox/app/repositories/shopping_item.repository.dart' as i35;
import 'package:api_dox/app/repositories/user.repository.dart' as i36;
import 'package:api_dox/app/services/account.service.dart' as i37;
import 'package:api_dox/app/services/account_share.service.dart' as i38;
import 'package:api_dox/app/services/ai/claude_client.dart' as i39;
import 'package:api_dox/app/services/ai/expense_categorizer.dart' as i40;
import 'package:api_dox/app/services/ai/quick_add_picker.dart' as i41;
import 'package:api_dox/app/services/api_token.service.dart' as i42;
import 'package:api_dox/app/services/budget.service.dart' as i43;
import 'package:api_dox/app/services/category.service.dart' as i44;
import 'package:api_dox/app/services/expense.service.dart' as i45;
import 'package:api_dox/app/services/file_cache.dart' as i46;
import 'package:api_dox/app/services/firebase.service.dart' as i47;
import 'package:api_dox/app/services/fx/account_total.service.dart' as i48;
import 'package:api_dox/app/services/fx/coinbase_rate_provider.dart' as i49;
import 'package:api_dox/app/services/fx/fx.service.dart' as i50;
import 'package:api_dox/app/services/fx/gold_quote_provider.dart' as i51;
import 'package:api_dox/app/services/fx/http_fetch.dart' as i52;
import 'package:api_dox/app/services/group.service.dart' as i53;
import 'package:api_dox/app/services/live.service.dart' as i54;
import 'package:api_dox/app/services/mcp_oauth.service.dart' as i55;
import 'package:api_dox/app/services/mcp_token.service.dart' as i56;
import 'package:api_dox/app/services/passkey/passkey.service.dart' as i57;
import 'package:api_dox/app/services/recurring.service.dart' as i58;
import 'package:api_dox/app/services/report.service.dart' as i59;
import 'package:api_dox/app/services/shopping_list.service.dart' as i60;
import 'package:api_dox/app/services/totp/totp.service.dart' as i61;
import 'package:api_dox/app/services/user.service.dart' as i62;
import 'package:api_dox/config/settings.dart' as i63;
import 'package:api_dox/http/static_files.dart' as i64;
import 'package:api_dox/providers/orm_provider.dart' as i65;
import 'package:api_dox/providers/schedule_provider.dart' as i66;
import 'package:api_dox/providers/socket_io_provider.dart' as i67;
import 'package:api_dox/routes/api.dart' as i68;
import 'package:api_dox/routes/web.dart' as i69;
import 'package:api_dox/app/models/account/account.model.dart' as i70;
import 'package:api_dox/app/models/account_entry/account_entry.model.dart'
    as i71;
import 'package:api_dox/app/models/account_member/account_member.model.dart'
    as i72;
import 'package:api_dox/app/models/api_token/api_token.model.dart' as i73;
import 'package:api_dox/app/models/category/category.model.dart' as i74;
import 'package:api_dox/app/models/expense/expense.model.dart' as i75;
import 'package:api_dox/app/models/group/group.model.dart' as i76;
import 'package:api_dox/app/models/group_member/group_member.model.dart' as i77;
import 'package:api_dox/app/models/group_monthly_budget/group_monthly_budget.model.dart'
    as i78;
import 'package:api_dox/app/models/mcp_token/mcp_token.model.dart' as i79;
import 'package:api_dox/app/models/passkey/passkey.model.dart' as i80;
import 'package:api_dox/app/models/recurring_expense/recurring_expense.model.dart'
    as i81;
import 'package:api_dox/app/models/shopping_item/shopping_item.model.dart'
    as i82;
import 'package:api_dox/app/models/user/user.model.dart' as i83;

/// Puts every class of the app into the container: the
/// `@Inject()` classes, routers, providers and model binders.
/// Use it in `AppConfig(container: registerContainer)`.
void registerContainer(IocContainer c) {
  c.singleton<i1.AccountController>(
    (IocContainer c) => i1.AccountController(
      c.get<i37.AccountService>(),
      c.get<i48.AccountTotalService>(),
      c.get<i50.FxService>(),
      c.get<i38.AccountShareService>(),
    ),
  );
  c.singleton<i2.AuthController>(
    (IocContainer c) => i2.AuthController(c.get<i42.ApiTokenService>()),
  );
  c.singleton<i3.CategoryController>(
    (IocContainer c) => i3.CategoryController(c.get<i44.CategoryService>()),
  );
  c.singleton<i4.ConfigController>(
    (IocContainer c) => i4.ConfigController(c.get<i63.AppSettings>()),
  );
  c.singleton<i5.ExpenseController>(
    (IocContainer c) => i5.ExpenseController(
      c.get<i45.ExpenseService>(),
      c.get<i59.ReportService>(),
    ),
  );
  c.singleton<i6.GroupController>(
    (IocContainer c) => i6.GroupController(
      c.get<i53.GroupService>(),
      c.get<i43.BudgetService>(),
    ),
  );
  c.singleton<i7.HealthController>((IocContainer c) => i7.HealthController());
  c.singleton<i8.McpController>(
    (IocContainer c) => i8.McpController(
      c.get<i55.McpOAuthService>(),
      c.get<i17.McpToolRegistry>(),
    ),
  );
  c.singleton<i9.MeController>(
    (IocContainer c) => i9.MeController(
      c.get<i55.McpOAuthService>(),
      c.get<i56.McpTokenService>(),
    ),
  );
  c.singleton<i10.OauthController>(
    (IocContainer c) => i10.OauthController(
      c.get<i55.McpOAuthService>(),
      c.get<i56.McpTokenService>(),
    ),
  );
  c.singleton<i11.PasskeyController>(
    (IocContainer c) => i11.PasskeyController(c.get<i57.PasskeyService>()),
  );
  c.singleton<i12.RecurringController>(
    (IocContainer c) => i12.RecurringController(c.get<i58.RecurringService>()),
  );
  c.singleton<i13.ShoppingItemController>(
    (IocContainer c) =>
        i13.ShoppingItemController(c.get<i60.ShoppingListService>()),
  );
  c.singleton<i14.TotpController>(
    (IocContainer c) => i14.TotpController(c.get<i61.TotpService>()),
  );
  c.singleton<i15.AuthMiddleware>(
    (IocContainer c) => i15.AuthMiddleware(c.get<i42.ApiTokenService>()),
  );
  c.singleton<i16.GroupMiddleware>(
    (IocContainer c) => i16.GroupMiddleware(c.get<i53.GroupService>()),
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
      c.get<i53.GroupService>(),
      c.get<i44.CategoryService>(),
    ),
  );
  c.singleton<i18.CreateCategoryTool>(
    (IocContainer c) => i18.CreateCategoryTool(
      c.get<i53.GroupService>(),
      c.get<i44.CategoryService>(),
    ),
  );
  c.singleton<i18.UpdateCategoryTool>(
    (IocContainer c) => i18.UpdateCategoryTool(
      c.get<i53.GroupService>(),
      c.get<i44.CategoryService>(),
    ),
  );
  c.singleton<i18.DeleteCategoryTool>(
    (IocContainer c) => i18.DeleteCategoryTool(
      c.get<i53.GroupService>(),
      c.get<i44.CategoryService>(),
    ),
  );
  c.singleton<i19.AddExpenseTool>(
    (IocContainer c) => i19.AddExpenseTool(
      c.get<i53.GroupService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i19.ListExpensesTool>(
    (IocContainer c) => i19.ListExpensesTool(
      c.get<i53.GroupService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i19.FrequentExpensesTool>(
    (IocContainer c) => i19.FrequentExpensesTool(
      c.get<i53.GroupService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i19.UpdateExpenseTool>(
    (IocContainer c) => i19.UpdateExpenseTool(
      c.get<i53.GroupService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i19.DeleteExpenseTool>(
    (IocContainer c) => i19.DeleteExpenseTool(
      c.get<i53.GroupService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i19.MonthlySummaryTool>(
    (IocContainer c) => i19.MonthlySummaryTool(
      c.get<i53.GroupService>(),
      c.get<i44.CategoryService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i20.GetMeTool>(
    (IocContainer c) => i20.GetMeTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.ListGroupsTool>(
    (IocContainer c) => i20.ListGroupsTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.CreateGroupTool>(
    (IocContainer c) => i20.CreateGroupTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.UpdateGroupTool>(
    (IocContainer c) => i20.UpdateGroupTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.ListGroupMembersTool>(
    (IocContainer c) => i20.ListGroupMembersTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.InviteGroupMemberTool>(
    (IocContainer c) => i20.InviteGroupMemberTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.RemoveGroupMemberTool>(
    (IocContainer c) => i20.RemoveGroupMemberTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.LeaveGroupTool>(
    (IocContainer c) => i20.LeaveGroupTool(c.get<i53.GroupService>()),
  );
  c.singleton<i20.GetBudgetTool>(
    (IocContainer c) => i20.GetBudgetTool(
      c.get<i53.GroupService>(),
      c.get<i45.ExpenseService>(),
    ),
  );
  c.singleton<i20.SetBudgetTool>(
    (IocContainer c) => i20.SetBudgetTool(
      c.get<i53.GroupService>(),
      c.get<i43.BudgetService>(),
    ),
  );
  c.singleton<i20.GetDefaultWalletTool>(
    (IocContainer c) => i20.GetDefaultWalletTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i20.SetDefaultWalletTool>(
    (IocContainer c) => i20.SetDefaultWalletTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i21.ListShoppingItemsTool>(
    (IocContainer c) => i21.ListShoppingItemsTool(
      c.get<i53.GroupService>(),
      c.get<i60.ShoppingListService>(),
    ),
  );
  c.singleton<i21.AddShoppingItemTool>(
    (IocContainer c) => i21.AddShoppingItemTool(
      c.get<i53.GroupService>(),
      c.get<i60.ShoppingListService>(),
    ),
  );
  c.singleton<i21.UpdateShoppingItemTool>(
    (IocContainer c) => i21.UpdateShoppingItemTool(
      c.get<i53.GroupService>(),
      c.get<i60.ShoppingListService>(),
    ),
  );
  c.singleton<i21.DeleteShoppingItemTool>(
    (IocContainer c) => i21.DeleteShoppingItemTool(
      c.get<i53.GroupService>(),
      c.get<i60.ShoppingListService>(),
    ),
  );
  c.singleton<i21.ClearDoneShoppingItemsTool>(
    (IocContainer c) => i21.ClearDoneShoppingItemsTool(
      c.get<i53.GroupService>(),
      c.get<i60.ShoppingListService>(),
    ),
  );
  c.singleton<i22.ListWalletsTool>(
    (IocContainer c) => i22.ListWalletsTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.CreateWalletTool>(
    (IocContainer c) => i22.CreateWalletTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.UpdateWalletTool>(
    (IocContainer c) => i22.UpdateWalletTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.DeleteWalletTool>(
    (IocContainer c) => i22.DeleteWalletTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.WalletTotalTool>(
    (IocContainer c) => i22.WalletTotalTool(
      c.get<i53.GroupService>(),
      c.get<i48.AccountTotalService>(),
    ),
  );
  c.singleton<i22.WalletHistoryTool>(
    (IocContainer c) => i22.WalletHistoryTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.TransferBetweenWalletsTool>(
    (IocContainer c) => i22.TransferBetweenWalletsTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.ListWalletMembersTool>(
    (IocContainer c) => i22.ListWalletMembersTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
      c.get<i38.AccountShareService>(),
    ),
  );
  c.singleton<i22.InviteWalletMemberTool>(
    (IocContainer c) => i22.InviteWalletMemberTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
      c.get<i38.AccountShareService>(),
    ),
  );
  c.singleton<i22.RemoveWalletMemberTool>(
    (IocContainer c) => i22.RemoveWalletMemberTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
      c.get<i38.AccountShareService>(),
    ),
  );
  c.singleton<i22.ListWalletEntriesTool>(
    (IocContainer c) => i22.ListWalletEntriesTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.RecentWalletEntriesTool>(
    (IocContainer c) => i22.RecentWalletEntriesTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.AddWalletEntryTool>(
    (IocContainer c) => i22.AddWalletEntryTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.UpdateWalletEntryTool>(
    (IocContainer c) => i22.UpdateWalletEntryTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.DeleteWalletEntryTool>(
    (IocContainer c) => i22.DeleteWalletEntryTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.AdjustWalletBalanceTool>(
    (IocContainer c) => i22.AdjustWalletBalanceTool(
      c.get<i53.GroupService>(),
      c.get<i37.AccountService>(),
    ),
  );
  c.singleton<i22.ExchangeRatesTool>(
    (IocContainer c) => i22.ExchangeRatesTool(
      c.get<i53.GroupService>(),
      c.get<i50.FxService>(),
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
  c.singleton<i26.ApiTokenRepository>(
    (IocContainer c) => i26.ApiTokenRepository(),
  );
  c.singleton<i27.BudgetRepository>((IocContainer c) => i27.BudgetRepository());
  c.singleton<i28.CategoryRepository>(
    (IocContainer c) => i28.CategoryRepository(),
  );
  c.singleton<i29.ExpenseRepository>(
    (IocContainer c) => i29.ExpenseRepository(),
  );
  c.singleton<i30.GroupRepository>((IocContainer c) => i30.GroupRepository());
  c.singleton<i31.GroupMemberRepository>(
    (IocContainer c) => i31.GroupMemberRepository(),
  );
  c.singleton<i32.McpTokenRepository>(
    (IocContainer c) => i32.McpTokenRepository(),
  );
  c.singleton<i33.PasskeyRepository>(
    (IocContainer c) => i33.PasskeyRepository(),
  );
  c.singleton<i34.RecurringExpenseRepository>(
    (IocContainer c) => i34.RecurringExpenseRepository(),
  );
  c.singleton<i35.ShoppingItemRepository>(
    (IocContainer c) => i35.ShoppingItemRepository(),
  );
  c.singleton<i36.UserRepository>((IocContainer c) => i36.UserRepository());
  c.singleton<i37.AccountService>(
    (IocContainer c) => i37.AccountService(
      c.get<i23.AccountRepository>(),
      c.get<i24.AccountEntryRepository>(),
      c.get<i31.GroupMemberRepository>(),
      c.get<i25.AccountMemberRepository>(),
      c.get<i38.AccountShareService>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i38.AccountShareService>(
    (IocContainer c) => i38.AccountShareService(
      c.get<i25.AccountMemberRepository>(),
      c.get<i36.UserRepository>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i39.ClaudeClient>(
    (IocContainer c) => i39.ClaudeClient(c.get<i63.AppSettings>()),
  );
  c.singleton<i40.ExpenseCategorizer>(
    (IocContainer c) => i40.ExpenseCategorizer(
      c.get<i39.ClaudeClient>(),
      c.get<i29.ExpenseRepository>(),
    ),
  );
  c.singleton<i41.QuickAddPicker>(
    (IocContainer c) =>
        i41.QuickAddPicker(c.get<i39.ClaudeClient>(), c.get<i46.FileCache>()),
  );
  c.singleton<i42.ApiTokenService>(
    (IocContainer c) => i42.ApiTokenService(
      c.get<i26.ApiTokenRepository>(),
      c.get<i36.UserRepository>(),
      c.get<i62.UserService>(),
      c.get<i47.FirebaseService>(),
    ),
  );
  c.singleton<i43.BudgetService>(
    (IocContainer c) => i43.BudgetService(
      c.get<i27.BudgetRepository>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i44.CategoryService>(
    (IocContainer c) => i44.CategoryService(
      c.get<i28.CategoryRepository>(),
      c.get<i29.ExpenseRepository>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i45.ExpenseService>(
    (IocContainer c) => i45.ExpenseService(
      c.get<i29.ExpenseRepository>(),
      c.get<i44.CategoryService>(),
      c.get<i43.BudgetService>(),
      c.get<i37.AccountService>(),
      c.get<i54.LiveService>(),
      c.get<i41.QuickAddPicker>(),
      c.get<i40.ExpenseCategorizer>(),
    ),
  );
  c.singleton<i46.FileCache>((IocContainer c) => i46.FileCache());
  c.singleton<i47.FirebaseService>(
    (IocContainer c) => i47.FirebaseService(c.get<i63.AppSettings>()),
  );
  c.singleton<i48.AccountTotalService>(
    (IocContainer c) => i48.AccountTotalService(
      c.get<i37.AccountService>(),
      c.get<i50.FxService>(),
    ),
  );
  c.singleton<i49.CoinbaseRateProvider>(
    (IocContainer c) => i49.CoinbaseRateProvider(
      c.get<i46.FileCache>(),
      c.get<i52.HttpFetch>(),
    ),
  );
  c.singleton<i50.FxService>(
    (IocContainer c) => i50.FxService(
      c.get<i49.CoinbaseRateProvider>(),
      c.get<i51.GoldQuoteProvider>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i51.GoldQuoteProvider>(
    (IocContainer c) =>
        i51.GoldQuoteProvider(c.get<i46.FileCache>(), c.get<i52.HttpFetch>()),
  );
  c.singleton<i52.HttpFetch>((IocContainer c) => i52.HttpFetch());
  c.singleton<i53.GroupService>(
    (IocContainer c) => i53.GroupService(
      c.get<i30.GroupRepository>(),
      c.get<i31.GroupMemberRepository>(),
      c.get<i28.CategoryRepository>(),
      c.get<i36.UserRepository>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i54.LiveService>(
    (IocContainer c) => i54.LiveService(
      c.get<i31.GroupMemberRepository>(),
      c.get<i23.AccountRepository>(),
      c.get<i25.AccountMemberRepository>(),
      c.get<i24.AccountEntryRepository>(),
    ),
  );
  c.singleton<i55.McpOAuthService>(
    (IocContainer c) => i55.McpOAuthService(
      c.get<i63.AppSettings>(),
      c.get<i56.McpTokenService>(),
    ),
  );
  c.singleton<i56.McpTokenService>(
    (IocContainer c) => i56.McpTokenService(
      c.get<i32.McpTokenRepository>(),
      c.get<i36.UserRepository>(),
      c.get<i62.UserService>(),
    ),
  );
  c.singleton<i57.PasskeyService>(
    (IocContainer c) => i57.PasskeyService(
      c.get<i33.PasskeyRepository>(),
      c.get<i36.UserRepository>(),
      c.get<i62.UserService>(),
      c.get<i42.ApiTokenService>(),
      c.get<i63.AppSettings>(),
    ),
  );
  c.singleton<i58.RecurringService>(
    (IocContainer c) => i58.RecurringService(
      c.get<i34.RecurringExpenseRepository>(),
      c.get<i45.ExpenseService>(),
      c.get<i44.CategoryService>(),
      c.get<i37.AccountService>(),
      c.get<i36.UserRepository>(),
      c.get<i30.GroupRepository>(),
      c.get<i31.GroupMemberRepository>(),
    ),
  );
  c.singleton<i59.ReportService>(
    (IocContainer c) => i59.ReportService(
      c.get<i29.ExpenseRepository>(),
      c.get<i31.GroupMemberRepository>(),
      c.get<i36.UserRepository>(),
    ),
  );
  c.singleton<i60.ShoppingListService>(
    (IocContainer c) => i60.ShoppingListService(
      c.get<i35.ShoppingItemRepository>(),
      c.get<i54.LiveService>(),
    ),
  );
  c.singleton<i61.TotpService>(
    (IocContainer c) => i61.TotpService(
      c.get<i36.UserRepository>(),
      c.get<i42.ApiTokenService>(),
    ),
  );
  c.singleton<i62.UserService>(
    (IocContainer c) => i62.UserService(
      c.get<i36.UserRepository>(),
      c.get<i53.GroupService>(),
      c.get<i38.AccountShareService>(),
      c.get<i63.AppSettings>(),
    ),
  );
  c.singleton<i63.AppSettings>((IocContainer c) => i63.AppSettings());
  c.singleton<i64.StaticFiles>(
    (IocContainer c) => i64.StaticFiles(c.get<i63.AppSettings>()),
  );
  c.provider<i65.ORMProvider>((IocContainer c) => i65.ORMProvider());
  c.provider<i66.ScheduleProvider>((IocContainer c) => i66.ScheduleProvider());
  c.provider<i67.AppSocketIoProvider>(
    (IocContainer c) => i67.AppSocketIoProvider(),
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
  c.bindModel<i73.ApiToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i73.ApiToken().find(key);
  });
  c.bindModel<i74.Category>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i74.Category().find(key);
  });
  c.bindModel<i75.Expense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i75.Expense().find(key);
  });
  c.bindModel<i76.Group>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i76.Group().find(key);
  });
  c.bindModel<i77.GroupMember>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i77.GroupMember().find(key);
  });
  c.bindModel<i78.GroupMonthlyBudget>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i78.GroupMonthlyBudget().find(key);
  });
  c.bindModel<i79.McpToken>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i79.McpToken().find(key);
  });
  c.bindModel<i80.Passkey>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i80.Passkey().find(key);
  });
  c.bindModel<i81.RecurringExpense>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i81.RecurringExpense().find(key);
  });
  c.bindModel<i82.ShoppingItem>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i82.ShoppingItem().find(key);
  });
  c.bindModel<i83.User>((String id) {
    int? key = int.tryParse(id);
    if (key == null) return null;
    return i83.User().find(key);
  });
}
