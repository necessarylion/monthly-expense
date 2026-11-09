// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CreateAccount].
const DtoSchema<CreateAccount> $CreateAccountDto = _$CreateAccountDto();

class _$CreateAccountDto extends DtoSchema<CreateAccount> {
  const _$CreateAccountDto();

  static const Map<String, String> _m = <String, String>{};

  static final RegExp _r0 = RegExp('^(?:[A-Z]{3})\$');

  @override
  Type get type => CreateAccount;

  @override
  String get name => 'CreateAccount';

  @override
  CreateAccount? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // name: String
    Object? c0;
    c0 = s.string(
      s.read(input, 'name', emptyToNull: true),
      p,
      'name',
      _m,
      trim: true,
    );
    if (c0 == null || c0 is Undefined) s.required(p, 'name', _m);
    // currency: String
    Object? c1;
    c1 = s.string(
      s.read(input, 'currency', emptyToNull: true),
      p,
      'currency',
      _m,
      trim: true,
      textCase: 2,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'currency', _m);
    // color: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'color', emptyToNull: true),
      p,
      'color',
      _m,
      trim: true,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'color', _m);
    // includeInTotal: bool?
    Object? c3;
    c3 = s.boolean(
      s.read(input, 'includeInTotal', emptyToNull: true),
      p,
      'includeInTotal',
      _m,
    );
    // isDefault: bool?
    Object? c4;
    c4 = s.boolean(
      s.read(input, 'isDefault', emptyToNull: true),
      p,
      'isDefault',
      _m,
    );
    if (s.issues.length != e) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 50)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 50},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(_r0.hasMatch(c1))) {
        s.fail(
          p,
          'currency',
          IssueCodes.regex,
          DefaultMessages.regex,
          c1,
          message: 'Expected a 3-letter currency code',
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(const HexColor().check(c2, s.context(p, 'color', c2)))) {
        s.failRule(const HexColor(), p, 'color', c2, _m);
      }
    }
    if (s.issues.length != e) return null;
    return CreateAccount(
      name: c0 as String,
      currency: c1 as String,
      color: c2 as String,
      includeInTotal: c3 is Undefined ? null : c3 as bool?,
      isDefault: c4 is Undefined ? null : c4 as bool?,
    );
  }

  @override
  CreateAccount fromMap(Map<String, dynamic> m) {
    return CreateAccount(
      name: m['name'] as String,
      currency: m['currency'] as String,
      color: m['color'] as String,
      includeInTotal: m['includeInTotal'] == null
          ? null
          : (m['includeInTotal'] as bool),
      isDefault: m['isDefault'] == null ? null : (m['isDefault'] as bool),
    );
  }

  @override
  Map<String, dynamic> toMap(CreateAccount o) {
    String f0 = o.name;
    String f1 = o.currency;
    String f2 = o.color;
    bool? f3 = o.includeInTotal;
    bool? f4 = o.isDefault;
    return <String, dynamic>{
      'name': f0,
      'currency': f1,
      'color': f2,
      'includeInTotal': f3,
      'isDefault': f4,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'CreateAccount',
      'properties': <String, dynamic>{
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 50,
          'description': 'Wallet name, e.g. "Cash" or "KBank".',
        },
        'currency': <String, dynamic>{
          'type': 'string',
          'pattern': '^(?:[A-Z]{3})\$',
          'description': '3-letter currency code, e.g. "THB" or "USD".',
        },
        'color': <String, dynamic>{
          'type': 'string',
          'description': 'Hex color, e.g. "#3b82f6".',
        },
        'includeInTotal': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Count this wallet in the total. Defaults to true.',
        },
        'isDefault': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Deprecated. Old clients only; maps onto every membership\'s default.',
        },
      },
      'required': <dynamic>['name', 'currency', 'color'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'color',
    ], const HexColor().toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [UpdateAccount].
const DtoSchema<UpdateAccount> $UpdateAccountDto = _$UpdateAccountDto();

class _$UpdateAccountDto extends DtoSchema<UpdateAccount> {
  const _$UpdateAccountDto();

  static const Map<String, String> _m = <String, String>{};

  static final RegExp _r0 = RegExp('^(?:[A-Z]{3})\$');

  @override
  Type get type => UpdateAccount;

  @override
  String get name => 'UpdateAccount';

  @override
  UpdateAccount? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int?
    Object? c0;
    c0 = s.integer(
      s.read(input, 'accountId', emptyToNull: true),
      p,
      'accountId',
      _m,
    );
    // name: String?
    Object? c1;
    c1 = s.string(
      s.read(input, 'name', emptyToNull: true),
      p,
      'name',
      _m,
      trim: true,
    );
    // currency: String?
    Object? c2;
    c2 = s.string(
      s.read(input, 'currency', emptyToNull: true),
      p,
      'currency',
      _m,
      trim: true,
      textCase: 2,
    );
    // color: String?
    Object? c3;
    c3 = s.string(
      s.read(input, 'color', emptyToNull: true),
      p,
      'color',
      _m,
      trim: true,
    );
    // includeInTotal: bool?
    Object? c4;
    c4 = s.boolean(
      s.read(input, 'includeInTotal', emptyToNull: true),
      p,
      'includeInTotal',
      _m,
    );
    // isDefault: bool?
    Object? c5;
    c5 = s.boolean(
      s.read(input, 'isDefault', emptyToNull: true),
      p,
      'isDefault',
      _m,
    );
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
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
      if (!(_r0.hasMatch(c2))) {
        s.fail(
          p,
          'currency',
          IssueCodes.regex,
          DefaultMessages.regex,
          c2,
          message: 'Expected a 3-letter currency code',
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
    return UpdateAccount(
      accountId: c0 is Undefined ? null : c0 as int?,
      name: c1 is Undefined ? null : c1 as String?,
      currency: c2 is Undefined ? null : c2 as String?,
      color: c3 is Undefined ? null : c3 as String?,
      includeInTotal: c4 is Undefined ? null : c4 as bool?,
      isDefault: c5 is Undefined ? null : c5 as bool?,
    );
  }

  @override
  UpdateAccount fromMap(Map<String, dynamic> m) {
    return UpdateAccount(
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
      name: m['name'] == null ? null : (m['name'] as String),
      currency: m['currency'] == null ? null : (m['currency'] as String),
      color: m['color'] == null ? null : (m['color'] as String),
      includeInTotal: m['includeInTotal'] == null
          ? null
          : (m['includeInTotal'] as bool),
      isDefault: m['isDefault'] == null ? null : (m['isDefault'] as bool),
    );
  }

  @override
  Map<String, dynamic> toMap(UpdateAccount o) {
    int? f0 = o.accountId;
    String? f1 = o.name;
    String? f2 = o.currency;
    String? f3 = o.color;
    bool? f4 = o.includeInTotal;
    bool? f5 = o.isDefault;
    return <String, dynamic>{
      'accountId': f0,
      'name': f1,
      'currency': f2,
      'color': f3,
      'includeInTotal': f4,
      'isDefault': f5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'UpdateAccount',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 50,
          'description': 'New name.',
        },
        'currency': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'pattern': '^(?:[A-Z]{3})\$',
          'description':
              'New currency. 3-letter currency code, e.g. "THB" or "USD".',
        },
        'color': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New color. Hex color, e.g. "#3b82f6".',
        },
        'includeInTotal': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Count this wallet in the total.',
        },
        'isDefault': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Deprecated. Old clients only; maps onto every membership\'s default.',
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

/// The checks, the converter and the JSON Schema of [CreateEntry].
const DtoSchema<CreateEntry> $CreateEntryDto = _$CreateEntryDto();

class _$CreateEntryDto extends DtoSchema<CreateEntry> {
  const _$CreateEntryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => CreateEntry;

  @override
  String get name => 'CreateEntry';

  @override
  CreateEntry? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int?
    Object? c0;
    c0 = s.integer(
      s.read(input, 'accountId', emptyToNull: true),
      p,
      'accountId',
      _m,
    );
    // amount: num
    Object? c1;
    c1 = s.number(s.read(input, 'amount', emptyToNull: true), p, 'amount', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'amount', _m);
    // occurredOn: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'occurredOn', emptyToNull: true),
      p,
      'occurredOn',
      _m,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'occurredOn', _m);
    // note: String?
    Object? c3;
    c3 = s.string(
      s.read(input, 'note', emptyToNull: true),
      p,
      'note',
      _m,
      trim: true,
    );
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c0,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c1 is num) {
      if (!(c1 >= -10000000)) {
        s.fail(
          p,
          'amount',
          IssueCodes.min,
          DefaultMessages.min,
          c1,
          params: const <String, Object?>{'min': -10000000},
          messages: _m,
        );
      } else if (!(c1 <= 10000000)) {
        s.fail(
          p,
          'amount',
          IssueCodes.max,
          DefaultMessages.max,
          c1,
          params: const <String, Object?>{'max': 10000000},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c2, s.context(p, 'occurredOn', c2)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'occurredOn', c2, _m);
      }
    }
    if (c3 is String) {
      if (!(c3.runes.length <= 500)) {
        s.fail(
          p,
          'note',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c3,
          params: const <String, Object?>{'max': 500},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return CreateEntry(
      accountId: c0 is Undefined ? null : c0 as int?,
      amount: c1 as num,
      occurredOn: c2 as String,
      note: c3 is Undefined ? null : c3 as String?,
    );
  }

  @override
  CreateEntry fromMap(Map<String, dynamic> m) {
    return CreateEntry(
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
      amount: m['amount'] as num,
      occurredOn: m['occurredOn'] as String,
      note: m['note'] == null ? null : (m['note'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(CreateEntry o) {
    int? f0 = o.accountId;
    num f1 = o.amount;
    String f2 = o.occurredOn;
    String? f3 = o.note;
    return <String, dynamic>{
      'accountId': f0,
      'amount': f1,
      'occurredOn': f2,
      'note': f3,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'CreateEntry',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'amount': <String, dynamic>{
          'type': 'number',
          'minimum': -10000000,
          'maximum': 10000000,
          'description': 'Amount in dollars. Positive is money in, negative is money out. Not zero.',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
      },
      'required': <dynamic>['amount', 'occurredOn'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'occurredOn',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [UpdateEntry].
const DtoSchema<UpdateEntry> $UpdateEntryDto = _$UpdateEntryDto();

class _$UpdateEntryDto extends DtoSchema<UpdateEntry> {
  const _$UpdateEntryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => UpdateEntry;

  @override
  String get name => 'UpdateEntry';

  @override
  UpdateEntry? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int?
    Object? c0;
    c0 = s.integer(
      s.read(input, 'accountId', emptyToNull: true),
      p,
      'accountId',
      _m,
    );
    // entryId: int?
    Object? c1;
    c1 = s.integer(
      s.read(input, 'entryId', emptyToNull: true),
      p,
      'entryId',
      _m,
    );
    // amount: num?
    Object? c2;
    c2 = s.number(s.read(input, 'amount', emptyToNull: true), p, 'amount', _m);
    // occurredOn: String?
    Object? c3;
    c3 = s.string(
      s.read(input, 'occurredOn', emptyToNull: true),
      p,
      'occurredOn',
      _m,
    );
    // note: Maybe<String?>
    Object? c4;
    c4 = s.string(
      s.read(input, 'note', emptyToNull: true),
      p,
      'note',
      _m,
      trim: true,
    );
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
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
          'entryId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c2 is num) {
      if (!(c2 >= -10000000)) {
        s.fail(
          p,
          'amount',
          IssueCodes.min,
          DefaultMessages.min,
          c2,
          params: const <String, Object?>{'min': -10000000},
          messages: _m,
        );
      } else if (!(c2 <= 10000000)) {
        s.fail(
          p,
          'amount',
          IssueCodes.max,
          DefaultMessages.max,
          c2,
          params: const <String, Object?>{'max': 10000000},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c3, s.context(p, 'occurredOn', c3)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'occurredOn', c3, _m);
      }
    }
    if (c4 is String) {
      if (!(c4.runes.length <= 500)) {
        s.fail(
          p,
          'note',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c4,
          params: const <String, Object?>{'max': 500},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return UpdateEntry(
      accountId: c0 is Undefined ? null : c0 as int?,
      entryId: c1 is Undefined ? null : c1 as int?,
      amount: c2 is Undefined ? null : c2 as num?,
      occurredOn: c3 is Undefined ? null : c3 as String?,
      note: c4 is Undefined
          ? const Maybe<String?>.missing()
          : Maybe<String?>(c4 as String?),
    );
  }

  @override
  UpdateEntry fromMap(Map<String, dynamic> m) {
    return UpdateEntry(
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
      entryId: m['entryId'] == null ? null : ((m['entryId'] as num).toInt()),
      amount: m['amount'] == null ? null : (m['amount'] as num),
      occurredOn: m['occurredOn'] == null ? null : (m['occurredOn'] as String),
      note: m.containsKey('note')
          ? Maybe<String?>(m['note'] == null ? null : (m['note'] as String))
          : const Maybe<String?>.missing(),
    );
  }

  @override
  Map<String, dynamic> toMap(UpdateEntry o) {
    int? f0 = o.accountId;
    int? f1 = o.entryId;
    num? f2 = o.amount;
    String? f3 = o.occurredOn;
    Maybe<String?> f4 = o.note;
    return <String, dynamic>{
      'accountId': f0,
      'entryId': f1,
      'amount': f2,
      'occurredOn': f3,
      if (f4 case Maybe<String?>(isPresent: true, value: String? g4))
        'note': g4,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'UpdateEntry',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'entryId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Entry ID (see list_wallet_entries). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'amount': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': -10000000,
          'maximum': 10000000,
          'description': 'New signed amount in dollars. Not zero.',
        },
        'occurredOn': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'New date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'New note. Pass null to clear it.',
        },
      },
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'occurredOn',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [Transfer].
const DtoSchema<Transfer> $TransferDto = _$TransferDto();

class _$TransferDto extends DtoSchema<Transfer> {
  const _$TransferDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => Transfer;

  @override
  String get name => 'Transfer';

  @override
  Transfer? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // fromAccountId: int
    Object? c0;
    c0 = s.integer(
      s.read(input, 'fromAccountId', emptyToNull: true),
      p,
      'fromAccountId',
      _m,
    );
    if (c0 == null || c0 is Undefined) s.required(p, 'fromAccountId', _m);
    // toAccountId: int
    Object? c1;
    c1 = s.integer(
      s.read(input, 'toAccountId', emptyToNull: true),
      p,
      'toAccountId',
      _m,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'toAccountId', _m);
    // amount: num
    Object? c2;
    c2 = s.number(s.read(input, 'amount', emptyToNull: true), p, 'amount', _m);
    if (c2 == null || c2 is Undefined) s.required(p, 'amount', _m);
    // toAmount: num?
    Object? c3;
    c3 = s.number(
      s.read(input, 'toAmount', emptyToNull: true),
      p,
      'toAmount',
      _m,
    );
    // occurredOn: String
    Object? c4;
    c4 = s.string(
      s.read(input, 'occurredOn', emptyToNull: true),
      p,
      'occurredOn',
      _m,
    );
    if (c4 == null || c4 is Undefined) s.required(p, 'occurredOn', _m);
    // note: String?
    Object? c5;
    c5 = s.string(
      s.read(input, 'note', emptyToNull: true),
      p,
      'note',
      _m,
      trim: true,
    );
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'fromAccountId',
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
          'toAccountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c2 is num) {
      if (!(c2 >= 0.01)) {
        s.fail(
          p,
          'amount',
          IssueCodes.min,
          DefaultMessages.min,
          c2,
          params: const <String, Object?>{'min': 0.01},
          messages: _m,
        );
      } else if (!(c2 <= 10000000)) {
        s.fail(
          p,
          'amount',
          IssueCodes.max,
          DefaultMessages.max,
          c2,
          params: const <String, Object?>{'max': 10000000},
          messages: _m,
        );
      }
    }
    if (c3 is num) {
      if (!(c3 >= 0.01)) {
        s.fail(
          p,
          'toAmount',
          IssueCodes.min,
          DefaultMessages.min,
          c3,
          params: const <String, Object?>{'min': 0.01},
          messages: _m,
        );
      } else if (!(c3 <= 10000000)) {
        s.fail(
          p,
          'toAmount',
          IssueCodes.max,
          DefaultMessages.max,
          c3,
          params: const <String, Object?>{'max': 10000000},
          messages: _m,
        );
      }
    }
    if (c4 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c4, s.context(p, 'occurredOn', c4)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'occurredOn', c4, _m);
      }
    }
    if (c5 is String) {
      if (!(c5.runes.length <= 500)) {
        s.fail(
          p,
          'note',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c5,
          params: const <String, Object?>{'max': 500},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return Transfer(
      fromAccountId: c0 as int,
      toAccountId: c1 as int,
      amount: c2 as num,
      toAmount: c3 is Undefined ? null : c3 as num?,
      occurredOn: c4 as String,
      note: c5 is Undefined ? null : c5 as String?,
    );
  }

  @override
  Transfer fromMap(Map<String, dynamic> m) {
    return Transfer(
      fromAccountId: (m['fromAccountId'] as num).toInt(),
      toAccountId: (m['toAccountId'] as num).toInt(),
      amount: m['amount'] as num,
      toAmount: m['toAmount'] == null ? null : (m['toAmount'] as num),
      occurredOn: m['occurredOn'] as String,
      note: m['note'] == null ? null : (m['note'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(Transfer o) {
    int f0 = o.fromAccountId;
    int f1 = o.toAccountId;
    num f2 = o.amount;
    num? f3 = o.toAmount;
    String f4 = o.occurredOn;
    String? f5 = o.note;
    return <String, dynamic>{
      'fromAccountId': f0,
      'toAccountId': f1,
      'amount': f2,
      'toAmount': f3,
      'occurredOn': f4,
      'note': f5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'Transfer',
      'properties': <String, dynamic>{
        'fromAccountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet the money leaves (see list_wallets).',
        },
        'toAccountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet the money arrives in (see list_wallets).',
        },
        'amount': <String, dynamic>{
          'type': 'number',
          'minimum': 0.01,
          'maximum': 10000000,
          'description':
              'Amount leaving, in the currency of the source wallet.',
        },
        'toAmount': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': 0.01,
          'maximum': 10000000,
          'description': 'Amount arriving, in the currency of the target wallet. Only for wallets in different currencies. Defaults to amount.',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
      },
      'required': <dynamic>[
        'fromAccountId',
        'toAccountId',
        'amount',
        'occurredOn',
      ],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'occurredOn',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [AdjustBalance].
const DtoSchema<AdjustBalance> $AdjustBalanceDto = _$AdjustBalanceDto();

class _$AdjustBalanceDto extends DtoSchema<AdjustBalance> {
  const _$AdjustBalanceDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => AdjustBalance;

  @override
  String get name => 'AdjustBalance';

  @override
  AdjustBalance? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int?
    Object? c0;
    c0 = s.integer(
      s.read(input, 'accountId', emptyToNull: true),
      p,
      'accountId',
      _m,
    );
    // balance: num
    Object? c1;
    c1 = s.number(
      s.read(input, 'balance', emptyToNull: true),
      p,
      'balance',
      _m,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'balance', _m);
    // occurredOn: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'occurredOn', emptyToNull: true),
      p,
      'occurredOn',
      _m,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'occurredOn', _m);
    // note: String?
    Object? c3;
    c3 = s.string(
      s.read(input, 'note', emptyToNull: true),
      p,
      'note',
      _m,
      trim: true,
    );
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c0,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c1 is num) {
      if (!(c1 >= -10000000)) {
        s.fail(
          p,
          'balance',
          IssueCodes.min,
          DefaultMessages.min,
          c1,
          params: const <String, Object?>{'min': -10000000},
          messages: _m,
        );
      } else if (!(c1 <= 10000000)) {
        s.fail(
          p,
          'balance',
          IssueCodes.max,
          DefaultMessages.max,
          c1,
          params: const <String, Object?>{'max': 10000000},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c2, s.context(p, 'occurredOn', c2)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'occurredOn', c2, _m);
      }
    }
    if (c3 is String) {
      if (!(c3.runes.length <= 500)) {
        s.fail(
          p,
          'note',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c3,
          params: const <String, Object?>{'max': 500},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return AdjustBalance(
      accountId: c0 is Undefined ? null : c0 as int?,
      balance: c1 as num,
      occurredOn: c2 as String,
      note: c3 is Undefined ? null : c3 as String?,
    );
  }

  @override
  AdjustBalance fromMap(Map<String, dynamic> m) {
    return AdjustBalance(
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
      balance: m['balance'] as num,
      occurredOn: m['occurredOn'] as String,
      note: m['note'] == null ? null : (m['note'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(AdjustBalance o) {
    int? f0 = o.accountId;
    num f1 = o.balance;
    String f2 = o.occurredOn;
    String? f3 = o.note;
    return <String, dynamic>{
      'accountId': f0,
      'balance': f1,
      'occurredOn': f2,
      'note': f3,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'AdjustBalance',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'balance': <String, dynamic>{
          'type': 'number',
          'minimum': -10000000,
          'maximum': 10000000,
          'description': 'The balance it should have, in dollars. May be negative (credit cards). The difference is booked as one entry.',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note. Defaults to "Balance adjustment".',
        },
      },
      'required': <dynamic>['balance', 'occurredOn'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'occurredOn',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [SetDefaultAccount].
const DtoSchema<SetDefaultAccount> $SetDefaultAccountDto =
    _$SetDefaultAccountDto();

class _$SetDefaultAccountDto extends DtoSchema<SetDefaultAccount> {
  const _$SetDefaultAccountDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => SetDefaultAccount;

  @override
  String get name => 'SetDefaultAccount';

  @override
  bool get hasChecks => true;

  @override
  SetDefaultAccount? convert(Object? input, DtoState s, List<Object> p) {
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
    // accountId: Maybe<int?>
    Object? c1;
    c1 = s.integer(
      s.read(input, 'accountId', emptyToNull: true),
      p,
      'accountId',
      _m,
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
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return SetDefaultAccount(
      groupId: c0 is Undefined ? null : c0 as int?,
      accountId: c1 is Undefined
          ? const Maybe<int?>.missing()
          : Maybe<int?>(c1 as int?),
    );
  }

  @override
  void crossCheck(SetDefaultAccount o, DtoState s, List<Object> p) {
    o.validate(DtoErrors(s, p));
  }

  @override
  SetDefaultAccount fromMap(Map<String, dynamic> m) {
    return SetDefaultAccount(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      accountId: m.containsKey('accountId')
          ? Maybe<int?>(
              m['accountId'] == null ? null : ((m['accountId'] as num).toInt()),
            )
          : const Maybe<int?>.missing(),
    );
  }

  @override
  Map<String, dynamic> toMap(SetDefaultAccount o) {
    int? f0 = o.groupId;
    Maybe<int?> f1 = o.accountId;
    return <String, dynamic>{
      'groupId': f0,
      if (f1 case Maybe<int?>(isPresent: true, value: int? g1)) 'accountId': g1,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'SetDefaultAccount',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet that new expenses in this group are paid from (see list_wallets). Pass null to clear it.',
        },
      },
    };
  }
}

/// The checks, the converter and the JSON Schema of [PageQuery].
const DtoSchema<PageQuery> $PageQueryDto = _$PageQueryDto();

class _$PageQueryDto extends DtoSchema<PageQuery> {
  const _$PageQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => PageQuery;

  @override
  String get name => 'PageQuery';

  @override
  Source get source => Source.query;

  @override
  PageQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int?
    Object? c0;
    c0 = s.integer(s.read(input, 'accountId'), p, 'accountId', _m);
    // limit: num?
    Object? c1;
    int f1 = s.issues.length;
    c1 = s.number(s.read(input, 'limit'), p, 'limit', _m);
    if (s.dropIssuesAfter(f1)) c1 = undefined;
    // offset: num
    Object? c2;
    int f2 = s.issues.length;
    c2 = s.number(s.read(input, 'offset'), p, 'offset', _m);
    if (c2 == null) s.required(p, 'offset', _m);
    if (s.dropIssuesAfter(f2)) c2 = undefined;
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c0,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    int r1 = s.issues.length;
    if (c1 is num) {
      if (!(!const <num>{0}.contains(c1))) {
        s.fail(
          p,
          'limit',
          IssueCodes.notIn,
          DefaultMessages.notIn,
          c1,
          messages: _m,
        );
      }
    }
    if (s.dropIssuesAfter(r1)) c1 = undefined;
    if (s.issues.length != e) return null;
    return PageQuery(
      accountId: c0 is Undefined ? null : c0 as int?,
      limit: c1 is Undefined ? null : c1 as num?,
      offset: c2 is Undefined ? 0 : c2 as num,
    );
  }

  @override
  PageQuery fromMap(Map<String, dynamic> m) {
    return PageQuery(
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
      limit: m['limit'] == null ? null : (m['limit'] as num),
      offset: m.containsKey('offset') ? m['offset'] as num : 0,
    );
  }

  @override
  Map<String, dynamic> toMap(PageQuery o) {
    int? f0 = o.accountId;
    num? f1 = o.limit;
    num f2 = o.offset;
    return <String, dynamic>{'accountId': f0, 'limit': f1, 'offset': f2};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'PageQuery',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description':
              'Wallet ID, for list_wallet_entries (see list_wallets).',
        },
        'limit': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'not': <String, dynamic>{
            'enum': <dynamic>[0],
          },
          'description': 'How many entries, newest first. At most 500.',
        },
        'offset': <String, dynamic>{
          'type': 'number',
          'description': 'How many entries to skip. Defaults to 0.',
          'default': 0,
        },
      },
    };
  }
}

/// The checks, the converter and the JSON Schema of [HistoryQuery].
const DtoSchema<HistoryQuery> $HistoryQueryDto = _$HistoryQueryDto();

class _$HistoryQueryDto extends DtoSchema<HistoryQuery> {
  const _$HistoryQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => HistoryQuery;

  @override
  String get name => 'HistoryQuery';

  @override
  Source get source => Source.query;

  @override
  HistoryQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // days: num
    Object? c0;
    int f0 = s.issues.length;
    c0 = s.number(s.read(input, 'days'), p, 'days', _m);
    if (c0 == null) s.required(p, 'days', _m);
    if (s.dropIssuesAfter(f0)) c0 = undefined;
    if (s.issues.length != e) return null;
    int r0 = s.issues.length;
    if (c0 is num) {
      if (!(!const <num>{0}.contains(c0))) {
        s.fail(
          p,
          'days',
          IssueCodes.notIn,
          DefaultMessages.notIn,
          c0,
          messages: _m,
        );
      }
    }
    if (s.dropIssuesAfter(r0)) c0 = undefined;
    if (s.issues.length != e) return null;
    return HistoryQuery(
      days: c0 is Undefined ? balanceHistoryDefaultDays : c0 as num,
    );
  }

  @override
  HistoryQuery fromMap(Map<String, dynamic> m) {
    return HistoryQuery(
      days: m.containsKey('days')
          ? m['days'] as num
          : balanceHistoryDefaultDays,
    );
  }

  @override
  Map<String, dynamic> toMap(HistoryQuery o) {
    num f0 = o.days;
    return <String, dynamic>{'days': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'HistoryQuery',
      'properties': <String, dynamic>{
        'days': <String, dynamic>{
          'type': 'number',
          'not': <String, dynamic>{
            'enum': <dynamic>[0],
          },
          'description': 'How many days back, 1 to 365. Defaults to 30.',
          'default': 30,
        },
      },
    };
  }
}

/// The checks, the converter and the JSON Schema of [TotalQuery].
const DtoSchema<TotalQuery> $TotalQueryDto = _$TotalQueryDto();

class _$TotalQueryDto extends DtoSchema<TotalQuery> {
  const _$TotalQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => TotalQuery;

  @override
  String get name => 'TotalQuery';

  @override
  Source get source => Source.query;

  @override
  TotalQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // currency: String
    Object? c0;
    c0 = s.string(s.read(input, 'currency'), p, 'currency', _m);
    if (c0 == null) s.required(p, 'currency', _m);
    if (s.issues.length != e) return null;
    return TotalQuery(
      currency: c0 is Undefined ? defaultTotalCurrency : c0 as String,
    );
  }

  @override
  TotalQuery fromMap(Map<String, dynamic> m) {
    return TotalQuery(
      currency: m.containsKey('currency')
          ? m['currency'] as String
          : defaultTotalCurrency,
    );
  }

  @override
  Map<String, dynamic> toMap(TotalQuery o) {
    String f0 = o.currency;
    return <String, dynamic>{'currency': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'TotalQuery',
      'properties': <String, dynamic>{
        'currency': <String, dynamic>{
          'type': 'string',
          'description': 'Currency of the total. 3-letter currency code, e.g. "THB" or "USD". Defaults to THB.',
          'default': 'THB',
        },
      },
    };
  }
}

/// The checks, the converter and the JSON Schema of [FxQuery].
const DtoSchema<FxQuery> $FxQueryDto = _$FxQueryDto();

class _$FxQueryDto extends DtoSchema<FxQuery> {
  const _$FxQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => FxQuery;

  @override
  String get name => 'FxQuery';

  @override
  Source get source => Source.query;

  @override
  FxQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // base: String
    Object? c0;
    c0 = s.string(s.read(input, 'base'), p, 'base', _m);
    if (c0 == null) s.required(p, 'base', _m);
    if (s.issues.length != e) return null;
    return FxQuery(base: c0 is Undefined ? defaultFxBase : c0 as String);
  }

  @override
  FxQuery fromMap(Map<String, dynamic> m) {
    return FxQuery(
      base: m.containsKey('base') ? m['base'] as String : defaultFxBase,
    );
  }

  @override
  Map<String, dynamic> toMap(FxQuery o) {
    String f0 = o.base;
    return <String, dynamic>{'base': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'FxQuery',
      'properties': <String, dynamic>{
        'base': <String, dynamic>{
          'type': 'string',
          'description': 'Base currency of the rates. 3-letter currency code, e.g. "THB" or "USD". Defaults to USD.',
          'default': 'USD',
        },
      },
    };
  }
}

/// The checks, the converter and the JSON Schema of [AccountRef].
const DtoSchema<AccountRef> $AccountRefDto = _$AccountRefDto();

class _$AccountRefDto extends DtoSchema<AccountRef> {
  const _$AccountRefDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => AccountRef;

  @override
  String get name => 'AccountRef';

  @override
  AccountRef? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'accountId'), p, 'accountId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'accountId', _m);
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c0,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return AccountRef(accountId: c0 as int);
  }

  @override
  AccountRef fromMap(Map<String, dynamic> m) {
    return AccountRef(accountId: (m['accountId'] as num).toInt());
  }

  @override
  Map<String, dynamic> toMap(AccountRef o) {
    int f0 = o.accountId;
    return <String, dynamic>{'accountId': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'AccountRef',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
      },
      'required': <dynamic>['accountId'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [AccountMemberRef].
const DtoSchema<AccountMemberRef> $AccountMemberRefDto =
    _$AccountMemberRefDto();

class _$AccountMemberRefDto extends DtoSchema<AccountMemberRef> {
  const _$AccountMemberRefDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => AccountMemberRef;

  @override
  String get name => 'AccountMemberRef';

  @override
  AccountMemberRef? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'accountId'), p, 'accountId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'accountId', _m);
    // memberId: int
    Object? c1;
    c1 = s.integer(s.read(input, 'memberId'), p, 'memberId', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'memberId', _m);
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
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
          'memberId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return AccountMemberRef(accountId: c0 as int, memberId: c1 as int);
  }

  @override
  AccountMemberRef fromMap(Map<String, dynamic> m) {
    return AccountMemberRef(
      accountId: (m['accountId'] as num).toInt(),
      memberId: (m['memberId'] as num).toInt(),
    );
  }

  @override
  Map<String, dynamic> toMap(AccountMemberRef o) {
    int f0 = o.accountId;
    int f1 = o.memberId;
    return <String, dynamic>{'accountId': f0, 'memberId': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'AccountMemberRef',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'memberId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Member ID (see list_wallet_members).',
        },
      },
      'required': <dynamic>['accountId', 'memberId'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [EntryRef].
const DtoSchema<EntryRef> $EntryRefDto = _$EntryRefDto();

class _$EntryRefDto extends DtoSchema<EntryRef> {
  const _$EntryRefDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => EntryRef;

  @override
  String get name => 'EntryRef';

  @override
  EntryRef? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // accountId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'accountId'), p, 'accountId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'accountId', _m);
    // entryId: int
    Object? c1;
    c1 = s.integer(s.read(input, 'entryId'), p, 'entryId', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'entryId', _m);
    if (s.issues.length != e) return null;
    if (c0 is int) {
      if (!(c0 > 0)) {
        s.fail(
          p,
          'accountId',
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
          'entryId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return EntryRef(accountId: c0 as int, entryId: c1 as int);
  }

  @override
  EntryRef fromMap(Map<String, dynamic> m) {
    return EntryRef(
      accountId: (m['accountId'] as num).toInt(),
      entryId: (m['entryId'] as num).toInt(),
    );
  }

  @override
  Map<String, dynamic> toMap(EntryRef o) {
    int f0 = o.accountId;
    int f1 = o.entryId;
    return <String, dynamic>{'accountId': f0, 'entryId': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'EntryRef',
      'properties': <String, dynamic>{
        'accountId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Wallet ID (see list_wallets). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'entryId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Entry ID (see list_wallet_entries).',
        },
      },
      'required': <dynamic>['accountId', 'entryId'],
    };
  }
}
