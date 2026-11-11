import 'package:api_dox/constants/mcp.dart';
import 'package:dox_core/dox_core.dart';

part 'expense.dto.g.dart';

/// Body of POST /expenses, and the add_expense tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateExpense {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  /// Missing: the note's category is found for you (same note as before,
  /// else AI). Then the note is required.
  @Positive()
  @Describe(
    'Category ID (see list_categories). Leave it out to have it picked '
    'from the note; the note is then required.',
  )
  final int? categoryId;

  @Min(0.01)
  @Max(10000000)
  @Describe('Amount in dollars (use a decimal, e.g. 12.50).')
  final num amount;

  @DateFormatted('Y-m-d')
  @Describe('Date the expense occurred, in YYYY-MM-DD.')
  final String occurredOn;

  @Trim()
  @MaxLength(500)
  @Describe('What the money was for. Required when categoryId is left out.')
  final String? note;

  /// Account for the money-out entry. Missing: the member's default.
  /// `null`: no entry.
  @Positive()
  @Describe(
    'Wallet to pay from (see list_wallets). Leave it out to use your '
    'default wallet of the group. Pass null to record no wallet entry.',
  )
  final Maybe<int?> accountId;

  const CreateExpense({
    this.groupId,
    this.categoryId,
    required this.amount,
    required this.occurredOn,
    this.note,
    this.accountId = const Maybe<int?>.missing(),
  });

  static const DtoSchema<CreateExpense> schema = $CreateExpenseDto;
}

/// Body of PATCH /expenses/{id}, and the update_expense tool. A missing
/// key is not changed.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class UpdateExpense {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  /// MCP only.
  @Positive()
  @Describe('Expense ID (see list_expenses). $itemIdHint')
  final int? id;

  @Positive()
  @Describe('New category ID (see list_categories).')
  final int? categoryId;

  @Min(0.01)
  @Max(10000000)
  @Describe('New amount in dollars.')
  final num? amount;

  @DateFormatted('Y-m-d')
  @Describe('New date in YYYY-MM-DD.')
  final String? occurredOn;

  /// `null` (or `""`) clears the note.
  @Trim()
  @MaxLength(500)
  @Describe(clearNoteHint)
  final Maybe<String?> note;

  const UpdateExpense({
    this.groupId,
    this.id,
    this.categoryId,
    this.amount,
    this.occurredOn,
    this.note = const Maybe<String?>.missing(),
  });

  static const DtoSchema<UpdateExpense> schema = $UpdateExpenseDto;
}

/// Query of GET /expenses and GET /summary, and the month tools. No
/// month: this month.
@Dto(source: Source.query, keyCase: KeyCase.field)
class MonthQuery {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @DateFormatted('Y-m')
  @Describe(monthHint)
  final String? month;

  const MonthQuery({this.groupId, this.month});

  static const DtoSchema<MonthQuery> schema = $MonthQueryDto;
}

/// Query of GET /expenses/search. Every
/// filter is optional; together they must all match.
@Dto(source: Source.query, keyCase: KeyCase.field, emptyStringsToNull: true)
class SearchQuery {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Trim()
  @MaxLength(100)
  @Describe('Text to find in the note or the category name.')
  final String? q;

  @Positive()
  @Describe('Only this category ID (see list_categories).')
  final int? categoryId;

  @DateFormatted('Y-m-d')
  @Describe('First date, YYYY-MM-DD.')
  final String? from;

  @DateFormatted('Y-m-d')
  @Describe('Last date, YYYY-MM-DD.')
  final String? to;

  const SearchQuery({
    this.groupId,
    this.q,
    this.categoryId,
    this.from,
    this.to,
  });

  static const DtoSchema<SearchQuery> schema = $SearchQueryDto;
}

/// Query of GET /summary/year. No year: this
/// year.
@Dto(source: Source.query, keyCase: KeyCase.field)
class YearQuery {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Min(2000)
  @Max(2100)
  @Describe('Year, like 2026. Defaults to this year.')
  final int? year;

  const YearQuery({this.groupId, this.year});

  static const DtoSchema<YearQuery> schema = $YearQueryDto;
}
