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
    // lang: String?
    Object? c2;
    c2 = s.string(s.read(input, 'lang'), p, 'lang', _m);
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
    if (c2 is String) {
      if (!(const <String>{'en', 'my'}.contains(c2))) {
        s.fail(
          p,
          'lang',
          IssueCodes.inList,
          DefaultMessages.inList,
          c2,
          params: const <String, Object?>{'values': 'en, and my'},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return SmartAddText(
      text: c0 as String,
      today: c1 as String,
      lang: c2 is Undefined ? null : c2 as String?,
    );
  }

  @override
  SmartAddText fromMap(Map<String, dynamic> m) {
    return SmartAddText(
      text: m['text'] as String,
      today: m['today'] as String,
      lang: m['lang'] == null ? null : (m['lang'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(SmartAddText o) {
    String f0 = o.text;
    String f1 = o.today;
    String? f2 = o.lang;
    return <String, dynamic>{'text': f0, 'today': f1, 'lang': f2};
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
        'lang': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'enum': <dynamic>['en', 'my'],
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

/// The checks, the converter and the JSON Schema of [SmartAddAction].
const DtoSchema<SmartAddAction> $SmartAddActionDto = _$SmartAddActionDto();

class _$SmartAddActionDto extends DtoSchema<SmartAddAction> {
  const _$SmartAddActionDto();

  static const Map<String, String> _m = <String, String>{};

  static final RegExp _r0 = RegExp('^(?:^save_[0-9]{1,2}\$)\$');

  @override
  Type get type => SmartAddAction;

  @override
  String get name => 'SmartAddAction';

  @override
  bool get usesRequiredWhen => false;

  @override
  SmartAddAction? convert(Object? input, DtoState s, List<Object> p) {
    if (input is! Map) {
      s.notObject(input, p, _m);
      return null;
    }
    int e = s.issues.length;
    // name: String
    Object? c0;
    c0 = s.string(s.read(input, 'name'), p, 'name', _m);
    if (c0 == null || c0 is Undefined) s.required(p, 'name', _m);
    // sourceComponentId: String
    Object? c1;
    c1 = s.string(
      s.read(input, 'sourceComponentId'),
      p,
      'sourceComponentId',
      _m,
    );
    if (c1 == null || c1 is Undefined) s.required(p, 'sourceComponentId', _m);
    // context: CreateExpense
    Object? c2;
    c2 = s.object(s.read(input, 'context'), p, 'context', _m);
    if (c2 is Map) {
      c2 =
          $CreateExpenseDto.convert(c2, s, <Object>[...p, 'context']) ??
          invalid;
    }
    if (c2 == null || c2 is Undefined) s.required(p, 'context', _m);
    // lang: String?
    Object? c3;
    c3 = s.string(s.read(input, 'lang'), p, 'lang', _m);
    if (s.issues.length != e && !s.allErrors) return null;
    if (c0 is String) {
      if (!(const <String>{'save_expense'}.contains(c0))) {
        s.fail(
          p,
          'name',
          IssueCodes.inList,
          DefaultMessages.inList,
          c0,
          params: const <String, Object?>{'values': 'save_expense'},
          messages: _m,
        );
      }
    }
    if (c1 is String) {
      if (!(_r0.hasMatch(c1))) {
        s.fail(
          p,
          'sourceComponentId',
          IssueCodes.regex,
          DefaultMessages.regex,
          c1,
          message: 'Unknown button',
          messages: _m,
        );
      }
    }
    if (c3 is String) {
      if (!(const <String>{'en', 'my'}.contains(c3))) {
        s.fail(
          p,
          'lang',
          IssueCodes.inList,
          DefaultMessages.inList,
          c3,
          params: const <String, Object?>{'values': 'en, and my'},
          messages: _m,
        );
      }
    }
    if (s.issues.length != e) return null;
    return SmartAddAction(
      name: c0 as String,
      sourceComponentId: c1 as String,
      context: c2 as CreateExpense,
      lang: c3 is Undefined ? null : c3 as String?,
    );
  }

  @override
  SmartAddAction fromMap(Map<String, dynamic> m) {
    return SmartAddAction(
      name: m['name'] as String,
      sourceComponentId: m['sourceComponentId'] as String,
      context: $CreateExpenseDto.fromMap(m['context'] as Map<String, dynamic>),
      lang: m['lang'] == null ? null : (m['lang'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap(SmartAddAction o) {
    String f0 = o.name;
    String f1 = o.sourceComponentId;
    CreateExpense f2 = o.context;
    String? f3 = o.lang;
    return <String, dynamic>{
      'name': f0,
      'sourceComponentId': f1,
      'context': $CreateExpenseDto.toMap(f2),
      'lang': f3,
    };
  }

  @override
  Map<String, dynamic> toJsonSchema() {
    return <String, dynamic>{
      'type': 'object',
      'title': 'SmartAddAction',
      'properties': <String, dynamic>{
        'name': <String, dynamic>{
          'type': 'string',
          'enum': <dynamic>['save_expense'],
        },
        'sourceComponentId': <String, dynamic>{
          'type': 'string',
          'pattern': '^(?:^save_[0-9]{1,2}\$)\$',
        },
        'context': <String, dynamic>{'\$ref': '#/\$defs/CreateExpense'},
        'lang': <String, dynamic>{
          'type': <dynamic>['string', 'null'],
          'enum': <dynamic>['en', 'my'],
        },
      },
      'required': <dynamic>['name', 'sourceComponentId', 'context'],
      '\$defs': <String, dynamic>{
        'CreateExpense': <String, dynamic>{
          'type': 'object',
          'title': 'CreateExpense',
          'properties': <String, dynamic>{
            'groupId': <String, dynamic>{
              'type': <dynamic>['integer', 'null'],
              'exclusiveMinimum': 0,
              'description': 'Group ID (see list_groups). Needed by the MCP tools; HTTP uses the X-Group-Id header.',
            },
            'categoryId': <String, dynamic>{
              'type': <dynamic>['integer', 'null'],
              'exclusiveMinimum': 0,
              'description': 'Category ID (see list_categories). Leave it out to have it picked from the note; the note is then required.',
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
              'description': 'What the money was for. Required when categoryId is left out.',
            },
            'accountId': <String, dynamic>{
              'type': <dynamic>['integer', 'null'],
              'exclusiveMinimum': 0,
              'description': 'Wallet to pay from (see list_wallets). Leave it out to use your default wallet of the group. Pass null to record no wallet entry.',
            },
          },
          'required': <dynamic>['amount', 'occurredOn'],
        },
      },
    };
  }
}
