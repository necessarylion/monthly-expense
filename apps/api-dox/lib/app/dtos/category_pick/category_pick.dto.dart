import 'package:dox_core/dox_core.dart';

part 'category_pick.dto.g.dart';

/// Claude's answer when it sorts an expense into a category. Its JSON
/// Schema is also sent to Claude as the answer format, so keep it plain
/// (no number limits). `strict` adds `additionalProperties: false`, which
/// Claude needs.
@Dto(keyCase: KeyCase.field, strict: true)
class CategoryPick {
  // The doc line below is the description Claude reads. The categorizer
  // checks that the id is one of the group's categories.
  /// The id of the category the expense belongs to, from the list you got.
  final int categoryId;

  const CategoryPick({required this.categoryId});

  static const DtoSchema<CategoryPick> schema = $CategoryPickDto;
}
