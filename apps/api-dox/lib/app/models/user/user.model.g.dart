// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class UserGenerator extends Model<User> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'users';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  User query() => User();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'firebase_uid',
    'email',
    'display_name',
    'photo_url',
    'totp_secret',
    'totp_enabled',
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

  static const _totpEnabledCast = BoolCast();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  User fromMap(Map<String, dynamic> m) => User()
    ..id = m['id'] as int?
    ..firebaseUid = m['firebase_uid'] as String
    ..email = m['email'] as String
    ..displayName = m['display_name'] as String?
    ..photoUrl = m['photo_url'] as String?
    ..totpSecret = m['totp_secret'] as String?
    ..totpEnabled = _totpEnabledCast.get(m['totp_enabled'])
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    User instance = this as User;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'firebase_uid': instance.firebaseUid,
      'email': instance.email,
      'display_name': instance.displayName,
      'photo_url': instance.photoUrl,
      'totp_secret': instance.totpSecret,
      'totp_enabled': _totpEnabledCast.set(instance.totpEnabled),
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    User instance = i as User;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    User instance = this as User;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'firebase_uid':
        if (value is! String) return false;
        instance.firebaseUid = value;
        return true;
      case 'email':
        if (value is! String) return false;
        instance.email = value;
        return true;
      case 'display_name':
        if (value is! String?) return false;
        instance.displayName = value;
        return true;
      case 'photo_url':
        if (value is! String?) return false;
        instance.photoUrl = value;
        return true;
      case 'totp_secret':
        if (value is! String?) return false;
        instance.totpSecret = value;
        return true;
      case 'totp_enabled':
        if (value is! bool?) return false;
        instance.totpEnabled = value;
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
  bool $copyColumnsFrom(Model<User> other) {
    User o = other as User;
    (this as User)
      ..id = o.id
      ..firebaseUid = o.firebaseUid
      ..email = o.email
      ..displayName = o.displayName
      ..photoUrl = o.photoUrl
      ..totpSecret = o.totpSecret
      ..totpEnabled = o.totpEnabled
      ..createdAtText = o.createdAtText
      ..updatedAtText = o.updatedAtText;
    return true;
  }
}
