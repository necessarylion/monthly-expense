import 'package:api_dox/app/dtos/category/category.dto.dart';
import 'package:api_dox/app/dtos/group/group.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/services/category.service.dart';
import 'package:api_dox/app/mcp/app_tool.dart';
import 'package:api_dox/app/serializers/category.serializer.dart';
import 'package:api_dox/utils/slug_util.dart';
import 'package:dox_core/dox_core.dart';
import 'package:dox_mcp/dox_mcp.dart';

@Inject()
class ListCategoriesTool extends AppTool<GroupRef> {
  ListCategoriesTool(super.groups, this.categories);

  final CategoryService categories;

  @override
  String get name => 'list_categories';

  @override
  String get description => 'List all categories in the given group.';

  @override
  DtoSchema<GroupRef> get dto => GroupRef.schema;

  @override
  Future<McpToolResult> run(GroupRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    return AppTool.json(<String, dynamic>{
      'categories': CategorySerializer(await categories.list(group)).toJson(),
    });
  }
}

@Inject()
class CreateCategoryTool extends AppTool<CreateCategory> {
  CreateCategoryTool(super.groups, this.categories);

  final CategoryService categories;

  @override
  String get name => 'create_category';

  @override
  String get description => 'Create a new category in the given group.';

  @override
  DtoSchema<CreateCategory> get dto => CreateCategory.schema;

  @override
  Future<McpToolResult> run(CreateCategory input, User user) async {
    Group group = await groupOf(user, input.groupId);
    String slug = SlugUtil.slugify(input.name);
    if (slug.isEmpty) {
      return AppTool.error('Invalid category name "${input.name}".');
    }

    Category? existing = await categories.findBySlug(group, slug);
    if (existing != null) {
      return AppTool.error(
        'Category "${existing.name}" (slug ${existing.slug}) already exists '
        'in group "${group.name}" with id ${existing.id}.',
      );
    }
    Category category = await categories.create(group, input);
    return AppTool.json(<String, dynamic>{
      'category': CategorySerializer(category).toJson(),
    });
  }
}

@Inject()
class UpdateCategoryTool extends AppTool<UpdateCategory> {
  UpdateCategoryTool(super.groups, this.categories);

  final CategoryService categories;

  @override
  String get name => 'update_category';

  @override
  String get description =>
      'Update a category in the given group. Only include the fields you '
      'want to change. The slug is not changed on rename.';

  @override
  DtoSchema<UpdateCategory> get dto => UpdateCategory.schema;

  @override
  Future<McpToolResult> run(UpdateCategory input, User user) async {
    Group group = await groupOf(user, input.groupId);
    int id = AppTool.need(input.id, 'id');
    Category? category = await categories.findInGroup(group, id);
    if (category == null) {
      return AppTool.error('Category $id not found in group "${group.name}".');
    }
    if (input.name == null && input.iconKey == null && input.color == null) {
      return AppTool.text('No changes provided for category $id.');
    }

    Category updated = await categories.updateKeepingSlug(category, input);
    return AppTool.json(<String, dynamic>{
      'category': CategorySerializer(updated).toJson(),
    });
  }
}

@Inject()
class DeleteCategoryTool extends AppTool<GroupItemRef> {
  DeleteCategoryTool(super.groups, this.categories);

  final CategoryService categories;

  @override
  String get name => 'delete_category';

  @override
  String get description =>
      'Delete a category in the given group. Any expenses currently using it '
      'will have their category cleared (not deleted). id is the category '
      'ID (see list_categories).';

  @override
  DtoSchema<GroupItemRef> get dto => GroupItemRef.schema;

  @override
  Future<McpToolResult> run(GroupItemRef input, User user) async {
    Group group = await groupOf(user, input.groupId);
    Category? category = await categories.findInGroup(group, input.id);
    if (category == null) {
      return AppTool.error(
        'Category ${input.id} not found in group "${group.name}".',
      );
    }
    int cleared = await categories.delete(category);
    return AppTool.text(
      'Deleted category ${category.id} (${category.name}). Cleared category '
      'on $cleared expense${cleared == 1 ? '' : 's'}.',
    );
  }
}
