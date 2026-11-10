// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_add_pick.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [QuickAddPick].
const DtoSchema<QuickAddPick> $QuickAddPickDto = _$QuickAddPickDto();

class _$QuickAddPickDto extends DtoSchema<QuickAddPick> {
  const _$QuickAddPickDto();

  static const Map<String, String> _m = <String, String>{};

  static const Set<String> _keys = <String>{'ids'};

  @override
  Type get type => QuickAddPick;

  @override
  String get name => 'QuickAddPick';

  @override
  QuickAddPick? convert(Object? input, DtoState s, List<Object> p) {
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
    // ids: List<int>
    Object? c0;
    c0 = s.list(s.read(input, 'ids'), p, 'ids', _m);
    if (c0 is List) {
      List<Object> q0 = <Object>[...p, 'ids'];
      List<int> o0 = <int>[];
      for (int i0 = 0; i0 < c0.length; i0++) {
        Object? x0;
        x0 = s.integer(c0[i0], q0, i0, _m);
        if (x0 == null || x0 is Undefined) {
          s.required(q0, i0, _m);
        } else if (x0 is! Invalid) {
          o0.add(x0 as int);
        }
      }
      c0 = o0;
    }
    if (c0 == null || c0 is Undefined) s.required(p, 'ids', _m);
    if (s.issues.length != e) return null;
    return QuickAddPick(ids: c0 as List<int>);
  }

  @override
  QuickAddPick fromMap(Map<String, dynamic> m) {
    return QuickAddPick(
      ids: <int>[
        for (Object? x0 in m['ids'] as List<dynamic>) (x0 as num).toInt(),
      ],
    );
  }

  @override
  Map<String, dynamic> toMap(QuickAddPick o) {
    List<int> f0 = o.ids;
    return <String, dynamic>{'ids': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'QuickAddPick',
      'properties': <String, dynamic>{
        'ids': <String, dynamic>{
          'type': 'array',
          'items': <String, dynamic>{'type': 'integer'},
          'description':
              'The ids of the rows to show, taken from the list you got.',
        },
      },
      'required': <dynamic>['ids'],
      'additionalProperties': false,
    };
  }
}
