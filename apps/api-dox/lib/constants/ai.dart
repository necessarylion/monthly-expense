/// Claude (Anthropic Messages API). Picks expense categories and cleans up
/// the quick-add list.
const String claudeMessagesUrl = 'https://api.anthropic.com/v1/messages';
const String claudeApiVersion = '2026-10-21';

/// A declined request runs again on the model Anthropic picks.
const String claudeFallbackBeta = 'server-side-fallback-2026-07-01';

/// Claude must answer in this time. Home waits for it.
const Duration claudeTimeout = Duration(seconds: 20);

/// After Claude fails, show the plain list for this long before we ask again.
const Duration claudeRetryAfter = Duration(minutes: 5);

/// How many of the month's biggest expenses Claude sees.
const int insightTopExpenses = 8;

/// At most this many tips on the "Explain my month" screen.
const int insightMaxTips = 3;

const String insightSystemPrompt = '''
You explain one month of spending to the person who logged it. You get the
month's numbers as JSON. The app shows the numbers itself (the total, the
budget, the top categories, the biggest expenses), so you write only the
words.

- summary: one or two short sentences on how the month went: what stands
  out, and how it sits against the budget when there is one.
- tips: one or two short, kind tips that fit these numbers. No lecture.

Amounts are in the group's currency; write them with the currency code,
with thousands separators and no decimals unless the amount has cents
("2,643 THB"). Percentages are worked out for you: use them as they are.
Use plain, simple words. Do not invent numbers: use only the data you get.
Write all text in the language you are told.''';

/// The JSON schema of Claude's "Explain my month" answer.
const Map<String, Object?> insightSchema = <String, Object?>{
  'type': 'object',
  'properties': <String, Object?>{
    'summary': <String, Object?>{'type': 'string'},
    'tips': <String, Object?>{
      'type': 'array',
      'items': <String, Object?>{'type': 'string'},
    },
  },
  'required': <String>['summary', 'tips'],
  'additionalProperties': false,
};

/// Smart add: at most this many expenses from one text.
const int smartAddMaxItems = 10;

const String smartAddSystemPrompt = '''
You read a short text where a person lists what they spent, like
"lunch 5000, taxi 3000". Split it into expenses.

- note: what the money was for, short, in the person's own words and language.
- amount: the number as written. No currency conversion. 5k means 5000.
- walletId: the id of the wallet the text names (from the list you get),
  else null.
- categoryId: the id of the category the expense belongs to (from the list
  you get). Match by meaning: the names may be in another language than the
  text. When nothing fits well, pick the one that means "other" if there is
  one, else null.
Leave out anything that is not an expense with an amount.

The text is written by people in Myanmar: in English, in Burmese (Myanmar
script, Unicode or Zawgyi), in Burmese written with Latin letters, or a mix
(for example "Grab ကား 3000", "ထမင်း 5000"). A note can be just a shop or
brand name.''';

/// The JSON schema of Claude's smart add answer.
const Map<String, Object?> smartAddSchema = <String, Object?>{
  'type': 'object',
  'properties': <String, Object?>{
    'items': <String, Object?>{
      'type': 'array',
      'items': <String, Object?>{
        'type': 'object',
        'properties': <String, Object?>{
          'note': <String, Object?>{'type': 'string'},
          'amount': <String, Object?>{'type': 'number'},
          'walletId': <String, Object?>{
            'type': <String>['integer', 'null'],
          },
          'categoryId': <String, Object?>{
            'type': <String>['integer', 'null'],
          },
        },
        'required': <String>['note', 'amount', 'walletId', 'categoryId'],
        'additionalProperties': false,
      },
    },
  },
  'required': <String>['items'],
  'additionalProperties': false,
};
