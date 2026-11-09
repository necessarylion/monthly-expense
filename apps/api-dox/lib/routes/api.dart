import 'package:api_dox/app/http/controllers/account.controller.dart';
import 'package:api_dox/app/http/controllers/category.controller.dart';
import 'package:api_dox/app/http/controllers/config.controller.dart';
import 'package:api_dox/app/http/controllers/expense.controller.dart';
import 'package:api_dox/app/http/controllers/group.controller.dart';
import 'package:api_dox/app/http/controllers/health.controller.dart';
import 'package:api_dox/app/http/controllers/mcp.controller.dart';
import 'package:api_dox/app/http/controllers/me.controller.dart';
import 'package:api_dox/app/http/controllers/oauth.controller.dart';
import 'package:api_dox/app/http/controllers/passkey.controller.dart';
import 'package:api_dox/app/services/mcp_oauth.service.dart';
import 'package:api_dox/app/http/controllers/recurring.controller.dart';
import 'package:api_dox/app/http/controllers/shopping_item.controller.dart';
import 'package:api_dox/app/http/middleware/auth.middleware.dart';
import 'package:api_dox/app/http/middleware/group.middleware.dart';
import 'package:dox_core/dox_core.dart';

/// Every route, with the same paths as the Bun API. `user` routes need a
/// Firebase ID token; `member` routes also need `X-Group-Id`.
class ApiRouter extends Router {
  @override
  void register() {
    IocContainer ioc = Dox().ioc;
    List<dynamic> user = <dynamic>[ioc.get<AuthMiddleware>()];
    List<dynamic> member = <dynamic>[...user, ioc.get<GroupMiddleware>()];

    Route.get('/healthz', (HealthController c) => c.show);
    Route.get('/config.js', (ConfigController c) => c.script);

    Route.group('/api/v1', () {
      // Passkey sign-in: no token yet.
      Route.post(
        '/passkeys/login/options',
        (PasskeyController c) => c.loginOptions,
      );
      Route.post('/passkeys/login', (PasskeyController c) => c.login);

      Route.middleware(user, () {
        Route.get('/me', (MeController c) => c.show);
        Route.get('/me/mcp', (MeController c) => c.mcp);
        Route.post('/me/mcp/rotate', (MeController c) => c.rotateMcp);
        Route.delete(
          '/me/mcp/clients/{id}',
          (MeController c) => c.revokeMcpClient,
        );
        Route.get('/me/passkeys', (PasskeyController c) => c.index);
        Route.post(
          '/me/passkeys/options',
          (PasskeyController c) => c.registrationOptions,
        );
        Route.post('/me/passkeys', (PasskeyController c) => c.store);
        Route.delete('/me/passkeys/{id}', (PasskeyController c) => c.destroy);

        // the web app's consent page for an MCP client (OAuth)
        Route.get('/oauth/client', (OauthController c) => c.client);
        Route.post('/oauth/approve', (OauthController c) => c.approve);
        Route.post('/oauth/deny', (OauthController c) => c.deny);

        Route.get('/groups', (GroupController c) => c.index);
        Route.post('/groups', (GroupController c) => c.store);
        Route.patch('/groups/{id}', (GroupController c) => c.update);
        Route.put('/groups/{id}/budget', (GroupController c) => c.setBudget);
        Route.get('/groups/{id}/members', (GroupController c) => c.members);
        Route.post('/groups/{id}/invitations', (GroupController c) => c.invite);
        Route.delete(
          '/groups/{id}/members/{memberId}',
          (GroupController c) => c.removeMember,
        );
        Route.delete('/groups/{id}/membership', (GroupController c) => c.leave);

        Route.get('/fx', (AccountController c) => c.fx);

        // Accounts belong to the user (and who they share it with), so no
        // group middleware.
        Route.get('/accounts', (AccountController c) => c.index);
        Route.post('/accounts', (AccountController c) => c.store);
        Route.get(
          '/accounts/recent-entries',
          (AccountController c) => c.recent,
        );
        Route.get('/accounts/total', (AccountController c) => c.total);
        Route.get('/accounts/history', (AccountController c) => c.history);
        Route.post('/accounts/transfers', (AccountController c) => c.transfer);
        Route.patch('/accounts/{id}', (AccountController c) => c.update);
        Route.delete('/accounts/{id}', (AccountController c) => c.destroy);
        Route.get('/accounts/{id}/members', (AccountController c) => c.members);
        Route.post('/accounts/{id}/members', (AccountController c) => c.invite);
        Route.delete(
          '/accounts/{id}/members/{memberId}',
          (AccountController c) => c.removeMember,
        );
        Route.get('/accounts/{id}/entries', (AccountController c) => c.entries);
        Route.post(
          '/accounts/{id}/entries',
          (AccountController c) => c.storeEntry,
        );
        Route.post(
          '/accounts/{id}/adjustments',
          (AccountController c) => c.adjustBalance,
        );
        Route.patch(
          '/accounts/{id}/entries/{entryId}',
          (AccountController c) => c.updateEntry,
        );
        Route.delete(
          '/accounts/{id}/entries/{entryId}',
          (AccountController c) => c.destroyEntry,
        );
      });

      Route.middleware(member, () {
        Route.get('/categories', (CategoryController c) => c.index);
        Route.post('/categories', (CategoryController c) => c.store);
        Route.patch('/categories/{id}', (CategoryController c) => c.update);
        Route.delete('/categories/{id}', (CategoryController c) => c.destroy);

        Route.get('/expenses', (ExpenseController c) => c.index);
        Route.get('/expenses/frequent', (ExpenseController c) => c.frequent);
        Route.get('/expenses/search', (ExpenseController c) => c.search);
        Route.post('/expenses', (ExpenseController c) => c.store);
        Route.patch('/expenses/{id}', (ExpenseController c) => c.update);
        Route.delete('/expenses/{id}', (ExpenseController c) => c.destroy);
        Route.get('/summary', (ExpenseController c) => c.summary);
        Route.get('/summary/year', (ExpenseController c) => c.year);
        Route.get('/balances', (ExpenseController c) => c.balances);

        Route.get('/recurring', (RecurringController c) => c.index);
        Route.post('/recurring', (RecurringController c) => c.store);
        Route.delete('/recurring/{id}', (RecurringController c) => c.destroy);

        Route.get('/shopping-items', (ShoppingItemController c) => c.index);
        Route.post('/shopping-items', (ShoppingItemController c) => c.store);
        // before `{id}`, so `done` is not read as an id
        Route.delete(
          '/shopping-items/done',
          (ShoppingItemController c) => c.clearDone,
        );
        Route.patch(
          '/shopping-items/{id}',
          (ShoppingItemController c) => c.update,
        );
        Route.delete(
          '/shopping-items/{id}',
          (ShoppingItemController c) => c.destroy,
        );

        // The pay-from default is per member, per group.
        Route.get(
          '/default-account',
          (AccountController c) => c.defaultAccount,
        );
        Route.put(
          '/default-account',
          (AccountController c) => c.setDefaultAccount,
        );
      });
    });

    // MCP: OAuth discovery, register and token (dox_mcp), then `/mcp`
    // with `Authorization: Bearer`.
    ioc.get<McpOAuthService>().oauth.routes();
    Route.match(
      <String>['GET', 'POST', 'DELETE'],
      '/mcp',
      (McpController c) => c.handle,
    );
  }
}
