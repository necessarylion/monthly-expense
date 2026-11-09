// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class GroupMemberGenerator extends Model<GroupMember> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'group_members';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  GroupMember query() => GroupMember();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'group_id',
    'user_id',
    'email',
    'invited_by_user_id',
    'joined_at',
    'default_account_id',
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
  GroupMember fromMap(Map<String, dynamic> m) => GroupMember()
    ..id = m['id'] as int?
    ..groupId = m['group_id'] as int
    ..userId = m['user_id'] as int?
    ..email = m['email'] as String
    ..invitedByUserId = m['invited_by_user_id'] as int?
    ..joinedAt = _joinedAtCast.get(m['joined_at'])
    ..defaultAccountId = m['default_account_id'] as int?
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    GroupMember instance = this as GroupMember;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'user_id': instance.userId,
      'email': instance.email,
      'invited_by_user_id': instance.invitedByUserId,
      'joined_at': _joinedAtCast.set(instance.joinedAt),
      'default_account_id': instance.defaultAccountId,
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    GroupMember instance = i as GroupMember;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    GroupMember instance = this as GroupMember;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'group_id':
        if (value is! int) return false;
        instance.groupId = value;
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
      case 'default_account_id':
        if (value is! int?) return false;
        instance.defaultAccountId = value;
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
