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
class AccountController {
  AccountController(this.accounts, this.totals, this.fxService, this.shares);

  final AccountService accounts;
  final AccountTotalService totals;
  final FxService fxService;
  final AccountShareService shares;

  Future<Map<String, dynamic>> index(DoxRequest req) async {
    List<AccountWithBalance> list = await accounts.withBalances(req.authUser);
    return JsonResponse.ok(<Map<String, dynamic>>[
      for (AccountWithBalance account in list) account.toJson(),
    ]);
  }

  Future<DoxResponse> store(DoxRequest req, CreateAccount body) async {
    AccountWithBalance account = await accounts.create(req.authUser, body);
    return JsonResponse.created(account.toJson());
  }

  Future<Map<String, dynamic>> update(
    DoxRequest req,
    int id,
    UpdateAccount body,
  ) async {
    AccountWithBalance account = await accounts.update(req.authUser, id, body);
    return JsonResponse.ok(account.toJson());
  }

  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    await accounts.delete(req.authUser, id);
    return JsonResponse.noContent();
  }

  Future<Map<String, dynamic>> defaultAccount(DoxRequest req) async {
    int? accountId = await accounts.defaultAccountId(
      req.authUser,
      req.activeGroup,
    );
    return JsonResponse.ok(<String, dynamic>{'accountId': accountId});
  }

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

  /// Rates table plus the gold ornament quote, for the rates page.
  /// `?base=THB`
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

  /// End-of-day balances per account. `?days=30` (1 to 365).
  Future<Map<String, dynamic>> history(
    DoxRequest req,
    HistoryQuery query,
  ) async {
    int days = query.days.floor().clamp(1, balanceHistoryMaxDays);
    BalanceHistory history = await accounts.balanceHistory(req.authUser, days);
    return JsonResponse.ok(history.toJson());
  }

  /// `?currency=THB`
  Future<Map<String, dynamic>> total(DoxRequest req, TotalQuery query) async {
    AccountTotal total = await totals.total(req.authUser, query.currency);
    return JsonResponse.ok(total.toJson());
  }

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

  /// Optional `?limit` and `?offset`. The defaults keep old callers
  /// working.
  Future<Map<String, dynamic>> recent(DoxRequest req, PageQuery query) async {
    (int, int) page = _page(query, recentEntriesDefaultLimit);
    List<AccountEntry> entries = await accounts.recentEntries(
      req.authUser,
      page.$1,
      page.$2,
    );
    return JsonResponse.ok(AccountEntrySerializer(entries).toJson());
  }

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

  /// Set the balance to an exact value; returns the entry that makes up
  /// the difference.
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

  Future<DoxResponse> destroyEntry(DoxRequest req, int id, int entryId) async {
    Account account = await _account(req, id);
    AccountEntry entry = await accounts.findEntry(account, entryId);
    await accounts.deleteEntry(entry);
    return JsonResponse.noContent();
  }

  /// The owner and everyone the wallet is shared with.
  Future<Map<String, dynamic>> members(DoxRequest req, int id) async {
    Account account = await _account(req, id);
    List<AccountMemberView> list = await shares.listMembers(account);
    return JsonResponse.ok(<Map<String, dynamic>>[
      for (AccountMemberView member in list) member.toJson(),
    ]);
  }

  Future<DoxResponse> invite(DoxRequest req, int id, Invite body) async {
    Account account = await _account(req, id);
    AccountMemberView member = await shares.invite(
      account,
      req.authUser,
      body.email,
    );
    return JsonResponse.created(member.toJson());
  }

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
