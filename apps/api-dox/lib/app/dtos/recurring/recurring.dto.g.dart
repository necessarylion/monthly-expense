// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring.dto.dart';

// **************************************************************************
// DoxDtoGenerator
// **************************************************************************

// ignore_for_file: type=lint

/// The checks, the converter and the JSON Schema of [CreateRecurring].
const DtoSchema<CreateRecurring> $CreateRecurringDto = _$CreateRecurringDto();

class _$CreateRecurringDto extends DtoSchema<CreateRecurring> {
  const _$CreateRecurringDto();

  static const Map<String, String> _m = <String, String>{};

  @override
  Type get type => CreateRecurring;

  @override
  String get name => 'CreateRecurring';

  @override
  CreateRecurring? convert(Object? input, DtoState s, List<Object> p) {
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
    // dayOfMonth: int
    Object? c3;
    c3 = s.integer(
      s.read(input, 'dayOfMonth', emptyToNull: true),
      p,
      'dayOfMonth',
      _m,
    );
    if (c3 == null || c3 is Undefined) s.required(p, 'dayOfMonth', _m);
    // note: String?
    Object? c4;
    c4 = s.string(
      s.read(input, 'note', emptyToNull: true),
      p,
      'note',
      _m,
      trim: true,
    );
    // accountId: int?
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
    if (c3 is int) {
      if (!(c3 >= 1)) {
        s.fail(
          p,
          'dayOfMonth',
          IssueCodes.min,
          DefaultMessages.min,
          c3,
          params: const <String, Object?>{'min': 1},
          messages: _m,
        );
      } else if (!(c3 <= 31)) {
        s.fail(
          p,
          'dayOfMonth',
          IssueCodes.max,
          DefaultMessages.max,
          c3,
          params: const <String, Object?>{'max': 31},
          messages: _m,
        );
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
    return CreateRecurring(
      groupId: c0 is Undefined ? null : c0 as int?,
      categoryId: c1 as int,
      amount: c2 as num,
      dayOfMonth: c3 as int,
      note: c4 is Undefined ? null : c4 as String?,
      accountId: c5 is Undefined ? null : c5 as int?,
    );
  }

  @override
  CreateRecurring fromMap(Map<String, dynamic> m) {
    return CreateRecurring(
      groupId: m['groupId'] == null ? null : ((m['groupId'] as num).toInt()),
      categoryId: (m['categoryId'] as num).toInt(),
      amount: m['amount'] as num,
      dayOfMonth: (m['dayOfMonth'] as num).toInt(),
      note: m['note'] == null ? null : (m['note'] as String),
      accountId: m['accountId'] == null
          ? null
          : ((m['accountId'] as num).toInt()),
    );
  }

  @override
  Map<String, dynamic> toMap(CreateRecurring o) {
    int? f0 = o.groupId;
    int f1 = o.categoryId;
    num f2 = o.amount;
    int f3 = o.dayOfMonth;
    String? f4 = o.note;
    int? f5 = o.accountId;
    return <String, dynamic>{
      'groupId': f0,
      'categoryId': f1,
      'amount': f2,
      'dayOfMonth': f3,
      'note': f4,
      'accountId': f5,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'CreateRecurring',
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
        'dayOfMonth': <String, dynamic>{
          'type': 'integer',
          'minimum': 1,
          'maximum': 31,
          'description': 'Day of the month it is added, 1 to 31. A short month uses its last day.',
        },
        'note': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'maxLength': 500,
          'description': 'Optional note.',
        },
        'accountId': <String, dynamic>{
          'type': <dynamic>['integer', 'null'],
          'exclusiveMinimum': 0,
          'description': 'Wallet to pay from (see list_wallets). Leave it out to use your default wallet when it runs.',
        },
      },
      'required': <dynamic>['categoryId', 'amount', 'dayOfMonth'],
    };
  }
}
