import 'package:api_dox/constants/mcp.dart';
import 'package:dox_core/dox_core.dart';

part 'recurring.dto.g.dart';

/// Body of POST /recurring.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateRecurring {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Positive()
  @Describe('Category ID (see list_categories).')
  final int categoryId;

  @Min(0.01)
  @Max(10000000)
  @Describe('Amount in dollars (use a decimal, e.g. 12.50).')
  final num amount;

  @Min(1)
  @Max(31)
  @Describe(
    'Day of the month it is added, 1 to 31. A short month uses its last day.',
  )
  final int dayOfMonth;

  @Trim()
  @MaxLength(500)
  @Describe(noteHint)
  final String? note;

  /// Missing or `null`: the creator's default wallet when it runs.
  @Positive()
  @Describe(
    'Wallet to pay from (see list_wallets). Leave it out to use your '
    'default wallet when it runs.',
  )
  final int? accountId;

  const CreateRecurring({
    this.groupId,
    required this.categoryId,
    required this.amount,
    required this.dayOfMonth,
    this.note,
    this.accountId,
  });

  static const DtoSchema<CreateRecurring> schema = $CreateRecurringDto;
}
