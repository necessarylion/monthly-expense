import 'package:api_dox/constants/limits.dart';
import 'package:api_dox/constants/mcp.dart';
import 'package:dox_core/dox_core.dart';

part 'account.dto.g.dart';

// The UI and the MCP tools call accounts "wallets".

/// Body of POST /accounts, and the create_wallet tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateAccount {
  @Trim()
  @Length(min: 1, max: 50)
  @Describe('Wallet name, e.g. "Cash" or "KBank".')
  final String name;

  @Trim()
  @Uppercase()
  @Regex(r'[A-Z]{3}', message: 'Expected a 3-letter currency code')
  @Describe(currencyHint)
  final String currency;

  @Trim()
  @HexColor()
  @Describe(colorHint)
  final String color;

  @Describe('Count this wallet in the total. Defaults to true.')
  final bool? includeInTotal;

  /// Deprecated. Old clients only; maps onto every membership's default.
  final bool? isDefault;

  const CreateAccount({
    required this.name,
    required this.currency,
    required this.color,
    this.includeInTotal,
    this.isDefault,
  });

  static const DtoSchema<CreateAccount> schema = $CreateAccountDto;
}

/// Body of PATCH /accounts/{id}, and the update_wallet tool. A missing key
/// is not changed.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class UpdateAccount {
  /// MCP only.
  @Positive()
  @Describe(accountIdHint)
  final int? accountId;

  @Trim()
  @Length(min: 1, max: 50)
  @Describe('New name.')
  final String? name;

  @Trim()
  @Uppercase()
  @Regex(r'[A-Z]{3}', message: 'Expected a 3-letter currency code')
  @Describe('New currency. $currencyHint')
  final String? currency;

  @Trim()
  @HexColor()
  @Describe('New color. $colorHint')
  final String? color;

  @Describe('Count this wallet in the total.')
  final bool? includeInTotal;

  /// Deprecated. Old clients only; maps onto every membership's default.
  final bool? isDefault;

  const UpdateAccount({
    this.accountId,
    this.name,
    this.currency,
    this.color,
    this.includeInTotal,
    this.isDefault,
  });

  static const DtoSchema<UpdateAccount> schema = $UpdateAccountDto;
}

/// Body of POST /accounts/{id}/entries, and the add_wallet_entry tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateEntry {
  /// MCP only.
  @Positive()
  @Describe(accountIdHint)
  final int? accountId;

  /// Signed: positive is money in, negative is money out.
  @Min(-10000000)
  @Max(10000000)
  @Describe(
    'Amount in dollars. Positive is money in, negative is money out. '
    'Not zero.',
  )
  final num amount;

  @DateFormatted('Y-m-d')
  @Describe(dateHint)
  final String occurredOn;

  @Trim()
  @MaxLength(500)
  @Describe(noteHint)
  final String? note;

  const CreateEntry({
    this.accountId,
    required this.amount,
    required this.occurredOn,
    this.note,
  });

  static const DtoSchema<CreateEntry> schema = $CreateEntryDto;
}

/// Body of PATCH /accounts/{id}/entries/{entryId}, and the
/// update_wallet_entry tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class UpdateEntry {
  /// MCP only.
  @Positive()
  @Describe(accountIdHint)
  final int? accountId;

  /// MCP only.
  @Positive()
  @Describe('Entry ID (see list_wallet_entries). $itemIdHint')
  final int? entryId;

  @Min(-10000000)
  @Max(10000000)
  @Describe('New signed amount in dollars. Not zero.')
  final num? amount;

  @DateFormatted('Y-m-d')
  @Describe('New date in YYYY-MM-DD.')
  final String? occurredOn;

  /// `null` (or `""`) clears the note.
  @Trim()
  @MaxLength(500)
  @Describe(clearNoteHint)
  final Maybe<String?> note;

  const UpdateEntry({
    this.accountId,
    this.entryId,
    this.amount,
    this.occurredOn,
    this.note = const Maybe<String?>.missing(),
  });

  static const DtoSchema<UpdateEntry> schema = $UpdateEntryDto;
}

/// Body of POST /accounts/transfers, and the transfer_between_wallets tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class Transfer {
  @Positive()
  @Describe('Wallet the money leaves (see list_wallets).')
  final int fromAccountId;

  @Positive()
  @Describe('Wallet the money arrives in (see list_wallets).')
  final int toAccountId;

  /// Amount leaving the source account, in its currency.
  @Min(0.01)
  @Max(10000000)
  @Describe('Amount leaving, in the currency of the source wallet.')
  final num amount;

  /// Amount arriving, in the destination's currency (cross-currency).
  @Min(0.01)
  @Max(10000000)
  @Describe(
    'Amount arriving, in the currency of the target wallet. Only for '
    'wallets in different currencies. Defaults to amount.',
  )
  final num? toAmount;

  @DateFormatted('Y-m-d')
  @Describe(dateHint)
  final String occurredOn;

  @Trim()
  @MaxLength(500)
  @Describe(noteHint)
  final String? note;

  const Transfer({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    this.toAmount,
    required this.occurredOn,
    this.note,
  });

  static const DtoSchema<Transfer> schema = $TransferDto;
}

/// Body of POST /accounts/{id}/adjustments: set the balance to an exact
/// value. The server books the difference. Also the adjust_wallet_balance
/// tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class AdjustBalance {
  /// MCP only.
  @Positive()
  @Describe(accountIdHint)
  final int? accountId;

  /// The balance afterwards. May be negative (credit cards).
  @Min(-10000000)
  @Max(10000000)
  @Describe(
    'The balance it should have, in dollars. May be negative (credit '
    'cards). The difference is booked as one entry.',
  )
  final num balance;

  @DateFormatted('Y-m-d')
  @Describe(dateHint)
  final String occurredOn;

  @Trim()
  @MaxLength(500)
  @Describe('Optional note. Defaults to "Balance adjustment".')
  final String? note;

  const AdjustBalance({
    this.accountId,
    required this.balance,
    required this.occurredOn,
    this.note,
  });

  static const DtoSchema<AdjustBalance> schema = $AdjustBalanceDto;
}

/// Body of PUT /default-account, and the set_default_wallet tool. `null`
/// clears the default.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class SetDefaultAccount {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Positive()
  @Describe(
    'Wallet that new expenses in this group are paid from (see '
    'list_wallets). Pass null to clear it.',
  )
  final Maybe<int?> accountId;

  const SetDefaultAccount({
    this.groupId,
    this.accountId = const Maybe<int?>.missing(),
  });

  void validate(DtoErrors errors) {
    if (!accountId.isPresent) {
      errors.add('accountId', 'The accountId is required');
    }
  }

  static const DtoSchema<SetDefaultAccount> schema = $SetDefaultAccountDto;
}

/// Query `?limit=&offset=` of the entry lists, and the entry list tools. A
/// bad, zero or endless number falls back to the default, like the Bun API
/// (`Number(x) || d`).
@Dto(source: Source.query, keyCase: KeyCase.field)
class PageQuery {
  /// MCP only: list_wallet_entries.
  @Positive()
  @Describe('Wallet ID, for list_wallet_entries (see list_wallets).')
  final int? accountId;

  /// Null: the default of the route.
  @OrDefault()
  @NotIn(<num>[0])
  @Describe('How many entries, newest first. At most 500.')
  final num? limit;

  @OrDefault()
  @Describe('How many entries to skip. Defaults to 0.')
  final num offset;

  const PageQuery({this.accountId, this.limit, this.offset = 0});

  static const DtoSchema<PageQuery> schema = $PageQueryDto;
}

/// Query `?days=` of GET /accounts/history. The service clamps it to
/// 1 to 365.
@Dto(source: Source.query, keyCase: KeyCase.field)
class HistoryQuery {
  @OrDefault()
  @NotIn(<num>[0])
  @Describe('How many days back, 1 to 365. Defaults to 30.')
  final num days;

  const HistoryQuery({this.days = balanceHistoryDefaultDays});

  static const DtoSchema<HistoryQuery> schema = $HistoryQueryDto;
}

/// Query `?currency=` of GET /accounts/total. The service checks the code.
@Dto(source: Source.query, keyCase: KeyCase.field)
class TotalQuery {
  @Describe('Currency of the total. $currencyHint Defaults to THB.')
  final String currency;

  const TotalQuery({this.currency = defaultTotalCurrency});

  static const DtoSchema<TotalQuery> schema = $TotalQueryDto;
}

/// Query `?base=` of GET /fx.
@Dto(source: Source.query, keyCase: KeyCase.field)
class FxQuery {
  @Describe('Base currency of the rates. $currencyHint Defaults to USD.')
  final String base;

  const FxQuery({this.base = defaultFxBase});

  static const DtoSchema<FxQuery> schema = $FxQueryDto;
}

// Ids for the MCP tools that have no body. HTTP gets them from the URL.

@Dto(keyCase: KeyCase.field)
class AccountRef {
  @Positive()
  @Describe(accountIdHint)
  final int accountId;

  const AccountRef({required this.accountId});

  static const DtoSchema<AccountRef> schema = $AccountRefDto;
}

@Dto(keyCase: KeyCase.field)
class AccountMemberRef {
  @Positive()
  @Describe(accountIdHint)
  final int accountId;

  @Positive()
  @Describe('Member ID (see list_wallet_members).')
  final int memberId;

  const AccountMemberRef({required this.accountId, required this.memberId});

  static const DtoSchema<AccountMemberRef> schema = $AccountMemberRefDto;
}

@Dto(keyCase: KeyCase.field)
class EntryRef {
  @Positive()
  @Describe(accountIdHint)
  final int accountId;

  @Positive()
  @Describe('Entry ID (see list_wallet_entries).')
  final int entryId;

  const EntryRef({required this.accountId, required this.entryId});

  static const DtoSchema<EntryRef> schema = $EntryRefDto;
}
