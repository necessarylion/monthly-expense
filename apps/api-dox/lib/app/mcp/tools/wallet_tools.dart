import 'package:api_dox/app/dtos/account/account.dto.dart';
import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/serializers/account_entry.serializer.dart';
import 'package:api_dox/app/services/account.service.dart';
import 'package:api_dox/app/services/account_share.service.dart';
import 'package:api_dox/app/services/fx/account_total.service.dart';
import 'package:api_dox/app/services/fx/fx.service.dart';
import 'package:api_dox/app/services/fx/gold_quote_provider.dart';
import 'package:api_dox/app/mcp/app_tool.dart';
import 'package:api_dox/constants/limits.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

// Wallets are `accounts` in the code and the HTTP API. They belong to the
// user (and who they share them with), not to a group.

/// `(limit, offset)` of [query]. The same rules as the HTTP routes.
(int, int) _page(PageQuery query, int defaultLimit) {
  int limit = (query.limit ?? defaultLimit).toInt().clamp(1, maxPageLimit);
  int offset = query.offset.toInt();
  return (limit, offset < 0 ? 0 : offset);
}

@Inject()
class ListWalletsTool extends AppTool<NoInput> {
  ListWalletsTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'list_wallets';

  @override
  String get description =>
      'List the wallets of the MCP user (own and shared), with their '
      'balance in cents.';

  @override
  DtoSchema<NoInput> get dto => NoInput.schema;

  @override
  Future<McpToolResult> run(NoInput input, User user) async {
    List<AccountWithBalance> list = await accounts.withBalances(user);
    return AppTool.json(<String, dynamic>{
      'wallets': <Map<String, dynamic>>[
        for (AccountWithBalance account in list) account.toJson(),
      ],
    });
  }
}

@Inject()
class CreateWalletTool extends AppTool<CreateAccount> {
  CreateWalletTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'create_wallet';

  @override
  String get description => 'Create a wallet for the MCP user.';

  @override
  DtoSchema<CreateAccount> get dto => CreateAccount.schema;

  @override
  Future<McpToolResult> run(CreateAccount input, User user) async {
    AccountWithBalance account = await accounts.create(user, input);
    return AppTool.json(<String, dynamic>{'wallet': account.toJson()});
  }
}

@Inject()
class UpdateWalletTool extends AppTool<UpdateAccount> {
  UpdateWalletTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'update_wallet';

  @override
  String get description =>
      'Update a wallet. Only include the fields you want to change.';

  @override
  DtoSchema<UpdateAccount> get dto => UpdateAccount.schema;

  @override
  Future<McpToolResult> run(UpdateAccount input, User user) async {
    AccountWithBalance account = await accounts.update(
      user,
      AppTool.need(input.accountId, 'accountId'),
      input,
    );
    return AppTool.json(<String, dynamic>{'wallet': account.toJson()});
  }
}

@Inject()
class DeleteWalletTool extends AppTool<AccountRef> {
  DeleteWalletTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'delete_wallet';

  @override
  String get description => 'Delete a wallet and all of its entries.';

  @override
  DtoSchema<AccountRef> get dto => AccountRef.schema;

  @override
  Future<McpToolResult> run(AccountRef input, User user) async {
    await accounts.delete(user, input.accountId);
    return AppTool.text('Deleted wallet ${input.accountId}.');
  }
}

@Inject()
class WalletTotalTool extends AppTool<TotalQuery> {
  WalletTotalTool(super.groups, this.totals);

  final AccountTotalService totals;

  @override
  String get name => 'wallet_total';

  @override
  String get description =>
      'The total of the wallets marked "include in total", converted to one '
      'currency. approx is true when a wallet is in another currency. '
      'totalCents is in cents.';

  @override
  DtoSchema<TotalQuery> get dto => TotalQuery.schema;

  @override
  Future<McpToolResult> run(TotalQuery input, User user) async {
    AccountTotal total = await totals.total(user, input.currency);
    return AppTool.json(total.toJson());
  }
}

@Inject()
class WalletHistoryTool extends AppTool<HistoryQuery> {
  WalletHistoryTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'wallet_history';

  @override
  String get description =>
      'End-of-day balances (in cents) of each wallet for the last days.';

  @override
  DtoSchema<HistoryQuery> get dto => HistoryQuery.schema;

  @override
  Future<McpToolResult> run(HistoryQuery input, User user) async {
    int days = input.days.floor().clamp(1, balanceHistoryMaxDays);
    BalanceHistory history = await accounts.balanceHistory(user, days);
    return AppTool.json(history.toJson());
  }
}

@Inject()
class TransferBetweenWalletsTool extends AppTool<Transfer> {
  TransferBetweenWalletsTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'transfer_between_wallets';

  @override
  String get description =>
      'Move money from one wallet to another. Books a money-out entry on '
      'the source and a money-in entry on the target.';

  @override
  DtoSchema<Transfer> get dto => Transfer.schema;

  @override
  Future<McpToolResult> run(Transfer input, User user) async {
    (AccountEntry, AccountEntry) result = await accounts.transfer(user, input);
    return AppTool.json(<String, dynamic>{
      'out': AccountEntrySerializer(result.$1).toJson(),
      'in': AccountEntrySerializer(result.$2).toJson(),
    });
  }
}

@Inject()
class ListWalletMembersTool extends AppTool<AccountRef> {
  ListWalletMembersTool(super.groups, this.accounts, this.shares);

  final AccountService accounts;
  final AccountShareService shares;

  @override
  String get name => 'list_wallet_members';

  @override
  String get description =>
      'The owner of a wallet and everyone it is shared with (or invited).';

  @override
  DtoSchema<AccountRef> get dto => AccountRef.schema;

  @override
  Future<McpToolResult> run(AccountRef input, User user) async {
    Account account = await accounts.find(user, input.accountId);
    List<AccountMemberView> list = await shares.listMembers(account);
    return AppTool.json(<String, dynamic>{
      'members': <Map<String, dynamic>>[
        for (AccountMemberView member in list) member.toJson(),
      ],
    });
  }
}

@Inject()
class InviteWalletMemberTool extends AppTool<Invite> {
  InviteWalletMemberTool(super.groups, this.accounts, this.shares);

  final AccountService accounts;
  final AccountShareService shares;

  @override
  String get name => 'invite_wallet_member';

  @override
  String get description =>
      'Share a wallet with a person by their Gmail address. Needs accountId.';

  @override
  DtoSchema<Invite> get dto => Invite.schema;

  @override
  Future<McpToolResult> run(Invite input, User user) async {
    Account account = await accounts.find(
      user,
      AppTool.need(input.accountId, 'accountId'),
    );
    AccountMemberView member = await shares.invite(account, user, input.email);
    return AppTool.json(<String, dynamic>{'member': member.toJson()});
  }
}

@Inject()
class RemoveWalletMemberTool extends AppTool<AccountMemberRef> {
  RemoveWalletMemberTool(super.groups, this.accounts, this.shares);

  final AccountService accounts;
  final AccountShareService shares;

  @override
  String get name => 'remove_wallet_member';

  @override
  String get description =>
      'Stop sharing a wallet with a member (or cancel an invite).';

  @override
  DtoSchema<AccountMemberRef> get dto => AccountMemberRef.schema;

  @override
  Future<McpToolResult> run(AccountMemberRef input, User user) async {
    Account account = await accounts.find(user, input.accountId);
    await shares.removeMember(account, input.memberId);
    return AppTool.text(
      'Removed member ${input.memberId} from wallet "${account.name}".',
    );
  }
}

@Inject()
class ListWalletEntriesTool extends AppTool<PageQuery> {
  ListWalletEntriesTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'list_wallet_entries';

  @override
  String get description =>
      'The entries (money in and out) of one wallet, newest first. Needs '
      'accountId. amountCents is in cents.';

  @override
  DtoSchema<PageQuery> get dto => PageQuery.schema;

  @override
  Future<McpToolResult> run(PageQuery input, User user) async {
    Account account = await accounts.find(
      user,
      AppTool.need(input.accountId, 'accountId'),
    );
    (int, int) page = _page(input, accountEntriesDefaultLimit);
    List<AccountEntry> entries = await accounts.listEntries(
      account,
      page.$1,
      page.$2,
    );
    return AppTool.json(<String, dynamic>{
      'entries': AccountEntrySerializer(entries).toJson(),
    });
  }
}

@Inject()
class RecentWalletEntriesTool extends AppTool<PageQuery> {
  RecentWalletEntriesTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'recent_wallet_entries';

  @override
  String get description =>
      'The latest entries across all wallets of the MCP user, newest first. '
      'Leave out accountId. amountCents is in cents.';

  @override
  DtoSchema<PageQuery> get dto => PageQuery.schema;

  @override
  Future<McpToolResult> run(PageQuery input, User user) async {
    (int, int) page = _page(input, recentEntriesDefaultLimit);
    List<AccountEntry> entries = await accounts.recentEntries(
      user,
      page.$1,
      page.$2,
    );
    return AppTool.json(<String, dynamic>{
      'entries': AccountEntrySerializer(entries).toJson(),
    });
  }
}

@Inject()
class AddWalletEntryTool extends AppTool<CreateEntry> {
  AddWalletEntryTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'add_wallet_entry';

  @override
  String get description =>
      'Book money in (positive amount) or out (negative amount) on a wallet. '
      'For a spend in a group, use add_expense instead.';

  @override
  DtoSchema<CreateEntry> get dto => CreateEntry.schema;

  @override
  Future<McpToolResult> run(CreateEntry input, User user) async {
    Account account = await accounts.find(
      user,
      AppTool.need(input.accountId, 'accountId'),
    );
    AccountEntry entry = await accounts.createEntry(account, input);
    return AppTool.json(<String, dynamic>{
      'entry': AccountEntrySerializer(entry).toJson(),
    });
  }
}

@Inject()
class UpdateWalletEntryTool extends AppTool<UpdateEntry> {
  UpdateWalletEntryTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'update_wallet_entry';

  @override
  String get description =>
      'Update a wallet entry. Only include the fields you want to change.';

  @override
  DtoSchema<UpdateEntry> get dto => UpdateEntry.schema;

  @override
  Future<McpToolResult> run(UpdateEntry input, User user) async {
    Account account = await accounts.find(
      user,
      AppTool.need(input.accountId, 'accountId'),
    );
    AccountEntry entry = await accounts.findEntry(
      account,
      AppTool.need(input.entryId, 'entryId'),
    );
    AccountEntry updated = await accounts.updateEntry(entry, input);
    return AppTool.json(<String, dynamic>{
      'entry': AccountEntrySerializer(updated).toJson(),
    });
  }
}

@Inject()
class DeleteWalletEntryTool extends AppTool<EntryRef> {
  DeleteWalletEntryTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'delete_wallet_entry';

  @override
  String get description =>
      'Delete a wallet entry. An entry made by an expense goes away with the '
      'expense; prefer delete_expense for those.';

  @override
  DtoSchema<EntryRef> get dto => EntryRef.schema;

  @override
  Future<McpToolResult> run(EntryRef input, User user) async {
    Account account = await accounts.find(user, input.accountId);
    AccountEntry entry = await accounts.findEntry(account, input.entryId);
    await accounts.deleteEntry(entry);
    return AppTool.text('Deleted entry ${input.entryId}.');
  }
}

@Inject()
class AdjustWalletBalanceTool extends AppTool<AdjustBalance> {
  AdjustWalletBalanceTool(super.groups, this.accounts);

  final AccountService accounts;

  @override
  String get name => 'adjust_wallet_balance';

  @override
  String get description =>
      'Set a wallet to an exact balance. Books one entry for the difference '
      'and returns it.';

  @override
  DtoSchema<AdjustBalance> get dto => AdjustBalance.schema;

  @override
  Future<McpToolResult> run(AdjustBalance input, User user) async {
    Account account = await accounts.find(
      user,
      AppTool.need(input.accountId, 'accountId'),
    );
    AccountEntry entry = await accounts.adjustBalance(account, input);
    return AppTool.json(<String, dynamic>{
      'entry': AccountEntrySerializer(entry).toJson(),
    });
  }
}

@Inject()
class ExchangeRatesTool extends AppTool<FxQuery> {
  ExchangeRatesTool(super.groups, this.fx);

  final FxService fx;

  @override
  String get name => 'exchange_rates';

  @override
  String get description =>
      'Exchange rates for a base currency, plus the gold ornament price '
      '(gold is null when the quote is not available).';

  @override
  DtoSchema<FxQuery> get dto => FxQuery.schema;

  @override
  Future<McpToolResult> run(FxQuery input, User user) async {
    RatesResult table = await fx.ratesFor(input.base);
    GoldQuote? gold;
    try {
      gold = await fx.goldQuote();
    } catch (_) {
      // the rates work without gold, like GET /fx
    }
    return AppTool.json(<String, dynamic>{
      ...table.toJson(),
      'gold': gold?.toJson(),
    });
  }
}
