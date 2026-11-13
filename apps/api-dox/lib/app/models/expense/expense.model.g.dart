// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class ExpenseGenerator extends Model<Expense> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'expenses';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  Expense query() => Expense();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'group_id',
    'created_by_user_id',
    'category_id',
    'amount_cents',
    'occurred_on',
    'note',
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

  static const _occurredOnCast = DateText();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  Expense fromMap(Map<String, dynamic> m) => Expense()
    ..id = m['id'] as int?
    ..groupId = m['group_id'] as int
    ..createdByUserId = m['created_by_user_id'] as int?
    ..categoryId = m['category_id'] as int?
    ..amountCents = m['amount_cents'] as int
    ..occurredOn = _occurredOnCast.get(m['occurred_on']) as String
    ..note = m['note'] as String?
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    Expense instance = this as Expense;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'created_by_user_id': instance.createdByUserId,
      'category_id': instance.categoryId,
      'amount_cents': instance.amountCents,
      'occurred_on': _occurredOnCast.set(instance.occurredOn),
      'note': instance.note,
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    Expense instance = i as Expense;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    Expense instance = this as Expense;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'group_id':
        if (value is! int) return false;
        instance.groupId = value;
        return true;
      case 'created_by_user_id':
        if (value is! int?) return false;
        instance.createdByUserId = value;
        return true;
      case 'category_id':
        if (value is! int?) return false;
        instance.categoryId = value;
        return true;
      case 'amount_cents':
        if (value is! int) return false;
        instance.amountCents = value;
        return true;
      case 'occurred_on':
        if (value is! String) return false;
        instance.occurredOn = value;
        return true;
      case 'note':
        if (value is! String?) return false;
        instance.note = value;
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

  @override
  bool $copyColumnsFrom(Model<Expense> other) {
    Expense o = other as Expense;
    (this as Expense)
      ..id = o.id
      ..groupId = o.groupId
      ..createdByUserId = o.createdByUserId
      ..categoryId = o.categoryId
      ..amountCents = o.amountCents
      ..occurredOn = o.occurredOn
      ..note = o.note
      ..createdAtText = o.createdAtText
      ..updatedAtText = o.updatedAtText;
    return true;
  }
}
