import 'package:api_dox/app/dtos/account/account.dto.dart';
import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/serializers/account_entry.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/account_share.service.dart';
import 'package:api_dox/app/services/fx/account_total.service.dart';
import 'package:api_dox/app/services/fx/fx.service.dart';
import 'package:api_dox/app/services/fx/gold_quote_provider.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

/// Accounts belong to a user (and who they share it with), not a group
/// (except the per-group default). The UI calls them wallets.
@Inject()
@Tags(<String>['Wallets'])
class AccountController {
  AccountController(this.accounts, this.totals, this.fxService, this.shares);

  final AccountService accounts;
  final AccountTotalService totals;
  final FxService fxService;
  final AccountShareService shares;

  @Summary('List wallets')
  @Description('The user\'s wallets (own and shared), each with its balance.')
  Future<Map<String, dynamic>> index(DoxRequest req) async {
    List<AccountWithBalance> list = await accounts.withBalances(req.authUser);
    return JsonResponse.ok(<Map<String, dynamic>>[
      for (AccountWithBalance account in list) account.toJson(),
    ]);
  }

  @Summary('Create a wallet')
  @Response(201, null, description: 'Created')
  Future<DoxResponse> store(DoxRequest req, CreateAccount body) async {
    AccountWithBalance account = await accounts.create(req.authUser, body);
    return JsonResponse.created(account.toJson());
  }

  @Summary('Update a wallet')
  Future<Map<String, dynamic>> update(
    DoxRequest req,
    int id,
    UpdateAccount body,
  ) async {
    AccountWithBalance account = await accounts.update(req.authUser, id, body);
    return JsonResponse.ok(account.toJson());
  }

  @Summary('Delete a wallet')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    await accounts.delete(req.authUser, id);
    return JsonResponse.noContent();
  }

  @Summary('Get the default wallet')
  @Description('The wallet that expenses in this group pay from by default.')
  Future<Map<String, dynamic>> defaultAccount(DoxRequest req) async {
    int? accountId = await accounts.defaultAccountId(
      req.authUser,
      req.activeGroup,
    );
    return JsonResponse.ok(<String, dynamic>{'accountId': accountId});
  }

  @Summary('Set the default wallet')
  @Description('Set or clear the wallet that expenses in this group pay from.')
  Future<Map<String, dynamic>> setDefaultAccount(
    DoxRequest req,
    SetDefaultAccount body,
  ) async {
    int? accountId = body.accountId.value;
    await accounts.setDefaultAccountId(
      req.authUser,
      req.activeGroup,
      accountId,
    );
    return JsonResponse.ok(<String, dynamic>{'accountId': accountId});
  }

  @Summary('Exchange rates')
  @Description(
    'Rates table plus the gold ornament quote, for the rates page. `?base=THB`',
  )
  Future<Map<String, dynamic>> fx(FxQuery query) async {
    RatesResult table = await fxService.ratesFor(query.base);
    GoldQuote? goldQuote;
    try {
      goldQuote = await fxService.goldQuote();
    } catch (_) {
      // the page works without gold
    }
    return JsonResponse.ok(<String, dynamic>{
      ...table.toJson(),
      'gold': goldQuote?.toJson(),
    });
  }

  @Summary('Balance history')
  @Description('End-of-day balances per wallet. `?days=30` (1 to 365).')
  Future<Map<String, dynamic>> history(
    DoxRequest req,
    HistoryQuery query,
  ) async {
    int days = query.days.floor().clamp(1, balanceHistoryMaxDays);
    BalanceHistory history = await accounts.balanceHistory(req.authUser, days);
    return JsonResponse.ok(history.toJson());
  }

  @Summary('Total of all wallets')
  @Description(
    'The sum of the wallets marked "include in total", in one currency. `?currency=THB`',
  )
  Future<Map<String, dynamic>> total(DoxRequest req, TotalQuery query) async {
    AccountTotal total = await totals.total(req.authUser, query.currency);
    return JsonResponse.ok(total.toJson());
  }

  @Summary('Transfer between wallets')
  @Description(
    'Makes one entry out of the first wallet and one entry into the second.',
  )
  @Response(201, null, description: 'Created')
  Future<DoxResponse> transfer(DoxRequest req, Transfer body) async {
    (AccountEntry, AccountEntry) result = await accounts.transfer(
      req.authUser,
      body,
    );
    return JsonResponse.created(<String, dynamic>{
      'out': AccountEntrySerializer(result.$1).toJson(),
      'in': AccountEntrySerializer(result.$2).toJson(),
    });
  }

  @Summary('Recent entries')
  @Description(
    'The latest entries across all wallets. Optional `?limit` and `?offset`.',
  )
  Future<Map<String, dynamic>> recent(DoxRequest req, PageQuery query) async {
    (int, int) page = _page(query, recentEntriesDefaultLimit);
    List<AccountEntry> entries = await accounts.recentEntries(
      req.authUser,
      page.$1,
      page.$2,
    );
    return JsonResponse.ok(AccountEntrySerializer(entries).toJson());
  }

  @Summary('List wallet entries')
  @Description(
    'One wallet\'s entries, newest first. Optional `?limit` and `?offset`.',
  )
  Future<Map<String, dynamic>> entries(
    DoxRequest req,
    int id,
    PageQuery query,
  ) async {
    Account account = await _account(req, id);
    (int, int) page = _page(query, accountEntriesDefaultLimit);
    return JsonResponse.ok(
      AccountEntrySerializer(
        await accounts.listEntries(account, page.$1, page.$2),
      ).toJson(),
    );
  }

  @Summary('Add a wallet entry')
  @Description('Money in or out of one wallet.')
  @Response(201, null, description: 'Created')
  Future<DoxResponse> storeEntry(
    DoxRequest req,
    int id,
    CreateEntry body,
  ) async {
    Account account = await _account(req, id);
    return JsonResponse.created(
      AccountEntrySerializer(await accounts.createEntry(account, body))
          .toJson(),
    );
  }

  @Summary('Set the balance')
  @Description(
    'Set the balance to an exact value. Returns the entry that makes up the difference.',
  )
  @Response(201, null, description: 'Created')
  Future<DoxResponse> adjustBalance(
    DoxRequest req,
    int id,
    AdjustBalance body,
  ) async {
    Account account = await _account(req, id);
    return JsonResponse.created(
      AccountEntrySerializer(await accounts.adjustBalance(account, body))
          .toJson(),
    );
  }

  @Summary('Update a wallet entry')
  Future<Map<String, dynamic>> updateEntry(
    DoxRequest req,
    int id,
    int entryId,
    UpdateEntry body,
  ) async {
    Account account = await _account(req, id);
    AccountEntry entry = await accounts.findEntry(account, entryId);
    return JsonResponse.ok(
      AccountEntrySerializer(await accounts.updateEntry(entry, body)).toJson(),
    );
  }

  @Summary('Delete a wallet entry')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroyEntry(DoxRequest req, int id, int entryId) async {
    Account account = await _account(req, id);
    AccountEntry entry = await accounts.findEntry(account, entryId);
    await accounts.deleteEntry(entry);
    return JsonResponse.noContent();
  }

  @Summary('List wallet members')
  @Description('The owner and everyone the wallet is shared with.')
  Future<Map<String, dynamic>> members(DoxRequest req, int id) async {
    Account account = await _account(req, id);
    List<AccountMemberView> list = await shares.listMembers(account);
    return JsonResponse.ok(<Map<String, dynamic>>[
      for (AccountMemberView member in list) member.toJson(),
    ]);
  }

  @Summary('Share a wallet')
  @Description('Share the wallet with someone by email.')
  @Response(201, null, description: 'Created')
  Future<DoxResponse> invite(DoxRequest req, int id, Invite body) async {
    Account account = await _account(req, id);
    AccountMemberView member = await shares.invite(
      account,
      req.authUser,
      body.email,
    );
    return JsonResponse.created(member.toJson());
  }

  @Summary('Remove a wallet member')
  @Description('Stop sharing the wallet with one member.')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> removeMember(DoxRequest req, int id, int memberId) async {
    Account account = await _account(req, id);
    await shares.removeMember(account, memberId);
    return JsonResponse.noContent();
  }

  Future<Account> _account(DoxRequest req, int id) {
    return accounts.find(req.authUser, id);
  }

  /// `(limit, offset)`. Bad input falls back to the defaults.
  static (int, int) _page(PageQuery query, int defaultLimit) {
    int limit = (query.limit ?? defaultLimit).toInt().clamp(1, maxPageLimit);
    int offset = query.offset.toInt();
    return (limit, offset < 0 ? 0 : offset);
  }
}
