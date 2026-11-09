import 'package:api_dox/constants/mcp.dart';
import 'package:dox_core/dox_core.dart';

part 'shopping_item.dto.g.dart';

/// Body of POST /shopping-items, and the add_shopping_item tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class CreateShoppingItem {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  @Trim()
  @Length(min: 1, max: 200)
  @Describe('What to buy, e.g. "Milk".')
  final String name;

  const CreateShoppingItem({this.groupId, required this.name});

  static const DtoSchema<CreateShoppingItem> schema = $CreateShoppingItemDto;
}

/// Body of PATCH /shopping-items/{id}: rename, or tick / untick. Also the
/// update_shopping_item tool.
@Dto(keyCase: KeyCase.field, emptyStringsToNull: true)
class UpdateShoppingItem {
  /// MCP only.
  @Positive()
  @Describe(groupIdHint)
  final int? groupId;

  /// MCP only.
  @Positive()
  @Describe('Item ID (see list_shopping_items). $itemIdHint')
  final int? id;

  @Trim()
  @Length(min: 1, max: 200)
  @Describe('New name.')
  final String? name;

  @Describe('true when bought, false to put it back on the list.')
  final bool? done;

  const UpdateShoppingItem({this.groupId, this.id, this.name, this.done});

  static const DtoSchema<UpdateShoppingItem> schema = $UpdateShoppingItemDto;
}
