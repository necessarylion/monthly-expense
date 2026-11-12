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

/// "Explain my month" writes a whole screen, so it may take longer.
const Duration insightTimeout = Duration(seconds: 60);

/// The A2UI components Claude may use for "Explain my month". The month is
/// read-only, so no buttons or inputs. No `List`: the Dart SDK lets it have
/// `listStyle`, which `@a2ui/react` 0.15 rejects. A `Column` does the same.
const List<String> insightComponents = <String>[
  'Text',
  'Card',
  'Column',
  'Row',
  'Divider',
];

/// How many of the month's biggest expenses Claude sees.
const int insightTopExpenses = 8;

const String insightSystemPrompt = '''
You explain one month of spending to the person who logged it, in a small
mobile screen. You get the month's numbers as JSON. Amounts are already in
the group's currency; write them with the currency code.

Show, in this order:
1. One short headline about the month (total, and how it compares with the
   budget if there is one).
2. A card for each of the top 3 categories: name, amount, share of the total.
3. The biggest expenses, as a short list.
4. One or two short, kind tips. No lecture.

Use plain, simple words. Keep it short. Do not invent numbers: use only the
data you get. Write all text in the language you are told.
Answer with one A2UI block only, with no other text.''';

/// Smart add: at most this many expenses from one text.
const int smartAddMaxItems = 10;

/// The A2UI surface of smart add. One per answer.
const String smartAddSurfaceId = 'smart-add';

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

/// Button and label text of the smart add cards, per app language.
const Map<String, Map<String, String>> smartAddText =
    <String, Map<String, String>>{
      'en': <String, String>{
        'save': 'Save',
        'saved': '✓ Saved',
        'noWallet': 'No wallet',
        'nothing': 'No expenses found. Try "lunch 5000, taxi 3000".',
      },
      'my': <String, String>{
        'save': 'သိမ်းမယ်',
        'saved': '✓ သိမ်းပြီးပြီ',
        'noWallet': 'ပိုက်ဆံအိတ် မရွေးထားဘူး',
        'nothing':
            'အသုံးစရိတ် မတွေ့ဘူး။ "ထမင်း 5000, တက္ကစီ 3000" လို ရေးကြည့်ပါ။',
      },
    };
