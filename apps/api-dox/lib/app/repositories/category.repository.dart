import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/utils/date_util.dart';
import 'package:dox_orm/dox_orm.dart';

/// The fields of a new category.
class NewCategory {
  final int groupId;
  final String name;
  final String slug;
  final String iconKey;
  final String color;

  const NewCategory({
    required this.groupId,
    required this.name,
    required this.slug,
    required this.iconKey,
    required this.color,
  });

  Map<String, dynamic> toRow(String createdAt) {
    return <String, dynamic>{
      'group_id': groupId,
      'name': name,
      'slug': slug,
      'icon_key': iconKey,
      'color': color,
      'created_at': createdAt,
    };
  }
}

@Inject()
class CategoryRepository {
  static Category _q() => Category();

  Future<Category?> findById(int id) => _q().where('id', id).getFirst();

  Future<Category?> findByGroupAndSlug(int groupId, String slug) {
    return _q().where('group_id', groupId).where('slug', slug).getFirst();
  }

  Future<List<Category>> listByGroup(int groupId) async {
    return _q().where('group_id', groupId).orderBy('name').get();
  }

  Future<Category> create(NewCategory values) async {
    return _q().create(values.toRow(DateUtil.nowSql()));
  }

  Future<void> createMany(List<NewCategory> values) async {
    String now = DateUtil.nowSql();
    await QueryBuilder.table('categories').insertMany(<Map<String, dynamic>>[
      for (NewCategory value in values) value.toRow(now),
    ]);
  }

  /// [values] uses column names. Categories have no `updated_at`.
  Future<Category> update(int id, Map<String, dynamic> values) async {
    await _q().where('id', id).update(values);
    return (await findById(id))!;
  }

  Future<void> delete(int id) async {
    await _q().where('id', id).delete();
  }
}
