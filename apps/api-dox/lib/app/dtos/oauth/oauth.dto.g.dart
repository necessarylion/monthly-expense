// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [OauthClientQuery].
const DtoSchema<OauthClientQuery> $OauthClientQueryDto =
    _$OauthClientQueryDto();

class _$OauthClientQueryDto extends DtoSchema<OauthClientQuery> {
  const _$OauthClientQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => OauthClientQuery;

  @override
  String get name => 'OauthClientQuery';

  @override
  Source get source => Source.query;

  @override
  OauthClientQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // clientId: String
    Object? c0;
    c0 = s.string(s.read(input, 'client_id'), p, 'client_id', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'client_id', _m);
    // redirectUri: String
    Object? c1;
    c1 = s.string(s.read(input, 'redirect_uri'), p, 'redirect_uri', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'redirect_uri', _m);
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 2000)) {
        s.fail(
          p,
          'client_id',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(c1.runes.length >= 1 && c1.runes.length <= 2000)) {
        s.fail(
          p,
          'redirect_uri',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return OauthClientQuery(clientId: c0 as String, redirectUri: c1 as String);
  }

  @override
  OauthClientQuery fromMap(Map<String, dynamic> m) {
    return OauthClientQuery(
      clientId: m['client_id'] as String,
      redirectUri: m['redirect_uri'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap(OauthClientQuery o) {
    String f0 = o.clientId;
    String f1 = o.redirectUri;
    return <String, dynamic>{'client_id': f0, 'redirect_uri': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'OauthClientQuery',
      'properties': <String, dynamic>{
        'client_id': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'redirect_uri': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
      },
      'required': <dynamic>['client_id', 'redirect_uri'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [ApproveOauth].
const DtoSchema<ApproveOauth> $ApproveOauthDto = _$ApproveOauthDto();

class _$ApproveOauthDto extends DtoSchema<ApproveOauth> {
  const _$ApproveOauthDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => ApproveOauth;

  @override
  String get name => 'ApproveOauth';

  @override
  ApproveOauth? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // clientId: String
    Object? c0;
    c0 = s.string(
      s.read(input, 'clientId', emptyToNull: true),
      p,
      'clientId',
      _m,
    );
    if (c0 == null || c0 is Undefined) s.required(p, 'clientId', _m);
    // redirectUri: String
    Object? c1;
    c1 = s.string(
      s.read(input, 'redirectUri', emptyToNull: true),
      p,
      'redirectUri',
      _m,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'redirectUri', _m);
    // codeChallenge: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'codeChallenge', emptyToNull: true),
      p,
      'codeChallenge',
      _m,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'codeChallenge', _m);
    // codeChallengeMethod: String
    Object? c3;
    c3 = s.string(
      s.read(input, 'codeChallengeMethod', emptyToNull: true),
      p,
      'codeChallengeMethod',
      _m,
    );
    if (c3 == null || c3 is Undefined) s.required(p, 'codeChallengeMethod', _m);
    // state: String?
    Object? c4;
    c4 = s.string(s.read(input, 'state', emptyToNull: true), p, 'state', _m);
    // resource: String?
    Object? c5;
    c5 = s.string(
      s.read(input, 'resource', emptyToNull: true),
      p,
      'resource',
      _m,
    );
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 2000)) {
        s.fail(
          p,
          'clientId',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(c1.runes.length >= 1 && c1.runes.length <= 2000)) {
        s.fail(
          p,
          'redirectUri',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(c2.runes.length >= 1 && c2.runes.length <= 2000)) {
        s.fail(
          p,
          'codeChallenge',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c2,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(c3.runes.length >= 1 && c3.runes.length <= 20)) {
        s.fail(
          p,
          'codeChallengeMethod',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c3,
          params: const <String, Object?>{'min': 1, 'max': 20},
          messages: _m,
        );
      }
    }
    if (c4 is String) {
      if (!(c4.runes.length <= 2000)) {
        s.fail(
          p,
          'state',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c4,
          params: const <String, Object?>{'max': 2000},
          messages: _m,
        );
      }
    }
    if (c5 is String) {
      if (!(c5.runes.length <= 2000)) {
        s.fail(
          p,
          'resource',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c5,
          params: const <String, Object?>{'max': 2000},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return ApproveOauth(
      clientId: c0 as String,
      redirectUri: c1 as String,
      codeChallenge: c2 as String,
      codeChallengeMethod: c3 as String,
      state: c4 is Undefined ? null : c4 as String?,
      resource: c5 is Undefined ? null : c5 as String?,
    );
  }

  @override
  ApproveOauth fromMap(Map<String, dynamic> m) {
    return ApproveOauth(
      clientId: m['clientId'] as String,
      redirectUri: m['redirectUri'] as String,
      codeChallenge: m['codeChallenge'] as String,
      codeChallengeMethod: m['codeChallengeMethod'] as String,
      state: m['state'] == null ? null : (m['state'] as String),
      resource: m['resource'] == null ? null : (m['resource'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(ApproveOauth o) {
    String f0 = o.clientId;
    String f1 = o.redirectUri;
    String f2 = o.codeChallenge;
    String f3 = o.codeChallengeMethod;
    String? f4 = o.state;
    String? f5 = o.resource;
    return <String, dynamic>{
      'clientId': f0,
      'redirectUri': f1,
      'codeChallenge': f2,
      'codeChallengeMethod': f3,
      'state': f4,
      'resource': f5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'ApproveOauth',
      'properties': <String, dynamic>{
        'clientId': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'redirectUri': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'codeChallenge': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'codeChallengeMethod': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 20,
        },
        'state': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 2000,
        },
        'resource': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 2000,
        },
      },
      'required': <dynamic>[
        'clientId',
        'redirectUri',
        'codeChallenge',
        'codeChallengeMethod',
      ],
    };
  }
}

/// The checks, the converter and the JSON Schema of [DenyOauth].
const DtoSchema<DenyOauth> $DenyOauthDto = _$DenyOauthDto();

class _$DenyOauthDto extends DtoSchema<DenyOauth> {
  const _$DenyOauthDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => DenyOauth;

  @override
  String get name => 'DenyOauth';

  @override
  DenyOauth? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // clientId: String
    Object? c0;
    c0 = s.string(
      s.read(input, 'clientId', emptyToNull: true),
      p,
      'clientId',
      _m,
    );
    if (c0 == null || c0 is Undefined) s.required(p, 'clientId', _m);
    // redirectUri: String
    Object? c1;
    c1 = s.string(
      s.read(input, 'redirectUri', emptyToNull: true),
      p,
      'redirectUri',
      _m,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'redirectUri', _m);
    // state: String?
    Object? c2;
    c2 = s.string(s.read(input, 'state', emptyToNull: true), p, 'state', _m);
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 2000)) {
        s.fail(
          p,
          'clientId',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(c1.runes.length >= 1 && c1.runes.length <= 2000)) {
        s.fail(
          p,
          'redirectUri',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 2000},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(c2.runes.length <= 2000)) {
        s.fail(
          p,
          'state',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c2,
          params: const <String, Object?>{'max': 2000},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return DenyOauth(
      clientId: c0 as String,
      redirectUri: c1 as String,
      state: c2 is Undefined ? null : c2 as String?,
    );
  }

  @override
  DenyOauth fromMap(Map<String, dynamic> m) {
    return DenyOauth(
      clientId: m['clientId'] as String,
      redirectUri: m['redirectUri'] as String,
      state: m['state'] == null ? null : (m['state'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(DenyOauth o) {
    String f0 = o.clientId;
    String f1 = o.redirectUri;
    String? f2 = o.state;
    return <String, dynamic>{'clientId': f0, 'redirectUri': f1, 'state': f2};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'DenyOauth',
      'properties': <String, dynamic>{
        'clientId': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'redirectUri': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 2000,
        },
        'state': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 2000,
        },
      },
      'required': <dynamic>['clientId', 'redirectUri'],
    };
  }
}
