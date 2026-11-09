// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_entry.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class AccountEntryGenerator extends Model<AccountEntry> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'account_entries';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  AccountEntry query() => AccountEntry();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'account_id',
    'expense_id',
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
  AccountEntry fromMap(Map<String, dynamic> m) => AccountEntry()
    ..id = m['id'] as int?
    ..accountId = m['account_id'] as int
    ..expenseId = m['expense_id'] as int?
    ..amountCents = m['amount_cents'] as int
    ..occurredOn = _occurredOnCast.get(m['occurred_on']) as String
    ..note = m['note'] as String?
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    AccountEntry instance = this as AccountEntry;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'expense_id': instance.expenseId,
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
    AccountEntry instance = i as AccountEntry;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    AccountEntry instance = this as AccountEntry;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'account_id':
        if (value is! int) return false;
        instance.accountId = value;
        return true;
      case 'expense_id':
        if (value is! int?) return false;
        instance.expenseId = value;
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
}
