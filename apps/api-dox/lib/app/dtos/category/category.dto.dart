import 'package:api_dox/constants/mcp.dart';
import 'package:dox_core/dox_core.dart';

part 'category.dto.g.dart';

/// Body of POST /categories, and the create_category tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateCategory {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Trim()
  @Length(min: 1, max: 50)
  @Describe('Display name, e.g. "Coffee".')
  final String name;

  @Trim()
  @Length(min: 1, max: 50)
  @Describe(iconKeyHint)
  final String iconKey;

  @Trim()
  @HexColor()
  @Describe(colorHint)
  final String color;

  const CreateCategory({
    this.groupId,
    required this.name,
    required this.iconKey,
    required this.color,
  });

  static const DtoSchema<CreateCategory> schema = $CreateCategoryDto;
}

/// Body of PATCH /categories/{id}, and the update_category tool. A missing
/// key is not changed.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class UpdateCategory {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  /// MCP only.
  @Positive()
  @Describe('Category ID (see list_categories). $itemIdHint')
  final int? id;

  @Trim()
  @Length(min: 1, max: 50)
  @Describe('New display name.')
  final String? name;

  @Trim()
  @Length(min: 1, max: 50)
  @Describe('New icon key. $iconKeyHint')
  final String? iconKey;

  @Trim()
  @HexColor()
  @Describe('New color. $colorHint')
  final String? color;

  /// Monthly budget in dollars. `null` clears it.
  @Min(0)
  @Max(1000000000)
  @Describe(
    'Monthly budget for this category in dollars. Pass null to clear it.',
  )
  final Maybe<num?> budget;

  const UpdateCategory({
    this.groupId,
    this.id,
    this.name,
    this.iconKey,
    this.color,
    this.budget = const Maybe<num?>.missing(),
  });

  static const DtoSchema<UpdateCategory> schema = $UpdateCategoryDto;
}
