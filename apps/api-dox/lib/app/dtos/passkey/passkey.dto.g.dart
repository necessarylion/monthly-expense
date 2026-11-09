// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passkey.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [AddPasskey].
const DtoSchema<AddPasskey> $AddPasskeyDto = _$AddPasskeyDto();

class _$AddPasskeyDto extends DtoSchema<AddPasskey> {
  const _$AddPasskeyDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => AddPasskey;

  @override
  String get name => 'AddPasskey';

  @override
  AddPasskey? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // credentialId: String
    Object? c0;
    c0 = s.string(s.read(input, 'credentialId'), p, 'credentialId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'credentialId', _m);
    // clientDataJson: String
    Object? c1;
    c1 = s.string(s.read(input, 'clientDataJson'), p, 'clientDataJson', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'clientDataJson', _m);
    // authenticatorData: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'authenticatorData'),
      p,
      'authenticatorData',
      _m,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'authenticatorData', _m);
    // publicKey: String
    Object? c3;
    c3 = s.string(s.read(input, 'publicKey'), p, 'publicKey', _m);
    if (c3 == null || c3 is Undefined) s.required(p, 'publicKey', _m);
    // publicKeyAlgorithm: int
    Object? c4;
    c4 = s.integer(
      s.read(input, 'publicKeyAlgorithm'),
      p,
      'publicKeyAlgorithm',
      _m,
    );
    if (c4 == null || c4 is Undefined) s.required(p, 'publicKeyAlgorithm', _m);
    // name: String
    Object? c5;
    c5 = s.string(s.read(input, 'name'), p, 'name', _m, trim: true);
    if (c5 == null || c5 is Undefined) s.required(p, 'name', _m);
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 1400)) {
        s.fail(
          p,
          'credentialId',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 1400},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(c1.runes.length >= 1 && c1.runes.length <= 10000)) {
        s.fail(
          p,
          'clientDataJson',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 10000},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(c2.runes.length >= 1 && c2.runes.length <= 10000)) {
        s.fail(
          p,
          'authenticatorData',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c2,
          params: const <String, Object?>{'min': 1, 'max': 10000},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(c3.runes.length >= 1 && c3.runes.length <= 1000)) {
        s.fail(
          p,
          'publicKey',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c3,
          params: const <String, Object?>{'min': 1, 'max': 1000},
          messages: _m,
        );
      }
    }
    if (c5 is String) {
      if (!(c5.runes.length >= 1 && c5.runes.length <= 200)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c5,
          params: const <String, Object?>{'min': 1, 'max': 200},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return AddPasskey(
      credentialId: c0 as String,
      clientDataJson: c1 as String,
      authenticatorData: c2 as String,
      publicKey: c3 as String,
      publicKeyAlgorithm: c4 as int,
      name: c5 as String,
    );
  }

  @override
  AddPasskey fromMap(Map<String, dynamic> m) {
    return AddPasskey(
      credentialId: m['credentialId'] as String,
      clientDataJson: m['clientDataJson'] as String,
      authenticatorData: m['authenticatorData'] as String,
      publicKey: m['publicKey'] as String,
      publicKeyAlgorithm: (m['publicKeyAlgorithm'] as num).toInt(),
      name: m['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap(AddPasskey o) {
    String f0 = o.credentialId;
    String f1 = o.clientDataJson;
    String f2 = o.authenticatorData;
    String f3 = o.publicKey;
    int f4 = o.publicKeyAlgorithm;
    String f5 = o.name;
    return <String, dynamic>{
      'credentialId': f0,
      'clientDataJson': f1,
      'authenticatorData': f2,
      'publicKey': f3,
      'publicKeyAlgorithm': f4,
      'name': f5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'AddPasskey',
      'properties': <String, dynamic>{
        'credentialId': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 1400,
        },
        'clientDataJson': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 10000,
        },
        'authenticatorData': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 10000,
        },
        'publicKey': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 1000,
          'description': '`response.getPublicKey()`: SubjectPublicKeyInfo DER.',
        },
        'publicKeyAlgorithm': <String, dynamic>{
          'type': 'integer',
          'description':
              '`response.getPublicKeyAlgorithm()`, a COSE id like -7.',
        },
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 200,
        },
      },
      'required': <dynamic>[
        'credentialId',
        'clientDataJson',
        'authenticatorData',
        'publicKey',
        'publicKeyAlgorithm',
        'name',
      ],
    };
  }
}

/// The checks, the converter and the JSON Schema of [PasskeyLogin].
const DtoSchema<PasskeyLogin> $PasskeyLoginDto = _$PasskeyLoginDto();

class _$PasskeyLoginDto extends DtoSchema<PasskeyLogin> {
  const _$PasskeyLoginDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => PasskeyLogin;

  @override
  String get name => 'PasskeyLogin';

  @override
  PasskeyLogin? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // credentialId: String
    Object? c0;
    c0 = s.string(s.read(input, 'credentialId'), p, 'credentialId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'credentialId', _m);
    // clientDataJson: String
    Object? c1;
    c1 = s.string(s.read(input, 'clientDataJson'), p, 'clientDataJson', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'clientDataJson', _m);
    // authenticatorData: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'authenticatorData'),
      p,
      'authenticatorData',
      _m,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'authenticatorData', _m);
    // signature: String
    Object? c3;
    c3 = s.string(s.read(input, 'signature'), p, 'signature', _m);
    if (c3 == null || c3 is Undefined) s.required(p, 'signature', _m);
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 1400)) {
        s.fail(
          p,
          'credentialId',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 1400},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(c1.runes.length >= 1 && c1.runes.length <= 10000)) {
        s.fail(
          p,
          'clientDataJson',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 10000},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(c2.runes.length >= 1 && c2.runes.length <= 10000)) {
        s.fail(
          p,
          'authenticatorData',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c2,
          params: const <String, Object?>{'min': 1, 'max': 10000},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(c3.runes.length >= 1 && c3.runes.length <= 1000)) {
        s.fail(
          p,
          'signature',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c3,
          params: const <String, Object?>{'min': 1, 'max': 1000},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return PasskeyLogin(
      credentialId: c0 as String,
      clientDataJson: c1 as String,
      authenticatorData: c2 as String,
      signature: c3 as String,
    );
  }

  @override
  PasskeyLogin fromMap(Map<String, dynamic> m) {
    return PasskeyLogin(
      credentialId: m['credentialId'] as String,
      clientDataJson: m['clientDataJson'] as String,
      authenticatorData: m['authenticatorData'] as String,
      signature: m['signature'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap(PasskeyLogin o) {
    String f0 = o.credentialId;
    String f1 = o.clientDataJson;
    String f2 = o.authenticatorData;
    String f3 = o.signature;
    return <String, dynamic>{
      'credentialId': f0,
      'clientDataJson': f1,
      'authenticatorData': f2,
      'signature': f3,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'PasskeyLogin',
      'properties': <String, dynamic>{
        'credentialId': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 1400,
        },
        'clientDataJson': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 10000,
        },
        'authenticatorData': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 10000,
        },
        'signature': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 1000,
        },
      },
      'required': <dynamic>[
        'credentialId',
        'clientDataJson',
        'authenticatorData',
        'signature',
      ],
    };
  }
}
