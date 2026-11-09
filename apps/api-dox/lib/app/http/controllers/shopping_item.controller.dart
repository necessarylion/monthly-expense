import 'package:api_dox/app/dtos/shopping_item/shopping_item.dto.dart';
import 'package:api_dox/app/serializers/shopping_item.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/shopping_list.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
@Tags(<String>['Shopping list'])
class ShoppingItemController {
  ShoppingItemController(this.list);

  final ShoppingListService list;

  @Summary('List shopping items')
  @Description('Still to buy first (oldest first), then bought (latest first).')
  Future<Map<String, dynamic>> index(DoxRequest req) async {
    List<ShoppingItem> items = await list.list(req.activeGroup);
    return JsonResponse.ok(ShoppingItemSerializer(items).toJson());
  }

  @Summary('Add a shopping item')
  @Response(201, null, description: 'Created')
  Future<DoxResponse> store(DoxRequest req, CreateShoppingItem body) async {
    ShoppingItem item = await list.create(
      req.activeGroup,
      req.authUser,
      body.name,
    );
    return JsonResponse.created(ShoppingItemSerializer(item).toJson());
  }

  @Summary('Update a shopping item')
  @Description('Rename an item, or tick / untick it.')
  Future<Map<String, dynamic>> update(
    DoxRequest req,
    int id,
    UpdateShoppingItem body,
  ) async {
    ShoppingItem item = await list.assertInGroup(req.activeGroup, id);
    return JsonResponse.ok(
      ShoppingItemSerializer(await list.update(item, body)).toJson(),
    );
  }

  @Summary('Delete a shopping item')
  @Response(204, null, description: 'Done, no body')
  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    ShoppingItem item = await list.assertInGroup(req.activeGroup, id);
    await list.delete(item);
    return JsonResponse.noContent();
  }

  @Summary('Clear bought items')
  Future<Map<String, dynamic>> clearDone(DoxRequest req) async {
    int deleted = await list.clearDone(req.activeGroup);
    return JsonResponse.ok(<String, dynamic>{'deleted': deleted});
  }
}
