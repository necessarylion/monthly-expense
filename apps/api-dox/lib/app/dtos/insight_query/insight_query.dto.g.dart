// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_query.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [InsightQuery].
const DtoSchema<InsightQuery> $InsightQueryDto = _$InsightQueryDto();

class _$InsightQueryDto extends DtoSchema<InsightQuery> {
  const _$InsightQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => InsightQuery;

  @override
  String get name => 'InsightQuery';

  @override
  Source get source => Source.query;

  @override
  InsightQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // month: String?
    Object? c0;
    c0 = s.string(s.read(input, 'month'), p, 'month', _m);
    // lang: String?
    Object? c1;
    c1 = s.string(s.read(input, 'lang'), p, 'lang', _m);
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(const DateFormatted('Y-m').check(c0, s.context(p, 'month', c0)))) {
        s.failRule(const DateFormatted('Y-m'), p, 'month', c0, _m);
      }
    }
    if (c1 is String) {
      if (!(const <String>{'en', 'my'}.contains(c1))) {
        s.fail(
          p,
          'lang',
          IssueCodes.inList,
          DefaultMessages.inList,
          c1,
          params: const <String, Object?>{'values': 'en, and my'},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return InsightQuery(
      month: c0 is Undefined ? null : c0 as String?,
      lang: c1 is Undefined ? null : c1 as String?,
    );
  }

  @override
  InsightQuery fromMap(Map<String, dynamic> m) {
    return InsightQuery(
      month: m['month'] == null ? null : (m['month'] as String),
      lang: m['lang'] == null ? null : (m['lang'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(InsightQuery o) {
    String? f0 = o.month;
    String? f1 = o.lang;
    return <String, dynamic>{'month': f0, 'lang': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'InsightQuery',
      'properties': <String, dynamic>{
        'month': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
        },
        'lang': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'enum': <dynamic>['en', 'my'],
          'description': 'The app language, so Claude writes in it.',
        },
      },
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'month',
    ], const DateFormatted('Y-m').toJsonSchema());
    return j;
  }
}
