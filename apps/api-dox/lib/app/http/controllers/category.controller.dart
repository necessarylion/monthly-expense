import 'package:api_dox/app/dtos/category/category.dto.dart';
import 'package:api_dox/app/serializers/category.serializer.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/http/json_response.dart';
import 'package:api_dox/http/request_context.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
class CategoryController {
  CategoryController(this.categories);

  final CategoryService categories;

  Future<Map<String, dynamic>> index(DoxRequest req) async {
    List<Category> list = await categories.list(req.activeGroup);
    return JsonResponse.ok(CategorySerializer(list).toJson());
  }

  Future<DoxResponse> store(DoxRequest req, CreateCategory body) async {
    Category category = await categories.create(req.activeGroup, body);
    return JsonResponse.created(CategorySerializer(category).toJson());
  }

  Future<Map<String, dynamic>> update(
    DoxRequest req,
    int id,
    UpdateCategory body,
  ) async {
    Category category = await categories.assertInGroup(req.activeGroup, id);
    return JsonResponse.ok(
      CategorySerializer(await categories.update(category, body)).toJson(),
    );
  }

  Future<DoxResponse> destroy(DoxRequest req, int id) async {
    Category category = await categories.assertInGroup(req.activeGroup, id);
    await categories.delete(category);
    return JsonResponse.noContent();
  }
}
