// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class RecurringExpenseGenerator extends Model<RecurringExpense> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'recurring_expenses';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  RecurringExpense query() => RecurringExpense();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'group_id',
    'created_by_user_id',
    'category_id',
    'account_id',
    'amount_cents',
    'note',
    'day_of_month',
    'next_on',
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

  static const _nextOnCast = DateText();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  RecurringExpense fromMap(Map<String, dynamic> m) => RecurringExpense()
    ..id = m['id'] as int?
    ..groupId = m['group_id'] as int
    ..createdByUserId = m['created_by_user_id'] as int?
    ..categoryId = m['category_id'] as int?
    ..accountId = m['account_id'] as int?
    ..amountCents = m['amount_cents'] as int
    ..note = m['note'] as String?
    ..dayOfMonth = m['day_of_month'] as int
    ..nextOn = _nextOnCast.get(m['next_on']) as String
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    RecurringExpense instance = this as RecurringExpense;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'created_by_user_id': instance.createdByUserId,
      'category_id': instance.categoryId,
      'account_id': instance.accountId,
      'amount_cents': instance.amountCents,
      'note': instance.note,
      'day_of_month': instance.dayOfMonth,
      'next_on': _nextOnCast.set(instance.nextOn),
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    RecurringExpense instance = i as RecurringExpense;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    RecurringExpense instance = this as RecurringExpense;
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
      case 'account_id':
        if (value is! int?) return false;
        instance.accountId = value;
        return true;
      case 'amount_cents':
        if (value is! int) return false;
        instance.amountCents = value;
        return true;
      case 'note':
        if (value is! String?) return false;
        instance.note = value;
        return true;
      case 'day_of_month':
        if (value is! int) return false;
        instance.dayOfMonth = value;
        return true;
      case 'next_on':
        if (value is! String) return false;
        instance.nextOn = value;
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
  bool $copyColumnsFrom(Model<RecurringExpense> other) {
    RecurringExpense o = other as RecurringExpense;
    (this as RecurringExpense)
      ..id = o.id
      ..groupId = o.groupId
      ..createdByUserId = o.createdByUserId
      ..categoryId = o.categoryId
      ..accountId = o.accountId
      ..amountCents = o.amountCents
      ..note = o.note
      ..dayOfMonth = o.dayOfMonth
      ..nextOn = o.nextOn
      ..createdAtText = o.createdAtText
      ..updatedAtText = o.updatedAtText;
    return true;
  }
}
