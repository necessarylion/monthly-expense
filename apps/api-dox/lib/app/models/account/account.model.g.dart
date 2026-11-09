// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class AccountGenerator extends Model<Account> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'accounts';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  Account query() => Account();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'user_id',
    'name',
    'currency',
    'color',
    'include_in_total',
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

  static const _includeInTotalCast = BoolCast();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  Account fromMap(Map<String, dynamic> m) => Account()
    ..id = m['id'] as int?
    ..userId = m['user_id'] as int
    ..name = m['name'] as String
    ..currency = m['currency'] as String
    ..color = m['color'] as String
    ..includeInTotal = _includeInTotalCast.get(m['include_in_total']) as bool
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    Account instance = this as Account;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'currency': instance.currency,
      'color': instance.color,
      'include_in_total': _includeInTotalCast.set(instance.includeInTotal),
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    Account instance = i as Account;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    Account instance = this as Account;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'user_id':
        if (value is! int) return false;
        instance.userId = value;
        return true;
      case 'name':
        if (value is! String) return false;
        instance.name = value;
        return true;
      case 'currency':
        if (value is! String) return false;
        instance.currency = value;
        return true;
      case 'color':
        if (value is! String) return false;
        instance.color = value;
        return true;
      case 'include_in_total':
        if (value is! bool) return false;
        instance.includeInTotal = value;
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
