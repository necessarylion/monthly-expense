import 'package:api_dox/app/dtos/category/category.dto.dart';
import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/category.repository.dart';
import 'package:api_dox/app/repositories/expense.repository.dart';
import 'package:api_dox/http/http_error.dart';
import 'package:api_dox/utils/slug_util.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
class CategoryService {
  CategoryService(this.categories, this.expenses);

  final CategoryRepository categories;
  final ExpenseRepository expenses;

  Future<List<Category>> list(Group group) => categories.listByGroup(group.id!);

  /// Category id -> category, for attaching categories to expenses.
  Future<Map<int, Category>> mapForGroup(Group group) async {
    return <int, Category>{
      for (Category category in await list(group)) category.id!: category,
    };
  }

  Future<Category?> findInGroup(Group group, int? id) async {
    Category? category = id == null ? null : await categories.findById(id);
    return category != null && category.groupId == group.id ? category : null;
  }

  Future<Category> assertInGroup(Group group, int? id) async {
    Category? category = await findInGroup(group, id);
    if (category == null) throw HttpError.notFound('Category not found');
    return category;
  }

  Future<Category?> findBySlug(Group group, String slug) {
    return categories.findByGroupAndSlug(group.id!, slug);
  }

  Future<Category> create(Group group, CreateCategory fields) {
    String slug = SlugUtil.slugify(fields.name);
    if (slug.isEmpty) throw HttpError.unprocessable('Invalid category name');
    return categories.create(
      NewCategory(
        groupId: group.id!,
        name: fields.name,
        slug: slug,
        iconKey: fields.iconKey,
        color: fields.color,
      ),
    );
  }

  /// A new name also gets a new slug.
  Future<Category> update(Category category, UpdateCategory fields) {
    Map<String, dynamic> changes = <String, dynamic>{};
    if (fields.name != null) {
      String slug = SlugUtil.slugify(fields.name!);
      if (slug.isEmpty) throw HttpError.unprocessable('Invalid category name');
      changes['name'] = fields.name;
      changes['slug'] = slug;
    }
    if (fields.iconKey != null) changes['icon_key'] = fields.iconKey;
    if (fields.color != null) changes['color'] = fields.color;
    return _save(category, changes);
  }

  /// Changes fields but keeps the slug. Used by the MCP tool.
  Future<Category> updateKeepingSlug(Category category, UpdateCategory fields) {
    return _save(category, <String, dynamic>{
      if (fields.name != null) 'name': fields.name,
      if (fields.iconKey != null) 'icon_key': fields.iconKey,
      if (fields.color != null) 'color': fields.color,
    });
  }

  /// Expenses that use it stay, with no category. Returns how many changed.
  Future<int> delete(Category category) async {
    int cleared = await expenses.clearCategory(category.id!);
    await categories.delete(category.id!);
    return cleared;
  }

  Future<Category> _save(
    Category category,
    Map<String, dynamic> changes,
  ) async {
    if (changes.isEmpty) return category;
    return categories.update(category.id!, changes);
  }
}
