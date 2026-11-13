// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CreateGroup].
const DtoSchema<CreateGroup> $CreateGroupDto = _$CreateGroupDto();

class _$CreateGroupDto extends DtoSchema<CreateGroup> {
  const _$CreateGroupDto();

  static const Map<String, String> _m = <String, String>{};

  static final RegExp _r0 = RegExp('^(?:[A-Z]{3})\$');

  @override
  Type get type => CreateGroup;

  @override
  String get name => 'CreateGroup';

  @override
  bool get usesRequiredWhen => false;

  @override
  CreateGroup? convert(Object? input, DtoState s, List<Object> p) {
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
    // currency: String?
    Object? c1;
    c1 = s.string(
      s.read(input, 'currency', emptyToNull: true),
      p,
      'currency',
      _m,
      trim: true,
      textCase: 2,
    );
    // kind: String?
    Object? c2;
    c2 = s.string(s.read(input, 'kind', emptyToNull: true), p, 'kind', _m);
    // tripStart: String?
    Object? c3;
    c3 = s.string(
      s.read(input, 'tripStart', emptyToNull: true),
      p,
      'tripStart',
      _m,
    );
    // tripDays: int?
    Object? c4;
    c4 = s.integer(
      s.read(input, 'tripDays', emptyToNull: true),
      p,
      'tripDays',
      _m,
    );
    if (s.issues.length != e && !s.allErrors) return null;
    if (c0 is String) {
      if (!(c0.runes.length >= 1 && c0.runes.length <= 80)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c0,
          params: const <String, Object?>{'min': 1, 'max': 80},
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
      if (!(const <String>{'monthly', 'trip'}.contains(c2))) {
        s.fail(
          p,
          'kind',
          IssueCodes.inList,
          DefaultMessages.inList,
          c2,
          params: const <String, Object?>{'values': 'monthly, and trip'},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c3, s.context(p, 'tripStart', c3)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'tripStart', c3, _m);
      }
    }
    if (c4 is int) {
      if (!(c4 >= 1)) {
        s.fail(
          p,
          'tripDays',
          IssueCodes.min,
          DefaultMessages.min,
          c4,
          params: const <String, Object?>{'min': 1},
          messages: _m,
        );
      } else if (!(c4 <= 366)) {
        s.fail(
          p,
          'tripDays',
          IssueCodes.max,
          DefaultMessages.max,
          c4,
          params: const <String, Object?>{'max': 366},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return CreateGroup(
      name: c0 as String,
      currency: c1 is Undefined ? null : c1 as String?,
      kind: c2 is Undefined ? null : c2 as String?,
      tripStart: c3 is Undefined ? null : c3 as String?,
      tripDays: c4 is Undefined ? null : c4 as int?,
    );
  }

  @override
  CreateGroup fromMap(Map<String, dynamic> m) {
    return CreateGroup(
      name: m['name'] as String,
      currency: m['currency'] == null ? null : (m['currency'] as String),
      kind: m['kind'] == null ? null : (m['kind'] as String),
      tripStart: m['tripStart'] == null ? null : (m['tripStart'] as String),
      tripDays: m['tripDays'] == null ? null : ((m['tripDays'] as num).toInt()),
    );
  }

  @override
  Map<String, dynamic> toMap(CreateGroup o) {
    String f0 = o.name;
    String? f1 = o.currency;
    String? f2 = o.kind;
    String? f3 = o.tripStart;
    int? f4 = o.tripDays;
    return <String, dynamic>{
      'name': f0,
      'currency': f1,
      'kind': f2,
      'tripStart': f3,
      'tripDays': f4,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'CreateGroup',
      'properties': <String, dynamic>{
        'name': <String, dynamic>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 80,
          'description': 'Group name, e.g. "Family".',
        },
        'currency': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'pattern': '^(?:[A-Z]{3})\$',
          'description':
              '3-letter currency code, e.g. "THB" or "USD". Defaults to THB.',
        },
        'kind': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'enum': <dynamic>['monthly', 'trip'],
          'description': '"monthly" (budget and totals per month) or "trip" (one budget, no months: every expense counts, for a one-time event).',
        },
        'tripStart': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description':
              'Trip only: the first day, YYYY-MM-DD. Defaults to today.',
        },
        'tripDays': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'minimum': 1,
          'maximum': 366,
          'description': 'Trip only: how many days the trip lasts.',
        },
      },
      'required': <dynamic>['name'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'tripStart',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [UpdateGroup].
const DtoSchema<UpdateGroup> $UpdateGroupDto = _$UpdateGroupDto();

class _$UpdateGroupDto extends DtoSchema<UpdateGroup> {
  const _$UpdateGroupDto();

  static const Map<String, String> _m = <String, String>{};

  static final RegExp _r0 = RegExp('^(?:[A-Z]{3})\$');

  @override
  Type get type => UpdateGroup;

  @override
  String get name => 'UpdateGroup';

  @override
  bool get usesRequiredWhen => false;

  @override
  UpdateGroup? convert(Object? input, DtoState s, List<Object> p) {
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
    // splitEnabled: bool?
    Object? c3;
    c3 = s.boolean(
      s.read(input, 'splitEnabled', emptyToNull: true),
      p,
      'splitEnabled',
      _m,
    );
    // kind: String?
    Object? c4;
    c4 = s.string(s.read(input, 'kind', emptyToNull: true), p, 'kind', _m);
    // tripStart: String?
    Object? c5;
    c5 = s.string(
      s.read(input, 'tripStart', emptyToNull: true),
      p,
      'tripStart',
      _m,
    );
    // tripDays: int?
    Object? c6;
    c6 = s.integer(
      s.read(input, 'tripDays', emptyToNull: true),
      p,
      'tripDays',
      _m,
    );
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
      if (!(c1.runes.length >= 1 && c1.runes.length <= 80)) {
        s.fail(
          p,
          'name',
          IssueCodes.lengthBetween,
          DefaultMessages.lengthBetween,
          c1,
          params: const <String, Object?>{'min': 1, 'max': 80},
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
    if (c4 is String) {
      if (!(const <String>{'monthly', 'trip'}.contains(c4))) {
        s.fail(
          p,
          'kind',
          IssueCodes.inList,
          DefaultMessages.inList,
          c4,
          params: const <String, Object?>{'values': 'monthly, and trip'},
          messages: _m,
        );
      }
    }
    if (c5 is String) {
      if (!(const DateFormatted('Y-m-d')
          .check(c5, s.context(p, 'tripStart', c5)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'tripStart', c5, _m);
      }
    }
    if (c6 is int) {
      if (!(c6 >= 1)) {
        s.fail(
          p,
          'tripDays',
          IssueCodes.min,
          DefaultMessages.min,
          c6,
          params: const <String, Object?>{'min': 1},
          messages: _m,
        );
      } else if (!(c6 <= 366)) {
        s.fail(
          p,
          'tripDays',
          IssueCodes.max,
          DefaultMessages.max,
          c6,
          params: const <String, Object?>{'max': 366},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return UpdateGroup(
      groupId: c0 is Undefined ? null : c0 as int?,
      name: c1 is Undefined ? null : c1 as String?,
      currency: c2 is Undefined ? null : c2 as String?,
      splitEnabled: c3 is Undefined ? null : c3 as bool?,
      kind: c4 is Undefined ? null : c4 as String?,
      tripStart: c5 is Undefined ? null : c5 as String?,
      tripDays: c6 is Undefined ? null : c6 as int?,
    );
  }

  @override
  UpdateGroup fromMap(Map<String, dynamic> m) {
    return UpdateGroup(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      name: m['name'] == null ? null : (m['name'] as String),
      currency: m['currency'] == null ? null : (m['currency'] as String),
      splitEnabled: m['splitEnabled'] == null
          ? null
          : (m['splitEnabled'] as bool),
      kind: m['kind'] == null ? null : (m['kind'] as String),
      tripStart: m['tripStart'] == null ? null : (m['tripStart'] as String),
      tripDays: m['tripDays'] == null ? null : ((m['tripDays'] as num).toInt()),
    );
  }

  @override
  Map<String, dynamic> toMap(UpdateGroup o) {
    int? f0 = o.groupId;
    String? f1 = o.name;
    String? f2 = o.currency;
    bool? f3 = o.splitEnabled;
    String? f4 = o.kind;
    String? f5 = o.tripStart;
    int? f6 = o.tripDays;
    return <String, dynamic>{
      'groupId': f0,
      'name': f1,
      'currency': f2,
      'splitEnabled': f3,
      'kind': f4,
      'tripStart': f5,
      'tripDays': f6,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'UpdateGroup',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'name': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'minLength': 1,
          'maxLength': 80,
          'description': 'New group name.',
        },
        'currency': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'pattern': '^(?:[A-Z]{3})\$',
          'description':
              'New currency. 3-letter currency code, e.g. "THB" or "USD".',
        },
        'splitEnabled': <String, dynamic>{
          'type': <dynamic>['boolean', 'null'],
          'description': 'Turn on to split costs: each expense has a payer, and the members settle up each month.',
        },
        'kind': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'enum': <dynamic>['monthly', 'trip'],
          'description': '"monthly" (budget and totals per month) or "trip" (one budget, no months: every expense counts, for a one-time event).',
        },
        'tripStart': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description':
              'Trip only: the first day, YYYY-MM-DD. Defaults to today.',
        },
        'tripDays': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'minimum': 1,
          'maximum': 366,
          'description': 'Trip only: how many days the trip lasts.',
        },
      },
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'tripStart',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [SetBudget].
const DtoSchema<SetBudget> $SetBudgetDto = _$SetBudgetDto();

class _$SetBudgetDto extends DtoSchema<SetBudget> {
  const _$SetBudgetDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => SetBudget;

  @override
  String get name => 'SetBudget';

  @override
  bool get hasChecks => true;

  @override
  bool get usesRequiredWhen => false;

  @override
  SetBudget? convert(Object? input, DtoState s, List<Object> p) {
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
    // month: String
    Object? c1;
    c1 = s.string(
      s.read(input, 'month', emptyToNull: true),
      p,
      'month',
      _m,
      trim: true,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'month', _m);
    // budget: Maybe<num?>
    Object? c2;
    c2 = s.number(s.read(input, 'budget', emptyToNull: true), p, 'budget', _m);
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
      if (!(const DateFormatted('Y-m').check(c1, s.context(p, 'month', c1)))) {
        s.failRule(const DateFormatted('Y-m'), p, 'month', c1, _m);
      }
    }
    if (c2 is num) {
      if (!(c2 >= 0)) {
        s.fail(
          p,
          'budget',
          IssueCodes.min,
          DefaultMessages.min,
          c2,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      } else if (!(c2 <= 1000000000)) {
        s.fail(
          p,
          'budget',
          IssueCodes.max,
          DefaultMessages.max,
          c2,
          params: const <String, Object?>{'max': 1000000000},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return SetBudget(
      groupId: c0 is Undefined ? null : c0 as int?,
      month: c1 as String,
      budget: c2 is Undefined
          ? const Maybe<num?>.missing()
          : Maybe<num?>(c2 as num?),
    );
  }

  @override
  void crossCheck(SetBudget o, DtoState s, List<Object> p) {
    o.validate(DtoErrors(s, p));
  }

  @override
  SetBudget fromMap(Map<String, dynamic> m) {
    return SetBudget(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      month: m['month'] as String,
      budget: m.containsKey('budget')
          ? Maybe<num?>(m['budget'] == null ? null : (m['budget'] as num))
          : const Maybe<num?>.missing(),
    );
  }

  @override
  Map<String, dynamic> toMap(SetBudget o) {
    int? f0 = o.groupId;
    String f1 = o.month;
    Maybe<num?> f2 = o.budget;
    return <String, dynamic>{
      'groupId': f0,
      'month': f1,
      if (f2 case Maybe<num?>(isPresent: true, value: num? g2)) 'budget': g2,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'SetBudget',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'month': <String, dynamic>{
          'type': 'string',
          'description': 'Month in YYYY-MM format.',
        },
        'budget': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': 0,
          'maximum': 1000000000,
          'description': 'Monthly budget in dollars. Pass null to clear the budget of this month, so the one before carries forward again.',
        },
      },
      'required': <dynamic>['month'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'month',
    ], const DateFormatted('Y-m').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [Invite].
const DtoSchema<Invite> $InviteDto = _$InviteDto();

class _$InviteDto extends DtoSchema<Invite> {
  const _$InviteDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => Invite;

  @override
  String get name => 'Invite';

  @override
  bool get usesRequiredWhen => false;

  @override
  Invite? convert(Object? input, DtoState s, List<Object> p) {
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
    // accountId: int?
    Object? c1;
    c1 = s.integer(
      s.read(input, 'accountId', emptyToNull: true),
      p,
      'accountId',
      _m,
    );
    // email: String
    Object? c2;
    c2 = s.string(
      s.read(input, 'email', emptyToNull: true),
      p,
      'email',
      _m,
      trim: true,
      textCase: 1,
    );
    if (c2 == null || c2 is Undefined) s.required(p, 'email', _m);
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
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c1,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c2 is String) {
      if (!(Patterns.email.hasMatch(c2))) {
        s.fail(
          p,
          'email',
          IssueCodes.email,
          DefaultMessages.email,
          c2,
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return Invite(
      groupId: c0 is Undefined ? null : c0 as int?,
      accountId: c1 is Undefined ? null : c1 as int?,
      email: c2 as String,
    );
  }

  @override
  Invite fromMap(Map<String, dynamic> m) {
    return Invite(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
      email: m['email'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap(Invite o) {
    int? f0 = o.groupId;
    int? f1 = o.accountId;
    String f2 = o.email;
    return <String, dynamic>{'groupId': f0, 'accountId': f1, 'email': f2};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'Invite',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID, for invite_group_member (see list_groups).',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description':
              'Wallet ID, for invite_wallet_member (see list_wallets).',
        },
        'email': <String, dynamic>{
          'type': 'string',
          'format': 'email',
          'description':
              'Gmail address of the person. They join when they next sign in.',
        },
      },
      'required': <dynamic>['email'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [NoInput].
const DtoSchema<NoInput> $NoInputDto = _$NoInputDto();

class _$NoInputDto extends DtoSchema<NoInput> {
  const _$NoInputDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => NoInput;

  @override
  String get name => 'NoInput';

  @override
  bool get usesRequiredWhen => false;

  @override
  NoInput? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    if (s.issues.length != e && !s.allErrors) return null;
    if (s.issues.length != e) return null;
    return NoInput();
  }

  @override
  NoInput fromMap(Map<String, dynamic> m) {
    return NoInput();
  }

  @override
  Map<String, dynamic> toMap(NoInput o) {
    return <String, dynamic>{};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'NoInput',
      'properties': <String, dynamic>{},
    };
  }
}

/// The checks, the converter and the JSON Schema of [GroupRef].
const DtoSchema<GroupRef> $GroupRefDto = _$GroupRefDto();

class _$GroupRefDto extends DtoSchema<GroupRef> {
  const _$GroupRefDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => GroupRef;

  @override
  String get name => 'GroupRef';

  @override
  bool get usesRequiredWhen => false;

  @override
  GroupRef? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'groupId'), p, 'groupId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'groupId', _m);
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
    if (s.issues.length != e) return null;
    return GroupRef(groupId: c0 as int);
  }

  @override
  GroupRef fromMap(Map<String, dynamic> m) {
    return GroupRef(groupId: (m['groupId'] as num).toInt());
  }

  @override
  Map<String, dynamic> toMap(GroupRef o) {
    int f0 = o.groupId;
    return <String, dynamic>{'groupId': f0};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'GroupRef',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
      },
      'required': <dynamic>['groupId'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [GroupItemRef].
const DtoSchema<GroupItemRef> $GroupItemRefDto = _$GroupItemRefDto();

class _$GroupItemRefDto extends DtoSchema<GroupItemRef> {
  const _$GroupItemRefDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => GroupItemRef;

  @override
  String get name => 'GroupItemRef';

  @override
  bool get usesRequiredWhen => false;

  @override
  GroupItemRef? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'groupId'), p, 'groupId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'groupId', _m);
    // id: int
    Object? c1;
    c1 = s.integer(s.read(input, 'id'), p, 'id', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'id', _m);
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
    if (s.issues.length != e) return null;
    return GroupItemRef(groupId: c0 as int, id: c1 as int);
  }

  @override
  GroupItemRef fromMap(Map<String, dynamic> m) {
    return GroupItemRef(
      groupId: (m['groupId'] as num).toInt(),
      id: (m['id'] as num).toInt(),
    );
  }

  @override
  Map<String, dynamic> toMap(GroupItemRef o) {
    int f0 = o.groupId;
    int f1 = o.id;
    return <String, dynamic>{'groupId': f0, 'id': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'GroupItemRef',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
      },
      'required': <dynamic>['groupId', 'id'],
    };
  }
}

/// The checks, the converter and the JSON Schema of [GroupMemberRef].
const DtoSchema<GroupMemberRef> $GroupMemberRefDto = _$GroupMemberRefDto();

class _$GroupMemberRefDto extends DtoSchema<GroupMemberRef> {
  const _$GroupMemberRefDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => GroupMemberRef;

  @override
  String get name => 'GroupMemberRef';

  @override
  bool get usesRequiredWhen => false;

  @override
  GroupMemberRef? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int
    Object? c0;
    c0 = s.integer(s.read(input, 'groupId'), p, 'groupId', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'groupId', _m);
    // memberId: int
    Object? c1;
    c1 = s.integer(s.read(input, 'memberId'), p, 'memberId', _m);
    if (c1 == null || c1 is Undefined) s.required(p, 'memberId', _m);
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
    return GroupMemberRef(groupId: c0 as int, memberId: c1 as int);
  }

  @override
  GroupMemberRef fromMap(Map<String, dynamic> m) {
    return GroupMemberRef(
      groupId: (m['groupId'] as num).toInt(),
      memberId: (m['memberId'] as num).toInt(),
    );
  }

  @override
  Map<String, dynamic> toMap(GroupMemberRef o) {
    int f0 = o.groupId;
    int f1 = o.memberId;
    return <String, dynamic>{'groupId': f0, 'memberId': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'GroupMemberRef',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'memberId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Member ID (see list_group_members).',
        },
      },
      'required': <dynamic>['groupId', 'memberId'],
    };
  }
}
