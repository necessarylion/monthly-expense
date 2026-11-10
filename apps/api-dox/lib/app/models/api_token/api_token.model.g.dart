// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_token.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class ApiTokenGenerator extends Model<ApiToken> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'api_tokens';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  ApiToken query() => ApiToken();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'user_id',
    'token_hash',
    'name',
    'second_factor',
    'last_used_at',
    'expires_at',
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

  static const _secondFactorCast = BoolCast();
  static const _lastUsedAtCast = TimestampText();
  static const _expiresAtCast = TimestampText();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  ApiToken fromMap(Map<String, dynamic> m) => ApiToken()
    ..id = m['id'] as int?
    ..userId = m['user_id'] as int
    ..tokenHash = m['token_hash'] as String
    ..name = m['name'] as String
    ..secondFactor = _secondFactorCast.get(m['second_factor'])
    ..lastUsedAt = _lastUsedAtCast.get(m['last_used_at'])
    ..expiresAt = _expiresAtCast.get(m['expires_at']) as String
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    ApiToken instance = this as ApiToken;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'token_hash': instance.tokenHash,
      'name': instance.name,
      'second_factor': _secondFactorCast.set(instance.secondFactor),
      'last_used_at': _lastUsedAtCast.set(instance.lastUsedAt),
      'expires_at': _expiresAtCast.set(instance.expiresAt),
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    ApiToken instance = i as ApiToken;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    ApiToken instance = this as ApiToken;
    switch (column) {
      case 'id':
        if (value is! int?) return false;
        instance.id = value;
        return true;
      case 'user_id':
        if (value is! int) return false;
        instance.userId = value;
        return true;
      case 'token_hash':
        if (value is! String) return false;
        instance.tokenHash = value;
        return true;
      case 'name':
        if (value is! String) return false;
        instance.name = value;
        return true;
      case 'second_factor':
        if (value is! bool?) return false;
        instance.secondFactor = value;
        return true;
      case 'last_used_at':
        if (value is! String?) return false;
        instance.lastUsedAt = value;
        return true;
      case 'expires_at':
        if (value is! String) return false;
        instance.expiresAt = value;
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
