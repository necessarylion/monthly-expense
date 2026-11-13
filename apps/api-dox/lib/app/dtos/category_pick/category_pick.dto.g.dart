// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_pick.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CategoryPick].
const DtoSchema<CategoryPick> $CategoryPickDto = _$CategoryPickDto();

class _$CategoryPickDto extends DtoSchema<CategoryPick> {
  const _$CategoryPickDto();

  static const Map<String, String> _m = <String, String>{};

  static const Set<String> _keys = <String>{'categoryId'};

  @override
  Type get type => CategoryPick;

  @override
  String get name => 'CategoryPick';

  @override
  bool get usesRequiredWhen => false;

  @override
  CategoryPick? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    for (Object? k in input.keys) {
      if (!_keys.contains(k)) {
        s.fail(
          p,
          '$k',
          IssueCodes.unrecognizedKeys,
          DefaultMessages.notAllowed,
          input[k],
          messages: _m,
        );
      }
    }
    // categoryId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'categoryId'), p, 'categoryId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'categoryId', _m);
    if (s.issues.length != e && !s.allErrors) return null;
    if (s.issues.length != e) return null;
    return CategoryPick(categoryId: c0 as int);
  }

  @override
  CategoryPick fromMap(Map<String, dynamic> m) {
    return CategoryPick(categoryId: (m['categoryId'] as num).toInt());
  }

  @override
  Map<String, dynamic> toMap(CategoryPick o) {
    int f0 = o.categoryId;
    return <String, dynamic>{'categoryId': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'CategoryPick',
      'properties': <String, dynamic>{
        'categoryId': <String, dynamic>{
          'type': 'integer',
          'description': 'The id of the category the expense belongs to, from the list you got.',
        },
      },
      'required': <dynamic>['categoryId'],
      'additionalProperties': false,
    };
  }
}
