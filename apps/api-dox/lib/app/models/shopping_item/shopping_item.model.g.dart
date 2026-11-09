// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class ShoppingItemGenerator extends Model<ShoppingItem> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'shopping_items';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  ShoppingItem query() => ShoppingItem();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'group_id',
    'name',
    'done_at',
    'created_by_user_id',
    'created_at',
    'updated_at',
  ];

  @override
  List<String> get preloadList => const <String>[];

  @override
  Map<String, Function> get relationsResultMatcher =>
      const <String, Function>{};

  @override
  Map<String, Function> get relationsQueryMatcher => const <String, Function>{};

  static const _doneAtCast = TimestampText();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  ShoppingItem fromMap(Map<String, dynamic> m) => ShoppingItem()
    ..id = m['id'] as int?
    ..groupId = m['group_id'] as int
    ..name = m['name'] as String
    ..doneAt = _doneAtCast.get(m['done_at'])
    ..createdByUserId = m['created_by_user_id'] as int?
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    ShoppingItem instance = this as ShoppingItem;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'name': instance.name,
      'done_at': _doneAtCast.set(instance.doneAt),
      'created_by_user_id': instance.createdByUserId,
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    ShoppingItem instance = i as ShoppingItem;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    ShoppingItem instance = this as ShoppingItem;
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
      case 'done_at':
        if (value is! String?) return false;
        instance.doneAt = value;
        return true;
      case 'created_by_user_id':
        if (value is! int?) return false;
        instance.createdByUserId = value;
        return true;
      case 'created_at':
        if (value is! String) return false;
        instance.createdAtText = value;
        return true;
      case 'updated_at':
        if (value is! String) return false;
        instance.updatedAtText = value;
        return true;
    }
    return false;
  }
}
