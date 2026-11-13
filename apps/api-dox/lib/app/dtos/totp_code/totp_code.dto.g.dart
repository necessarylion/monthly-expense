// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totp_code.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [TotpCode].
const DtoSchema<TotpCode> $TotpCodeDto = _$TotpCodeDto();

class _$TotpCodeDto extends DtoSchema<TotpCode> {
  const _$TotpCodeDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => TotpCode;

  @override
  String get name => 'TotpCode';

  @override
  bool get usesRequiredWhen => false;

  @override
  TotpCode? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // code: String
    Object? c0;
    c0 = s.string(s.read(input, 'code'), p, 'code', _m, trim: true);
    if (c0 == null || c0 is Undefined) s.required(p, 'code', _m);
    if (s.issues.length != e && !s.allErrors) return null;
    if (c0 is String) {
      if (!(c0.runes.length == 6)) {
        s.fail(
          p,
          'code',
          IssueCodes.length,
          DefaultMessages.length,
          c0,
          params: const <String, Object?>{'length': 6},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return TotpCode(code: c0 as String);
  }

  @override
  TotpCode fromMap(Map<String, dynamic> m) {
    return TotpCode(code: m['code'] as String);
  }

  @override
  Map<String, dynamic> toMap(TotpCode o) {
    String f0 = o.code;
    return <String, dynamic>{'code': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'TotpCode',
      'properties': <String, dynamic>{
        'code': <String, dynamic>{
          'type': 'string',
          'minLength': 6,
          'maxLength': 6,
        },
      },
      'required': <dynamic>['code'],
    };
  }
}
