// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CreateCategory].
const DtoSchema<CreateCategory> $CreateCategoryDto = _$CreateCategoryDto();

class _$CreateCategoryDto extends DtoSchema<CreateCategory> {
  const _$CreateCategoryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => CreateCategory;

  @override
  String get name => 'CreateCategory';

  @override
  CreateCategory? convert(Object? input, DtoState s, List<Object> p) {
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
    // iconKey: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'iconKey', emptyToNull: true),
      p,
      'iconKey',
      _m,
      trim: true,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'iconKey', _m);
    // color: String
    Object? c3;
    c3 = s.string(
      s.read(input, 'color', emptyToNull: true),
      p,
      'color',
      _m,
      trim: true,
    );
    if (c3 == null || c3 is Undefined) s.required(p, 'color', _m);
    if (s.issues.length != e) return null;
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
      if (!(c1.runes.length >= 1 && c1.runes.length <= 50)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 50},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(c2.runes.length >= 1 && c2.runes.length <= 50)) {
        s.fail(
          p,
          'iconKey',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c2,
          params: const <String, Object?>{'min': 1, 'max': 50},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(const HexColor().check(c3, s.context(p, 'color', c3)))) {
        s.failRule(const HexColor(), p, 'color', c3, _m);
      }
    }
    if (s.issues.length != e) return null;
    return CreateCategory(
      groupId: c0 is Undefined ? null : c0 as int?,
      name: c1 as String,
      iconKey: c2 as String,
      color: c3 as String,
    );
  }

  @override
  CreateCategory fromMap(Map<String, dynamic> m) {
    return CreateCategory(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      name: m['name'] as String,
      iconKey: m['iconKey'] as String,
      color: m['color'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap(CreateCategory o) {
    int? f0 = o.groupId;
    String f1 = o.name;
    String f2 = o.iconKey;
    String f3 = o.color;
    return <String, dynamic>{
      'groupId': f0,
      'name': f1,
      'iconKey': f2,
      'color': f3,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'CreateCategory',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 50,
          'description': 'Display name, e.g. "Coffee".',
        },
        'iconKey': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 50,
          'description': 'Icon key. One of: utensils, car, home, shopping-bag, heart-pulse, film, receipt, wallet, coffee, gift, plane, book, dumbbell, fuel, shirt, zap, tag.',
        },
        'color': <String, dynamic>{
          'type': 'string',
          'description': 'Hex color, e.g. "#3b82f6".',
        },
      },
      'required': <dynamic>['name', 'iconKey', 'color'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'color',
    ], const HexColor().toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [UpdateCategory].
const DtoSchema<UpdateCategory> $UpdateCategoryDto = _$UpdateCategoryDto();

class _$UpdateCategoryDto extends DtoSchema<UpdateCategory> {
  const _$UpdateCategoryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => UpdateCategory;

  @override
  String get name => 'UpdateCategory';

  @override
  UpdateCategory? convert(Object? input, DtoState s, List<Object> p) {
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
    // iconKey: String?
    Object? c3;
    c3 = s.string(
      s.read(input, 'iconKey', emptyToNull: true),
      p,
      'iconKey',
      _m,
      trim: true,
    );
    // color: String?
    Object? c4;
    c4 = s.string(
      s.read(input, 'color', emptyToNull: true),
      p,
      'color',
      _m,
      trim: true,
    );
    if (s.issues.length != e) return null;
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
      if (!(c2.runes.length >= 1 && c2.runes.length <= 50)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c2,
          params: const <String, Object?>{'min': 1, 'max': 50},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(c3.runes.length >= 1 && c3.runes.length <= 50)) {
        s.fail(
          p,
          'iconKey',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c3,
          params: const <String, Object?>{'min': 1, 'max': 50},
          messages: _m,
        );
      }
    }
    if (c4 is String) {
      if (!(const HexColor().check(c4, s.context(p, 'color', c4)))) {
        s.failRule(const HexColor(), p, 'color', c4, _m);
      }
    }
    if (s.issues.length != e) return null;
    return UpdateCategory(
      groupId: c0 is Undefined ? null : c0 as int?,
      id: c1 is Undefined ? null : c1 as int?,
      name: c2 is Undefined ? null : c2 as String?,
      iconKey: c3 is Undefined ? null : c3 as String?,
      color: c4 is Undefined ? null : c4 as String?,
    );
  }

  @override
  UpdateCategory fromMap(Map<String, dynamic> m) {
    return UpdateCategory(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      id: m['id'] == null ? null : ((m['id'] as num).toInt()),
      name: m['name'] == null ? null : (m['name'] as String),
      iconKey: m['iconKey'] == null ? null : (m['iconKey'] as String),
      color: m['color'] == null ? null : (m['color'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(UpdateCategory o) {
    int? f0 = o.groupId;
    int? f1 = o.id;
    String? f2 = o.name;
    String? f3 = o.iconKey;
    String? f4 = o.color;
    return <String, dynamic>{
      'groupId': f0,
      'id': f1,
      'name': f2,
      'iconKey': f3,
      'color': f4,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'UpdateCategory',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Category ID (see list_categories). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 50,
          'description': 'New display name.',
        },
        'iconKey': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 50,
          'description': 'New icon key. Icon key. One of: utensils, car, home, shopping-bag, heart-pulse, film, receipt, wallet, coffee, gift, plane, book, dumbbell, fuel, shirt, zap, tag.',
        },
        'color': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New color. Hex color, e.g. "#3b82f6".',
        },
      },
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'color',
    ], const HexColor().toJsonSchema());
    return j;
  }
}
