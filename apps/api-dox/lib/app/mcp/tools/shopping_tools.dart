import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/dtos/shopping_item/shopping_item.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/shopping_list.service.dart';
import 'package:api_dox/app/mcp/app_tool.dart';
import 'package:api_dox/app/serializers/shopping_item.serializer.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

@Inject()
class ListShoppingItemsTool extends AppTool<GroupRef> {
  ListShoppingItemsTool(super.groups, this.list);

  final ShoppingListService list;

  @override
  String get name => 'list_shopping_items';

  @override
  String get description =>
      "The group's shared shopping list. Items still to buy come first "
      '(oldest first), then bought items (done=true, latest first).';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    return AppTool.json(<String, dynamic>{
      'items': ShoppingItemSerializer(await list.list(group)).toJson(),
    });
  }
}

@Inject()
class AddShoppingItemTool extends AppTool<CreateShoppingItem> {
  AddShoppingItemTool(super.groups, this.list);

  final ShoppingListService list;

  @override
  String get name => 'add_shopping_item';

  @override
  String get description => "Add an item to the group's shopping list.";

  @override
  DtoSchema<CreateShoppingItem> get dto => CreateShoppingItem.schema;

  @override
  Future<McpToolResult> run(CreateShoppingItem input, User user) async {
    Group group = await groupOf(user, input.groupId);
    ShoppingItem item = await list.create(group, user, input.name);
    return AppTool.json(<String, dynamic>{
      'item': ShoppingItemSerializer(item).toJson(),
    });
  }
}

@Inject()
class UpdateShoppingItemTool extends AppTool<UpdateShoppingItem> {
  UpdateShoppingItemTool(super.groups, this.list);

  final ShoppingListService list;

  @override
  String get name => 'update_shopping_item';

  @override
  String get description =>
      'Rename a shopping list item, or tick it off (done=true) or put it '
      'back (done=false).';

  @override
  DtoSchema<UpdateShoppingItem> get dto => UpdateShoppingItem.schema;

  @override
  Future<McpToolResult> run(UpdateShoppingItem input, User user) async {
    Group group = await groupOf(user, input.groupId);
    int id = AppTool.need(input.id, 'id');
    ShoppingItem item = await list.assertInGroup(group, id);
    if (input.name == null && input.done == null) {
      return AppTool.text('No changes provided for item $id.');
    }
    ShoppingItem updated = await list.update(item, input);
    return AppTool.json(<String, dynamic>{
      'item': ShoppingItemSerializer(updated).toJson(),
    });
  }
}

@Inject()
class DeleteShoppingItemTool extends AppTool<GroupItemRef> {
  DeleteShoppingItemTool(super.groups, this.list);

  final ShoppingListService list;

  @override
  String get name => 'delete_shopping_item';

  @override
  String get description =>
      'Delete an item from the shopping list. id is the item ID (see '
      'list_shopping_items).';

  @override
  DtoSchema<GroupItemRef> get dto => GroupItemRef.schema;

  @override
  Future<McpToolResult> run(GroupItemRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    ShoppingItem item = await list.assertInGroup(group, input.id);
    await list.delete(item);
    return AppTool.text('Deleted item ${input.id} (${item.name}).');
  }
}

@Inject()
class ClearDoneShoppingItemsTool extends AppTool<GroupRef> {
  ClearDoneShoppingItemsTool(super.groups, this.list);

  final ShoppingListService list;

  @override
  String get name => 'clear_done_shopping_items';

  @override
  String get description =>
      'Delete every bought (done) item from the shopping list.';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    int deleted = await list.clearDone(group);
    return AppTool.json(<String, dynamic>{'deleted': deleted});
  }
}
