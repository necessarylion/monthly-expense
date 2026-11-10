import 'package:dox_core/dox_core.dart';

part 'quick_add_pick.dto.g.dart';

/// Claude's answer for the quick-add list. Its JSON Schema is also sent
/// to Claude as the answer format, so keep it plain: Claude's structured
/// output does not take number limits like `@Min`. `strict` adds
/// `additionalProperties: false`, which Claude needs.
@Dto(keyCase: KeyCase.field, strict: true)
class QuickAddPick {
  // The doc line below is the description Claude reads. The picker checks
  // that each id is in the candidate list.
  /// The ids of the rows to show, taken from the list you got.
  final List<int> ids;

  const QuickAddPick({required this.ids});

  static const DtoSchema<QuickAddPick> schema = $QuickAddPickDto;
}
