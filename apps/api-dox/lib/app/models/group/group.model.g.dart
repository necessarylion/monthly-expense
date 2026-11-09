// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class GroupGenerator extends Model<Group> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'groups';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  Group query() => Group();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'name',
    'currency',
    'created_by_user_id',
    'split_enabled',
    'kind',
    'trip_start',
    'trip_days',
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

  static const _splitEnabledCast = BoolCast();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  Group fromMap(Map<String, dynamic> m) => Group()
    ..id = m['id'] as int?
    ..name = m['name'] as String
    ..currency = m['currency'] as String
    ..createdByUserId = m['created_by_user_id'] as int?
    ..splitEnabled = _splitEnabledCast.get(m['split_enabled'])
    ..kind = m['kind'] as String?
    ..tripStart = m['trip_start'] as String?
    ..tripDays = m['trip_days'] as int?
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    Group instance = this as Group;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'currency': instance.currency,
      'created_by_user_id': instance.createdByUserId,
      'split_enabled': _splitEnabledCast.set(instance.splitEnabled),
      'kind': instance.kind,
      'trip_start': instance.tripStart,
      'trip_days': instance.tripDays,
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    Group instance = i as Group;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    Group instance = this as Group;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'name':
        if (value is! String) return false;
        instance.name = value;
        return true;
      case 'currency':
        if (value is! String) return false;
        instance.currency = value;
        return true;
      case 'created_by_user_id':
        if (value is! int?) return false;
        instance.createdByUserId = value;
        return true;
      case 'split_enabled':
        if (value is! bool?) return false;
        instance.splitEnabled = value;
        return true;
      case 'kind':
        if (value is! String?) return false;
        instance.kind = value;
        return true;
      case 'trip_start':
        if (value is! String?) return false;
        instance.tripStart = value;
        return true;
      case 'trip_days':
        if (value is! int?) return false;
        instance.tripDays = value;
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
