// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CreateShoppingItem].
const DtoSchema<CreateShoppingItem> $CreateShoppingItemDto =
    _$CreateShoppingItemDto();

class _$CreateShoppingItemDto extends DtoSchema<CreateShoppingItem> {
  const _$CreateShoppingItemDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => CreateShoppingItem;

  @override
  String get name => 'CreateShoppingItem';

  @override
  bool get usesRequiredWhen => false;

  @override
  CreateShoppingItem? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int?
    Object? c0;
    c0 = s.integer(
      s.read(input, 'groupId', emptyToNull: true),
      p,
      'groupId',
      _m,
    );
    // name: String
    Object? c1;
    c1 = s.string(
      s.read(input, 'name', emptyToNull: true),
      p,
      'name',
      _m,
      trim: true,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'name', _m);
    if (s.issues.length != e && !s.allErrors) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'groupId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c0,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(c1.runes.length >= 1 && c1.runes.length <= 200)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 200},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return CreateShoppingItem(
      groupId: c0 is Undefined ? null : c0 as int?,
      name: c1 as String,
    );
  }

  @override
  CreateShoppingItem fromMap(Map<String, dynamic> m) {
    return CreateShoppingItem(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      name: m['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap(CreateShoppingItem o) {
    int? f0 = o.groupId;
    String f1 = o.name;
    return <String, dynamic>{'groupId': f0, 'name': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'CreateShoppingItem',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 200,
          'description': 'What to buy, e.g. "Milk".',
        },
      },
      'required': <dynamic>['name'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [UpdateShoppingItem].
const DtoSchema<UpdateShoppingItem> $UpdateShoppingItemDto =
    _$UpdateShoppingItemDto();

class _$UpdateShoppingItemDto extends DtoSchema<UpdateShoppingItem> {
  const _$UpdateShoppingItemDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => UpdateShoppingItem;

  @override
  String get name => 'UpdateShoppingItem';

  @override
  bool get usesRequiredWhen => false;

  @override
  UpdateShoppingItem? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int?
    Object? c0;
    c0 = s.integer(
      s.read(input, 'groupId', emptyToNull: true),
      p,
      'groupId',
      _m,
    );
    // id: int?
    Object? c1;
    c1 = s.integer(s.read(input, 'id', emptyToNull: true), p, 'id', _m);
    // name: String?
    Object? c2;
    c2 = s.string(
      s.read(input, 'name', emptyToNull: true),
      p,
      'name',
      _m,
      trim: true,
    );
    // done: bool?
    Object? c3;
    c3 = s.boolean(s.read(input, 'done', emptyToNull: true), p, 'done', _m);
    if (s.issues.length != e && !s.allErrors) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'groupId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c0,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c1 is int) {
      if (!(c1 > 0)) {
        s.fail(
          p,
          'id',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(c2.runes.length >= 1 && c2.runes.length <= 200)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c2,
          params: const <String, Object?>{'min': 1, 'max': 200},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return UpdateShoppingItem(
      groupId: c0 is Undefined ? null : c0 as int?,
      id: c1 is Undefined ? null : c1 as int?,
      name: c2 is Undefined ? null : c2 as String?,
      done: c3 is Undefined ? null : c3 as bool?,
    );
  }

  @override
  UpdateShoppingItem fromMap(Map<String, dynamic> m) {
    return UpdateShoppingItem(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      id: m['id'] == null ? null : ((m['id'] as num).toInt()),
      name: m['name'] == null ? null : (m['name'] as String),
      done: m['done'] == null ? null : (m['done'] as bool),
    );
  }

  @override
  Map<String, dynamic> toMap(UpdateShoppingItem o) {
    int? f0 = o.groupId;
    int? f1 = o.id;
    String? f2 = o.name;
    bool? f3 = o.done;
    return <String, dynamic>{'groupId': f0, 'id': f1, 'name': f2, 'done': f3};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'UpdateShoppingItem',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Item ID (see list_shopping_items). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 200,
          'description': 'New name.',
        },
        'done': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'true when bought, false to put it back on the list.',
        },
      },
    };
  }
}
