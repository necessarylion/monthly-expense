// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class CategoryGenerator extends Model<Category> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'categories';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  Category query() => Category();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'group_id',
    'name',
    'slug',
    'icon_key',
    'color',
    'budget_cents',
    'created_at',
  ];

  @override
  List<String> get preloadList => const <String>[];

  @override
  Map<String, Function> get relationsResultMatcher =>
      const <String, Function>{};

  @override
  Map<String, Function> get relationsQueryMatcher => const <String, Function>{};

  static const _createdAtTextCast = TimestampText();

  @override
  Category fromMap(Map<String, dynamic> m) => Category()
    ..id = m['id'] as int?
    ..groupId = m['group_id'] as int
    ..name = m['name'] as String
    ..slug = m['slug'] as String
    ..iconKey = m['icon_key'] as String
    ..color = m['color'] as String
    ..budgetCents = m['budget_cents'] as int?
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    Category instance = this as Category;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'name': instance.name,
      'slug': instance.slug,
      'icon_key': instance.iconKey,
      'color': instance.color,
      'budget_cents': instance.budgetCents,
      'created_at': _createdAtTextCast.set(instance.createdAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    Category instance = i as Category;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    Category instance = this as Category;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'group_id':
        if (value is! int) return false;
        instance.groupId = value;
        return true;
      case 'name':
        if (value is! String) return false;
        instance.name = value;
        return true;
      case 'slug':
        if (value is! String) return false;
        instance.slug = value;
        return true;
      case 'icon_key':
        if (value is! String) return false;
        instance.iconKey = value;
        return true;
      case 'color':
        if (value is! String) return false;
        instance.color = value;
        return true;
      case 'budget_cents':
        if (value is! int?) return false;
        instance.budgetCents = value;
        return true;
      case 'created_at':
        if (value is! String) return false;
        instance.createdAtText = value;
        return true;
    }
    return false;
  }

  @override
  bool $copyColumnsFrom(Model<Category> other) {
    Category o = other as Category;
    (this as Category)
      ..id = o.id
      ..groupId = o.groupId
      ..name = o.name
      ..slug = o.slug
      ..iconKey = o.iconKey
      ..color = o.color
      ..budgetCents = o.budgetCents
      ..createdAtText = o.createdAtText;
    return true;
  }
}
