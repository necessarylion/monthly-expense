// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_add.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [SmartAddText].
const DtoSchema<SmartAddText> $SmartAddTextDto = _$SmartAddTextDto();

class _$SmartAddTextDto extends DtoSchema<SmartAddText> {
  const _$SmartAddTextDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => SmartAddText;

  @override
  String get name => 'SmartAddText';

  @override
  bool get usesRequiredWhen => false;

  @override
  SmartAddText? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // text: String
    Object? c0;
    c0 = s.string(s.read(input, 'text'), p, 'text', _m, trim: true);
    if (c0 == null || c0 is Undefined) s.required(p, 'text', _m);
    // today: String
    Object? c1;
    c1 = s.string(s.read(input, 'today'), p, 'today', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'today', _m);
    if (s.issues.length != e && !s.allErrors) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 500)) {
        s.fail(
          p,
          'text',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 500},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c1, s.context(p, 'today', c1)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'today', c1, _m);
      }
    }
    if (s.issues.length != e) return null;
    return SmartAddText(text: c0 as String, today: c1 as String);
  }

  @override
  SmartAddText fromMap(Map<String, dynamic> m) {
    return SmartAddText(text: m['text'] as String, today: m['today'] as String);
  }

  @override
  Map<String, dynamic> toMap(SmartAddText o) {
    String f0 = o.text;
    String f1 = o.today;
    return <String, dynamic>{'text': f0, 'today': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'SmartAddText',
      'properties': <String, dynamic>{
        'text': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 500,
        },
        'today': <String, dynamic>{
          'type': 'string',
          'description':
              'The user\'s today, so a late-night add lands on their day.',
        },
      },
      'required': <dynamic>['text', 'today'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'today',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}
