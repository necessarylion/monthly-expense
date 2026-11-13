import 'package:api_dox/app/dtos/expense/expense.dto.dart';
import 'package:dox_core/dox_core.dart';

part 'smart_add.dto.g.dart';

/// Body of POST /smart-add: what the user typed, like "lunch 5000, taxi 3000".
@Dto(keyCase: KeyCase.field)
class SmartAddText {
  @Trim()
  @Length(min: 1, max: 500)
  final String text;

  /// The user's today, so a late-night add lands on their day.
  @DateFormatted('Y-m-d')
  final String today;

  @In(<Object>['en', 'my'])
  final String? lang;

  const SmartAddText({required this.text, required this.today, this.lang});

  static const DtoSchema<SmartAddText> schema = $SmartAddTextDto;
}

/// Body of POST /smart-add/actions: the A2UI action of a tapped Save button.
/// Its `context` has the keys of POST /expenses, so it gets the same checks.
@Dto(keyCase: KeyCase.field)
class SmartAddAction {
  @In(<Object>['save_expense'])
  final String name;

  @Regex(r'^save_[0-9]{1,2}$', message: 'Unknown button')
  final String sourceComponentId;

  final CreateExpense context;

  @In(<Object>['en', 'my'])
  final String? lang;

  const SmartAddAction({
    required this.name,
    required this.sourceComponentId,
    required this.context,
    this.lang,
  });

  static const DtoSchema<SmartAddAction> schema = $SmartAddActionDto;
}
