// GENERATED CODE - DO NOT MODIFY BY HAND
// Made by dox_builder. Run `dart run build_runner build`.
// ignore_for_file: type=lint

import 'package:dox_core/dox_core.dart';

/// OpenAPI docs found in the code.
/// Use it in `OpenApiConfig(registry: openApiRegistry)`.
const OpenApiRegistry openApiRegistry = OpenApiRegistry(
  operations: <OpenApiOperation>[
    OpenApiOperation(
      controller: 'HealthController',
      method: 'show',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Health'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{
            'type': 'object',
            'additionalProperties': <String, dynamic>{'type': 'string'},
          },
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ConfigController',
      method: 'script',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Config'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'MeController',
      method: 'show',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Me'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'MeController',
      method: 'mcp',
      argumentTypes: <String>['DoxRequest'],
      summary: 'The MCP address and the clients that signed in',
      description: 'The address has no token: a client signs in with OAuth by itself.\n`url` keeps the shape older clients read.',
      tags: <String>['Me'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'MeController',
      method: 'rotateMcp',
      argumentTypes: <String>['DoxRequest'],
      summary: 'Sign out every MCP client',
      description:
          'The old "rotate the token" button. The web app still calls it.',
      tags: <String>['Me'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'MeController',
      method: 'revokeMcpClient',
      argumentTypes: <String>['DoxRequest', 'int'],
      summary: 'Sign out one MCP client',
      tags: <String>['Me'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'OauthController',
      method: 'client',
      argumentTypes: <String>['DoxRequest', 'OauthClientQuery'],
      summary: 'The client asking to connect',
      description: 'Its name and the host the code goes to, for the consent page. 422 when\nthe client or the redirect address is wrong.',
      tags: <String>['Oauth'],
      schema: <String, dynamic>{
        '\$ref': '#/components/schemas/OauthClientQuery',
      },
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'OauthController',
      method: 'approve',
      argumentTypes: <String>['DoxRequest', 'ApproveOauth'],
      summary: 'Allow the client',
      description:
          'Gives the address to send the browser to, with a one-time code.',
      tags: <String>['Oauth'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/ApproveOauth'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'OauthController',
      method: 'deny',
      argumentTypes: <String>['DenyOauth'],
      summary: 'Say no to the client',
      description: 'Gives the address to send the browser back to, with `access_denied`.',
      tags: <String>['Oauth'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/DenyOauth'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'index',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Group'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'store',
      argumentTypes: <String>['DoxRequest', 'CreateGroup'],
      tags: <String>['Group'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/CreateGroup'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'update',
      argumentTypes: <String>['DoxRequest', 'int', 'UpdateGroup'],
      tags: <String>['Group'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/UpdateGroup'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'setBudget',
      argumentTypes: <String>['DoxRequest', 'int', 'SetBudget'],
      tags: <String>['Group'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/SetBudget'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'members',
      argumentTypes: <String>['DoxRequest', 'int'],
      tags: <String>['Group'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'invite',
      argumentTypes: <String>['DoxRequest', 'int', 'Invite'],
      tags: <String>['Group'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/Invite'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'removeMember',
      argumentTypes: <String>['DoxRequest', 'int', 'int'],
      tags: <String>['Group'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'GroupController',
      method: 'leave',
      argumentTypes: <String>['DoxRequest', 'int'],
      tags: <String>['Group'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'index',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Account'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'store',
      argumentTypes: <String>['DoxRequest', 'CreateAccount'],
      tags: <String>['Account'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/CreateAccount'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'update',
      argumentTypes: <String>['DoxRequest', 'int', 'UpdateAccount'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/UpdateAccount'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'destroy',
      argumentTypes: <String>['DoxRequest', 'int'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'defaultAccount',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Account'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'setDefaultAccount',
      argumentTypes: <String>['DoxRequest', 'SetDefaultAccount'],
      tags: <String>['Account'],
      schema: <String, dynamic>{
        '\$ref': '#/components/schemas/SetDefaultAccount',
      },
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'fx',
      argumentTypes: <String>['FxQuery'],
      summary: 'Rates table plus the gold ornament quote, for the rates page.',
      description: '`?base=THB`',
      tags: <String>['Account'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/FxQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'history',
      argumentTypes: <String>['DoxRequest', 'HistoryQuery'],
      summary: 'End-of-day balances per account. `?days=30` (1 to 365).',
      tags: <String>['Account'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/HistoryQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'total',
      argumentTypes: <String>['DoxRequest', 'TotalQuery'],
      summary: '`?currency=THB`',
      tags: <String>['Account'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/TotalQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'transfer',
      argumentTypes: <String>['DoxRequest', 'Transfer'],
      tags: <String>['Account'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/Transfer'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'recent',
      argumentTypes: <String>['DoxRequest', 'PageQuery'],
      summary: 'Optional `?limit` and `?offset`. The defaults keep old callers',
      description: 'working.',
      tags: <String>['Account'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/PageQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'entries',
      argumentTypes: <String>['DoxRequest', 'int', 'PageQuery'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/PageQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'storeEntry',
      argumentTypes: <String>['DoxRequest', 'int', 'CreateEntry'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/CreateEntry'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'adjustBalance',
      argumentTypes: <String>['DoxRequest', 'int', 'AdjustBalance'],
      summary:
          'Set the balance to an exact value; returns the entry that makes up',
      description: 'the difference.',
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/AdjustBalance'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'updateEntry',
      argumentTypes: <String>['DoxRequest', 'int', 'int', 'UpdateEntry'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/UpdateEntry'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'destroyEntry',
      argumentTypes: <String>['DoxRequest', 'int', 'int'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'members',
      argumentTypes: <String>['DoxRequest', 'int'],
      summary: 'The owner and everyone the wallet is shared with.',
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'invite',
      argumentTypes: <String>['DoxRequest', 'int', 'Invite'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/Invite'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'AccountController',
      method: 'removeMember',
      argumentTypes: <String>['DoxRequest', 'int', 'int'],
      tags: <String>['Account'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'CategoryController',
      method: 'index',
      argumentTypes: <String>['DoxRequest'],
      tags: <String>['Category'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'CategoryController',
      method: 'store',
      argumentTypes: <String>['DoxRequest', 'CreateCategory'],
      tags: <String>['Category'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/CreateCategory'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'CategoryController',
      method: 'update',
      argumentTypes: <String>['DoxRequest', 'int', 'UpdateCategory'],
      tags: <String>['Category'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/UpdateCategory'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'CategoryController',
      method: 'destroy',
      argumentTypes: <String>['DoxRequest', 'int'],
      tags: <String>['Category'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'ExpenseController',
      method: 'index',
      argumentTypes: <String>['DoxRequest', 'MonthQuery'],
      tags: <String>['Expense'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/MonthQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ExpenseController',
      method: 'frequent',
      argumentTypes: <String>['DoxRequest'],
      summary: 'Expenses this group logs again and again (for one-tap adds).',
      tags: <String>['Expense'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ExpenseController',
      method: 'summary',
      argumentTypes: <String>['DoxRequest', 'MonthQuery'],
      tags: <String>['Expense'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/MonthQuery'},
      requestIn: 'query',
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ExpenseController',
      method: 'store',
      argumentTypes: <String>['DoxRequest', 'CreateExpense'],
      tags: <String>['Expense'],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/CreateExpense'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'ExpenseController',
      method: 'update',
      argumentTypes: <String>['DoxRequest', 'int', 'UpdateExpense'],
      tags: <String>['Expense'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{'\$ref': '#/components/schemas/UpdateExpense'},
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ExpenseController',
      method: 'destroy',
      argumentTypes: <String>['DoxRequest', 'int'],
      tags: <String>['Expense'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'ShoppingItemController',
      method: 'index',
      argumentTypes: <String>['DoxRequest'],
      summary: 'The group\'s shopping list',
      description:
          'Still to buy first (oldest first), then bought (latest first).',
      tags: <String>['ShoppingItem'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ShoppingItemController',
      method: 'store',
      argumentTypes: <String>['DoxRequest', 'CreateShoppingItem'],
      summary: 'Add an item',
      tags: <String>['ShoppingItem'],
      schema: <String, dynamic>{
        '\$ref': '#/components/schemas/CreateShoppingItem',
      },
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'ShoppingItemController',
      method: 'update',
      argumentTypes: <String>['DoxRequest', 'int', 'UpdateShoppingItem'],
      summary: 'Rename an item, or tick / untick it',
      tags: <String>['ShoppingItem'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      schema: <String, dynamic>{
        '\$ref': '#/components/schemas/UpdateShoppingItem',
      },
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
    OpenApiOperation(
      controller: 'ShoppingItemController',
      method: 'destroy',
      argumentTypes: <String>['DoxRequest', 'int'],
      summary: 'Delete an item',
      tags: <String>['ShoppingItem'],
      params: <Map<String, dynamic>>[
        <String, dynamic>{'type': 'integer'},
      ],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(description: 'Successful response'),
      },
    ),
    OpenApiOperation(
      controller: 'ShoppingItemController',
      method: 'clearDone',
      argumentTypes: <String>['DoxRequest'],
      summary: 'Clear the bought items',
      tags: <String>['ShoppingItem'],
      responses: <int, ResponseDoc>{
        200: ResponseDoc(
          description: 'Successful response',
          schema: <String, dynamic>{'type': 'object'},
        ),
      },
    ),
  ],
  routes: <OpenApiRouteBinding>[
    OpenApiRouteBinding('GET', '/healthz', 'HealthController.show'),
    OpenApiRouteBinding('GET', '/config.js', 'ConfigController.script'),
    OpenApiRouteBinding('GET', '/api/v1/me', 'MeController.show'),
    OpenApiRouteBinding('GET', '/api/v1/me/mcp', 'MeController.mcp'),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/me/mcp/rotate',
      'MeController.rotateMcp',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/me/mcp/clients/{id}',
      'MeController.revokeMcpClient',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/oauth/client',
      'OauthController.client',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/oauth/approve',
      'OauthController.approve',
    ),
    OpenApiRouteBinding('POST', '/api/v1/oauth/deny', 'OauthController.deny'),
    OpenApiRouteBinding('GET', '/api/v1/groups', 'GroupController.index'),
    OpenApiRouteBinding('POST', '/api/v1/groups', 'GroupController.store'),
    OpenApiRouteBinding(
      'PATCH',
      '/api/v1/groups/{id}',
      'GroupController.update',
    ),
    OpenApiRouteBinding(
      'PUT',
      '/api/v1/groups/{id}/budget',
      'GroupController.setBudget',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/groups/{id}/members',
      'GroupController.members',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/groups/{id}/invitations',
      'GroupController.invite',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/groups/{id}/members/{memberId}',
      'GroupController.removeMember',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/groups/{id}/membership',
      'GroupController.leave',
    ),
    OpenApiRouteBinding('GET', '/api/v1/fx', 'AccountController.fx'),
    OpenApiRouteBinding('GET', '/api/v1/accounts', 'AccountController.index'),
    OpenApiRouteBinding('POST', '/api/v1/accounts', 'AccountController.store'),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/accounts/recent-entries',
      'AccountController.recent',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/accounts/total',
      'AccountController.total',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/accounts/history',
      'AccountController.history',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/accounts/transfers',
      'AccountController.transfer',
    ),
    OpenApiRouteBinding(
      'PATCH',
      '/api/v1/accounts/{id}',
      'AccountController.update',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/accounts/{id}',
      'AccountController.destroy',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/accounts/{id}/members',
      'AccountController.members',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/accounts/{id}/members',
      'AccountController.invite',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/accounts/{id}/members/{memberId}',
      'AccountController.removeMember',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/accounts/{id}/entries',
      'AccountController.entries',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/accounts/{id}/entries',
      'AccountController.storeEntry',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/accounts/{id}/adjustments',
      'AccountController.adjustBalance',
    ),
    OpenApiRouteBinding(
      'PATCH',
      '/api/v1/accounts/{id}/entries/{entryId}',
      'AccountController.updateEntry',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/accounts/{id}/entries/{entryId}',
      'AccountController.destroyEntry',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/categories',
      'CategoryController.index',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/categories',
      'CategoryController.store',
    ),
    OpenApiRouteBinding(
      'PATCH',
      '/api/v1/categories/{id}',
      'CategoryController.update',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/categories/{id}',
      'CategoryController.destroy',
    ),
    OpenApiRouteBinding('GET', '/api/v1/expenses', 'ExpenseController.index'),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/expenses/frequent',
      'ExpenseController.frequent',
    ),
    OpenApiRouteBinding('POST', '/api/v1/expenses', 'ExpenseController.store'),
    OpenApiRouteBinding(
      'PATCH',
      '/api/v1/expenses/{id}',
      'ExpenseController.update',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/expenses/{id}',
      'ExpenseController.destroy',
    ),
    OpenApiRouteBinding('GET', '/api/v1/summary', 'ExpenseController.summary'),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/shopping-items',
      'ShoppingItemController.index',
    ),
    OpenApiRouteBinding(
      'POST',
      '/api/v1/shopping-items',
      'ShoppingItemController.store',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/shopping-items/done',
      'ShoppingItemController.clearDone',
    ),
    OpenApiRouteBinding(
      'PATCH',
      '/api/v1/shopping-items/{id}',
      'ShoppingItemController.update',
    ),
    OpenApiRouteBinding(
      'DELETE',
      '/api/v1/shopping-items/{id}',
      'ShoppingItemController.destroy',
    ),
    OpenApiRouteBinding(
      'GET',
      '/api/v1/default-account',
      'AccountController.defaultAccount',
    ),
    OpenApiRouteBinding(
      'PUT',
      '/api/v1/default-account',
      'AccountController.setDefaultAccount',
    ),
  ],
  schemas: <String, Map<String, dynamic>>{
    'OauthClientQuery': <String, dynamic>{
      'type': 'object',
      'title': 'OauthClientQuery',
      'properties': <String, dynamic>{
        'client_id': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'redirect_uri': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
      },
      'required': <dynamic>['client_id', 'redirect_uri'],
    },
    'ApproveOauth': <String, dynamic>{
      'type': 'object',
      'title': 'ApproveOauth',
      'properties': <String, dynamic>{
        'clientId': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'redirectUri': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'codeChallenge': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'codeChallengeMethod': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 20,
        },
        'state': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 2000,
        },
        'resource': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 2000,
        },
      },
      'required': <dynamic>[
        'clientId',
        'redirectUri',
        'codeChallenge',
        'codeChallengeMethod',
      ],
    },
    'DenyOauth': <String, dynamic>{
      'type': 'object',
      'title': 'DenyOauth',
      'properties': <String, dynamic>{
        'clientId': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'redirectUri': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'state': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 2000,
        },
      },
      'required': <dynamic>['clientId', 'redirectUri'],
    },
    'CreateGroup': <String, dynamic>{
      'type': 'object',
      'title': 'CreateGroup',
      'properties': <String, dynamic>{
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 80,
          'description': 'Group name, e.g. "Family".',
        },
        'currency': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'pattern': '^(?:[A-Z]{3})\$',
          'description':
              '3-letter currency code, e.g. "THB" or "USD". Defaults to THB.',
        },
      },
      'required': <dynamic>['name'],
    },
    'UpdateGroup': <String, dynamic>{
      'type': 'object',
      'title': 'UpdateGroup',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 80,
          'description': 'New group name.',
        },
        'currency': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'pattern': '^(?:[A-Z]{3})\$',
          'description':
              'New currency. 3-letter currency code, e.g. "THB" or "USD".',
        },
      },
    },
    'SetBudget': <String, dynamic>{
      'type': 'object',
      'title': 'SetBudget',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'month': <String, dynamic>{
          'type': 'string',
          'description': 'Month in YYYY-MM format.',
        },
        'budget': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': 0,
          'maximum': 1000000000,
          'description': 'Monthly budget in dollars. Pass null to clear the budget of this month, so the one before carries forward again.',
        },
      },
      'required': <dynamic>['month'],
    },
    'Invite': <String, dynamic>{
      'type': 'object',
      'title': 'Invite',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID, for invite_group_member (see list_groups).',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description':
              'Wallet ID, for invite_wallet_member (see list_wallets).',
        },
        'email': <String, dynamic>{
          'type': 'string',
          'format': 'email',
          'description':
              'Gmail address of the person. They join when they next sign in.',
        },
      },
      'required': <dynamic>['email'],
    },
    'CreateAccount': <String, dynamic>{
      'type': 'object',
      'title': 'CreateAccount',
      'properties': <String, dynamic>{
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 50,
          'description': 'Wallet name, e.g. "Cash" or "KBank".',
        },
        'currency': <String, dynamic>{
          'type': 'string',
          'pattern': '^(?:[A-Z]{3})\$',
          'description': '3-letter currency code, e.g. "THB" or "USD".',
        },
        'color': <String, dynamic>{
          'type': 'string',
          'description': 'Hex color, e.g. "#3b82f6".',
        },
        'includeInTotal': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Count this wallet in the total. Defaults to true.',
        },
        'isDefault': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Deprecated. Old clients only; maps onto every membership\'s default.',
        },
      },
      'required': <dynamic>['name', 'currency', 'color'],
    },
    'UpdateAccount': <String, dynamic>{
      'type': 'object',
      'title': 'UpdateAccount',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 50,
          'description': 'New name.',
        },
        'currency': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'pattern': '^(?:[A-Z]{3})\$',
          'description':
              'New currency. 3-letter currency code, e.g. "THB" or "USD".',
        },
        'color': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New color. Hex color, e.g. "#3b82f6".',
        },
        'includeInTotal': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Count this wallet in the total.',
        },
        'isDefault': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Deprecated. Old clients only; maps onto every membership\'s default.',
        },
      },
    },
    'SetDefaultAccount': <String, dynamic>{
      'type': 'object',
      'title': 'SetDefaultAccount',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet that new expenses in this group are paid from (see list_wallets). Pass null to clear it.',
        },
      },
    },
    'FxQuery': <String, dynamic>{
      'type': 'object',
      'title': 'FxQuery',
      'properties': <String, dynamic>{
        'base': <String, dynamic>{
          'type': 'string',
          'description': 'Base currency of the rates. 3-letter currency code, e.g. "THB" or "USD". Defaults to USD.',
          'default': 'USD',
        },
      },
    },
    'HistoryQuery': <String, dynamic>{
      'type': 'object',
      'title': 'HistoryQuery',
      'properties': <String, dynamic>{
        'days': <String, dynamic>{
          'type': 'number',
          'not': <String, dynamic>{
            'enum': <dynamic>[0],
          },
          'description': 'How many days back, 1 to 365. Defaults to 30.',
          'default': 30,
        },
      },
    },
    'TotalQuery': <String, dynamic>{
      'type': 'object',
      'title': 'TotalQuery',
      'properties': <String, dynamic>{
        'currency': <String, dynamic>{
          'type': 'string',
          'description': 'Currency of the total. 3-letter currency code, e.g. "THB" or "USD". Defaults to THB.',
          'default': 'THB',
        },
      },
    },
    'Transfer': <String, dynamic>{
      'type': 'object',
      'title': 'Transfer',
      'properties': <String, dynamic>{
        'fromAccountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet the money leaves (see list_wallets).',
        },
        'toAccountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet the money arrives in (see list_wallets).',
        },
        'amount': <String, dynamic>{
          'type': 'number',
          'minimum': 0.01,
          'maximum': 10000000,
          'description':
              'Amount leaving, in the currency of the source wallet.',
        },
        'toAmount': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': 0.01,
          'maximum': 10000000,
          'description': 'Amount arriving, in the currency of the target wallet. Only for wallets in different currencies. Defaults to amount.',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
      },
      'required': <dynamic>[
        'fromAccountId',
        'toAccountId',
        'amount',
        'occurredOn',
      ],
    },
    'PageQuery': <String, dynamic>{
      'type': 'object',
      'title': 'PageQuery',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description':
              'Wallet ID, for list_wallet_entries (see list_wallets).',
        },
        'limit': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'not': <String, dynamic>{
            'enum': <dynamic>[0],
          },
          'description': 'How many entries, newest first. At most 500.',
        },
        'offset': <String, dynamic>{
          'type': 'number',
          'description': 'How many entries to skip. Defaults to 0.',
          'default': 0,
        },
      },
    },
    'CreateEntry': <String, dynamic>{
      'type': 'object',
      'title': 'CreateEntry',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'amount': <String, dynamic>{
          'type': 'number',
          'minimum': -10000000,
          'maximum': 10000000,
          'description': 'Amount in dollars. Positive is money in, negative is money out. Not zero.',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
      },
      'required': <dynamic>['amount', 'occurredOn'],
    },
    'AdjustBalance': <String, dynamic>{
      'type': 'object',
      'title': 'AdjustBalance',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'balance': <String, dynamic>{
          'type': 'number',
          'minimum': -10000000,
          'maximum': 10000000,
          'description': 'The balance it should have, in dollars. May be negative (credit cards). The difference is booked as one entry.',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note. Defaults to "Balance adjustment".',
        },
      },
      'required': <dynamic>['balance', 'occurredOn'],
    },
    'UpdateEntry': <String, dynamic>{
      'type': 'object',
      'title': 'UpdateEntry',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'entryId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Entry ID (see list_wallet_entries). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'amount': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': -10000000,
          'maximum': 10000000,
          'description': 'New signed amount in dollars. Not zero.',
        },
        'occurredOn': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'New note. Pass null to clear it.',
        },
      },
    },
    'CreateCategory': <String, dynamic>{
      'type': 'object',
      'title': 'CreateCategory',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 50,
          'description': 'Display name, e.g. "Coffee".',
        },
        'iconKey': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 50,
          'description': 'Icon key. One of: utensils, car, home, shopping-bag, heart-pulse, film, receipt, wallet, coffee, gift, plane, book, dumbbell, fuel, shirt, zap, tag.',
        },
        'color': <String, dynamic>{
          'type': 'string',
          'description': 'Hex color, e.g. "#3b82f6".',
        },
      },
      'required': <dynamic>['name', 'iconKey', 'color'],
    },
    'UpdateCategory': <String, dynamic>{
      'type': 'object',
      'title': 'UpdateCategory',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Category ID (see list_categories). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 50,
          'description': 'New display name.',
        },
        'iconKey': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 50,
          'description': 'New icon key. Icon key. One of: utensils, car, home, shopping-bag, heart-pulse, film, receipt, wallet, coffee, gift, plane, book, dumbbell, fuel, shirt, zap, tag.',
        },
        'color': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New color. Hex color, e.g. "#3b82f6".',
        },
      },
    },
    'MonthQuery': <String, dynamic>{
      'type': 'object',
      'title': 'MonthQuery',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'month': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description':
              'Month in YYYY-MM format. Defaults to the current month.',
        },
      },
    },
    'CreateExpense': <String, dynamic>{
      'type': 'object',
      'title': 'CreateExpense',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'categoryId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Category ID (see list_categories).',
        },
        'amount': <String, dynamic>{
          'type': 'number',
          'minimum': 0.01,
          'maximum': 10000000,
          'description': 'Amount in dollars (use a decimal, e.g. 12.50).',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date the expense occurred, in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet to pay from (see list_wallets). Leave it out to use your default wallet of the group. Pass null to record no wallet entry.',
        },
      },
      'required': <dynamic>['categoryId', 'amount', 'occurredOn'],
    },
    'UpdateExpense': <String, dynamic>{
      'type': 'object',
      'title': 'UpdateExpense',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Expense ID (see list_expenses). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'categoryId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'New category ID (see list_categories).',
        },
        'amount': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': 0.01,
          'maximum': 10000000,
          'description': 'New amount in dollars.',
        },
        'occurredOn': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'New note. Pass null to clear it.',
        },
      },
    },
    'CreateShoppingItem': <String, dynamic>{
      'type': 'object',
      'title': 'CreateShoppingItem',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 200,
          'description': 'What to buy, e.g. "Milk".',
        },
      },
      'required': <dynamic>['name'],
    },
    'UpdateShoppingItem': <String, dynamic>{
      'type': 'object',
      'title': 'UpdateShoppingItem',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Item ID (see list_shopping_items). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 200,
          'description': 'New name.',
        },
        'done': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'true when bought, false to put it back on the list.',
        },
      },
    },
  },
);
