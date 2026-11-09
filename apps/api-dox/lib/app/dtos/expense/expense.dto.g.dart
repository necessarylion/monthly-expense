// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CreateExpense].
const DtoSchema<CreateExpense> $CreateExpenseDto = _$CreateExpenseDto();

class _$CreateExpenseDto extends DtoSchema<CreateExpense> {
  const _$CreateExpenseDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => CreateExpense;

  @override
  String get name => 'CreateExpense';

  @override
  CreateExpense? convert(Object? input, DtoState s, List<Object> p) {
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
    // categoryId: int
    Object? c1;
    c1 = s.integer(
      s.read(input, 'categoryId', emptyToNull: true),
      p,
      'categoryId',
      _m,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'categoryId', _m);
    // amount: num
    Object? c2;
    c2 = s.number(s.read(input, 'amount', emptyToNull: true), p, 'amount', _m);
    if (c2 == null || c2 is Undefined) s.required(p, 'amount', _m);
    // occurredOn: String
    Object? c3;
    c3 = s.string(
      s.read(input, 'occurredOn', emptyToNull: true),
      p,
      'occurredOn',
      _m,
    );
    if (c3 == null || c3 is Undefined) s.required(p, 'occurredOn', _m);
    // note: String?
    Object? c4;
    c4 = s.string(
      s.read(input, 'note', emptyToNull: true),
      p,
      'note',
      _m,
      trim: true,
    );
    // accountId: Maybe<int?>
    Object? c5;
    c5 = s.integer(
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
          'categoryId',
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
    if (c5 is int) {
      if (!(c5 > 0)) {
        s.fail(
          p,
          'accountId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c5,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return CreateExpense(
      groupId: c0 is Undefined ? null : c0 as int?,
      categoryId: c1 as int,
      amount: c2 as num,
      occurredOn: c3 as String,
      note: c4 is Undefined ? null : c4 as String?,
      accountId: c5 is Undefined
          ? const Maybe<int?>.missing()
          : Maybe<int?>(c5 as int?),
    );
  }

  @override
  CreateExpense fromMap(Map<String, dynamic> m) {
    return CreateExpense(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      categoryId: (m['categoryId'] as num).toInt(),
      amount: m['amount'] as num,
      occurredOn: m['occurredOn'] as String,
      note: m['note'] == null ? null : (m['note'] as String),
      accountId: m.containsKey('accountId')
          ? Maybe<int?>(
              m['accountId'] == null ? null : ((m['accountId'] as num).toInt()),
            )
          : const Maybe<int?>.missing(),
    );
  }

  @override
  Map<String, dynamic> toMap(CreateExpense o) {
    int? f0 = o.groupId;
    int f1 = o.categoryId;
    num f2 = o.amount;
    String f3 = o.occurredOn;
    String? f4 = o.note;
    Maybe<int?> f5 = o.accountId;
    return <String, dynamic>{
      'groupId': f0,
      'categoryId': f1,
      'amount': f2,
      'occurredOn': f3,
      'note': f4,
      if (f5 case Maybe<int?>(isPresent: true, value: int? g5)) 'accountId': g5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'CreateExpense',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'categoryId': <String, dynamic>{
          'type': 'integer',
          'exclusiveMinimum': 0,
          'description': 'Category ID (see list_categories).',
        },
        'amount': <String, dynamic>{
          'type': 'number',
          'minimum': 0.01,
          'maximum': 10000000,
          'description': 'Amount in dollars (use a decimal, e.g. 12.50).',
        },
        'occurredOn': <String, dynamic>{
          'type': 'string',
          'description': 'Date the expense occurred, in YYYY-MM-DD.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet to pay from (see list_wallets). Leave it out to use your default wallet of the group. Pass null to record no wallet entry.',
        },
      },
      'required': <dynamic>['categoryId', 'amount', 'occurredOn'],
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'occurredOn',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [UpdateExpense].
const DtoSchema<UpdateExpense> $UpdateExpenseDto = _$UpdateExpenseDto();

class _$UpdateExpenseDto extends DtoSchema<UpdateExpense> {
  const _$UpdateExpenseDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => UpdateExpense;

  @override
  String get name => 'UpdateExpense';

  @override
  UpdateExpense? convert(Object? input, DtoState s, List<Object> p) {
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
    // categoryId: int?
    Object? c2;
    c2 = s.integer(
      s.read(input, 'categoryId', emptyToNull: true),
      p,
      'categoryId',
      _m,
    );
    // amount: num?
    Object? c3;
    c3 = s.number(s.read(input, 'amount', emptyToNull: true), p, 'amount', _m);
    // occurredOn: String?
    Object? c4;
    c4 = s.string(
      s.read(input, 'occurredOn', emptyToNull: true),
      p,
      'occurredOn',
      _m,
    );
    // note: Maybe<String?>
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
    if (c2 is int) {
      if (!(c2 > 0)) {
        s.fail(
          p,
          'categoryId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c2,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c3 is num) {
      if (!(c3 >= 0.01)) {
        s.fail(
          p,
          'amount',
          IssueCodes.min,
          DefaultMessages.min,
          c3,
          params: const <String, Object?>{'min': 0.01},
          messages: _m,
        );
      } else if (!(c3 <= 10000000)) {
        s.fail(
          p,
          'amount',
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
    return UpdateExpense(
      groupId: c0 is Undefined ? null : c0 as int?,
      id: c1 is Undefined ? null : c1 as int?,
      categoryId: c2 is Undefined ? null : c2 as int?,
      amount: c3 is Undefined ? null : c3 as num?,
      occurredOn: c4 is Undefined ? null : c4 as String?,
      note: c5 is Undefined
          ? const Maybe<String?>.missing()
          : Maybe<String?>(c5 as String?),
    );
  }

  @override
  UpdateExpense fromMap(Map<String, dynamic> m) {
    return UpdateExpense(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      id: m['id'] == null ? null : ((m['id'] as num).toInt()),
      categoryId: m['categoryId'] == null
          ? null
          : ((m['categoryId'] as num).toInt()),
      amount: m['amount'] == null ? null : (m['amount'] as num),
      occurredOn: m['occurredOn'] == null ? null : (m['occurredOn'] as String),
      note: m.containsKey('note')
          ? Maybe<String?>(m['note'] == null ? null : (m['note'] as String))
          : const Maybe<String?>.missing(),
    );
  }

  @override
  Map<String, dynamic> toMap(UpdateExpense o) {
    int? f0 = o.groupId;
    int? f1 = o.id;
    int? f2 = o.categoryId;
    num? f3 = o.amount;
    String? f4 = o.occurredOn;
    Maybe<String?> f5 = o.note;
    return <String, dynamic>{
      'groupId': f0,
      'id': f1,
      'categoryId': f2,
      'amount': f3,
      'occurredOn': f4,
      if (f5 case Maybe<String?>(isPresent: true, value: String? g5))
        'note': g5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'UpdateExpense',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'id': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Expense ID (see list_expenses). ID of the item (see the matching list tool). Needed by the MCP tools; HTTP takes it from the URL.',
        },
        'categoryId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'New category ID (see list_categories).',
        },
        'amount': <String, dynamic>{
          'type': <dynamic>['number', 'null'],
          'minimum': 0.01,
          'maximum': 10000000,
          'description': 'New amount in dollars.',
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

/// The checks, the converter and the JSON Schema of [MonthQuery].
const DtoSchema<MonthQuery> $MonthQueryDto = _$MonthQueryDto();

class _$MonthQueryDto extends DtoSchema<MonthQuery> {
  const _$MonthQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => MonthQuery;

  @override
  String get name => 'MonthQuery';

  @override
  Source get source => Source.query;

  @override
  MonthQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int?
    Object? c0;
    c0 = s.integer(s.read(input, 'groupId'), p, 'groupId', _m);
    // month: String?
    Object? c1;
    c1 = s.string(s.read(input, 'month'), p, 'month', _m);
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
      if (!(const DateFormatted('Y-m').check(c1, s.context(p, 'month', c1)))) {
        s.failRule(const DateFormatted('Y-m'), p, 'month', c1, _m);
      }
    }
    if (s.issues.length != e) return null;
    return MonthQuery(
      groupId: c0 is Undefined ? null : c0 as int?,
      month: c1 is Undefined ? null : c1 as String?,
    );
  }

  @override
  MonthQuery fromMap(Map<String, dynamic> m) {
    return MonthQuery(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      month: m['month'] == null ? null : (m['month'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(MonthQuery o) {
    int? f0 = o.groupId;
    String? f1 = o.month;
    return <String, dynamic>{'groupId': f0, 'month': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'MonthQuery',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'month': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description':
              'Month in YYYY-MM format. Defaults to the current month.',
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

/// The checks, the converter and the JSON Schema of [SearchQuery].
const DtoSchema<SearchQuery> $SearchQueryDto = _$SearchQueryDto();

class _$SearchQueryDto extends DtoSchema<SearchQuery> {
  const _$SearchQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => SearchQuery;

  @override
  String get name => 'SearchQuery';

  @override
  Source get source => Source.query;

  @override
  SearchQuery? convert(Object? input, DtoState s, List<Object> p) {
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
    // q: String?
    Object? c1;
    c1 = s.string(
      s.read(input, 'q', emptyToNull: true),
      p,
      'q',
      _m,
      trim: true,
    );
    // categoryId: int?
    Object? c2;
    c2 = s.integer(
      s.read(input, 'categoryId', emptyToNull: true),
      p,
      'categoryId',
      _m,
    );
    // from: String?
    Object? c3;
    c3 = s.string(s.read(input, 'from', emptyToNull: true), p, 'from', _m);
    // to: String?
    Object? c4;
    c4 = s.string(s.read(input, 'to', emptyToNull: true), p, 'to', _m);
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
      if (!(c1.runes.length <= 100)) {
        s.fail(
          p,
          'q',
          IssueCodes.maxLength,
          DefaultMessages.maxLength,
          c1,
          params: const <String, Object?>{'max': 100},
          messages: _m,
        );
      }
    }
    if (c2 is int) {
      if (!(c2 > 0)) {
        s.fail(
          p,
          'categoryId',
          IssueCodes.greaterThan,
          DefaultMessages.greaterThan,
          c2,
          params: const <String, Object?>{'min': 0},
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(const DateFormatted('Y-m-d').check(c3, s.context(p, 'from', c3)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'from', c3, _m);
      }
    }
    if (c4 is String) {
      if (!(const DateFormatted('Y-m-d').check(c4, s.context(p, 'to', c4)))) {
        s.failRule(const DateFormatted('Y-m-d'), p, 'to', c4, _m);
      }
    }
    if (s.issues.length != e) return null;
    return SearchQuery(
      groupId: c0 is Undefined ? null : c0 as int?,
      q: c1 is Undefined ? null : c1 as String?,
      categoryId: c2 is Undefined ? null : c2 as int?,
      from: c3 is Undefined ? null : c3 as String?,
      to: c4 is Undefined ? null : c4 as String?,
    );
  }

  @override
  SearchQuery fromMap(Map<String, dynamic> m) {
    return SearchQuery(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      q: m['q'] == null ? null : (m['q'] as String),
      categoryId: m['categoryId'] == null
          ? null
          : ((m['categoryId'] as num).toInt()),
      from: m['from'] == null ? null : (m['from'] as String),
      to: m['to'] == null ? null : (m['to'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(SearchQuery o) {
    int? f0 = o.groupId;
    String? f1 = o.q;
    int? f2 = o.categoryId;
    String? f3 = o.from;
    String? f4 = o.to;
    return <String, dynamic>{
      'groupId': f0,
      'q': f1,
      'categoryId': f2,
      'from': f3,
      'to': f4,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    Map<String, dynamic> j = <String, dynamic>{
      'type': 'object',
      'title': 'SearchQuery',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'q': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 100,
          'description': 'Text to find in the note or the category name.',
        },
        'categoryId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Only this category ID (see list_categories).',
        },
        'from': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'First date, YYYY-MM-DD.',
        },
        'to': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'description': 'Last date, YYYY-MM-DD.',
        },
      },
    };
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'from',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    JsonSchemaTools.merge(j, <String>[
      'properties',
      'to',
    ], const DateFormatted('Y-m-d').toJsonSchema());
    return j;
  }
}

/// The checks, the converter and the JSON Schema of [YearQuery].
const DtoSchema<YearQuery> $YearQueryDto = _$YearQueryDto();

class _$YearQueryDto extends DtoSchema<YearQuery> {
  const _$YearQueryDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => YearQuery;

  @override
  String get name => 'YearQuery';

  @override
  Source get source => Source.query;

  @override
  YearQuery? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // groupId: int?
    Object? c0;
    c0 = s.integer(s.read(input, 'groupId'), p, 'groupId', _m);
    // year: int?
    Object? c1;
    c1 = s.integer(s.read(input, 'year'), p, 'year', _m);
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
      if (!(c1 >= 2000)) {
        s.fail(
          p,
          'year',
          IssueCodes.min,
          DefaultMessages.min,
          c1,
          params: const <String, Object?>{'min': 2000},
          messages: _m,
        );
      } else if (!(c1 <= 2100)) {
        s.fail(
          p,
          'year',
          IssueCodes.max,
          DefaultMessages.max,
          c1,
          params: const <String, Object?>{'max': 2100},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return YearQuery(
      groupId: c0 is Undefined ? null : c0 as int?,
      year: c1 is Undefined ? null : c1 as int?,
    );
  }

  @override
  YearQuery fromMap(Map<String, dynamic> m) {
    return YearQuery(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      year: m['year'] == null ? null : ((m['year'] as num).toInt()),
    );
  }

  @override
  Map<String, dynamic> toMap(YearQuery o) {
    int? f0 = o.groupId;
    int? f1 = o.year;
    return <String, dynamic>{'groupId': f0, 'year': f1};
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'YearQuery',
      'properties': <String, dynamic>{
        'groupId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
        },
        'year': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'minimum': 2000,
          'maximum': 2100,
          'description': 'Year, like 2026. Defaults to this year.',
        },
      },
    };
  }
}
