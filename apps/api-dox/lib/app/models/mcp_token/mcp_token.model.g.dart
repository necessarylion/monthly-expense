// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_token.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

// ignore_for_file: always_specify_types

class McpTokenGenerator extends Model<McpToken> {
  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> get timestampsColumn => const <String, dynamic>{
    'created_at': null,
    'updated_at': null,
  };

  @override
  String get tableName => 'mcp_tokens';

  int? get id => tempIdValue as int?;

  set id(int? val) => tempIdValue = val;

  McpToken query() => McpToken();

  @override
  bool get readsRowDates => true;

  @override
  List<String> get tableColumns => const <String>[
    'id',
    'user_id',
    'name',
    'token_hash',
    'last_used_at',
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

  static const _lastUsedAtCast = TimestampText();
  static const _createdAtTextCast = TimestampText();
  static const _updatedAtTextCast = TimestampText();

  @override
  McpToken fromMap(Map<String, dynamic> m) => McpToken()
    ..id = m['id'] as int?
    ..userId = m['user_id'] as int
    ..name = m['name'] as String
    ..tokenHash = m['token_hash'] as String
    ..lastUsedAt = _lastUsedAtCast.get(m['last_used_at'])
    ..createdAtText = _createdAtTextCast.get(m['created_at']) as String
    ..updatedAtText = _updatedAtTextCast.get(m['updated_at']) as String;
  @override
  Map<String, dynamic> columnsToMap() {
    McpToken instance = this as McpToken;
    Map<String, dynamic> map = <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'token_hash': instance.tokenHash,
      'last_used_at': _lastUsedAtCast.set(instance.lastUsedAt),
      'created_at': _createdAtTextCast.set(instance.createdAtText),
      'updated_at': _updatedAtTextCast.set(instance.updatedAtText),
    };

    return map;
  }

  @override
  Map<String, dynamic> convertToMap(dynamic i) {
    McpToken instance = i as McpToken;
    Map<String, dynamic> map = instance.columnsToMap();

    return map;
  }

  @override
  bool setColumnValue(String column, dynamic value) {
    McpToken instance = this as McpToken;
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
      case 'token_hash':
        if (value is! String) return false;
        instance.tokenHash = value;
        return true;
      case 'last_used_at':
        if (value is! String?) return false;
        instance.lastUsedAt = value;
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
