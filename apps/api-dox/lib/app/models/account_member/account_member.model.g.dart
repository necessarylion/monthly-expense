// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_member.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class AccountMemberGenerator extends Model<AccountMember> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'account_members';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  AccountMember query() => AccountMember();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'account_id',
    'user_id',
    'email',
    'invited_by_user_id',
    'joined_at',
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

  static const _joinedAtCast = TimestampText();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  AccountMember fromMap(Map<String, dynamic> m) => AccountMember()
    ..id = m['id'] as int?
    ..accountId = m['account_id'] as int
    ..userId = m['user_id'] as int?
    ..email = m['email'] as String
    ..invitedByUserId = m['invited_by_user_id'] as int?
    ..joinedAt = _joinedAtCast.get(m['joined_at'])
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    AccountMember instance = this as AccountMember;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'user_id': instance.userId,
      'email': instance.email,
      'invited_by_user_id': instance.invitedByUserId,
      'joined_at': _joinedAtCast.set(instance.joinedAt),
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    AccountMember instance = i as AccountMember;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    AccountMember instance = this as AccountMember;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'account_id':
        if (value is! int) return false;
        instance.accountId = value;
        return true;
      case 'user_id':
        if (value is! int?) return false;
        instance.userId = value;
        return true;
      case 'email':
        if (value is! String) return false;
        instance.email = value;
        return true;
      case 'invited_by_user_id':
        if (value is! int?) return false;
        instance.invitedByUserId = value;
        return true;
      case 'joined_at':
        if (value is! String?) return false;
        instance.joinedAt = value;
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
  bool $copyColumnsFrom(Model<AccountMember> other) {
    AccountMember o = other as AccountMember;
    (this as AccountMember)
      ..id = o.id
      ..accountId = o.accountId
      ..userId = o.userId
      ..email = o.email
      ..invitedByUserId = o.invitedByUserId
      ..joinedAt = o.joinedAt
      ..createdAtText = o.createdAtText
      ..updatedAtText = o.updatedAtText;
    return true;
  }
}
