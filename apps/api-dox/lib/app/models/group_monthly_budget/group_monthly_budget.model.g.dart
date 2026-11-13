// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_monthly_budget.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class GroupMonthlyBudgetGenerator extends Model<GroupMonthlyBudget> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'group_monthly_budgets';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  GroupMonthlyBudget query() => GroupMonthlyBudget();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'group_id',
    'month_key',
    'budget_cents',
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

  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  GroupMonthlyBudget fromMap(Map<String, dynamic> m) => GroupMonthlyBudget()
    ..id = m['id'] as int?
    ..groupId = m['group_id'] as int
    ..monthKey = m['month_key'] as String
    ..budgetCents = m['budget_cents'] as int
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    GroupMonthlyBudget instance = this as GroupMonthlyBudget;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'month_key': instance.monthKey,
      'budget_cents': instance.budgetCents,
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    GroupMonthlyBudget instance = i as GroupMonthlyBudget;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    GroupMonthlyBudget instance = this as GroupMonthlyBudget;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'group_id':
        if (value is! int) return false;
        instance.groupId = value;
        return true;
      case 'month_key':
        if (value is! String) return false;
        instance.monthKey = value;
        return true;
      case 'budget_cents':
        if (value is! int) return false;
        instance.budgetCents = value;
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
  bool $copyColumnsFrom(Model<GroupMonthlyBudget> other) {
    GroupMonthlyBudget o = other as GroupMonthlyBudget;
    (this as GroupMonthlyBudget)
      ..id = o.id
      ..groupId = o.groupId
      ..monthKey = o.monthKey
      ..budgetCents = o.budgetCents
      ..createdAtText = o.createdAtText
      ..updatedAtText = o.updatedAtText;
    return true;
  }
}
