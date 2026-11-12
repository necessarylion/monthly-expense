import 'package:a2ui_core/a2ui_core.dart';
import 'package:api_dox/constants/ai.dart';

/// One expense read from the text, ready to show and to save.
class SmartAddItem {
  final String note;
  final num amount;
  final String occurredOn;

  /// Null: no wallet entry.
  final int? accountId;
  final String walletName;

  const SmartAddItem({
    required this.note,
    required this.amount,
    required this.occurredOn,
    required this.accountId,
    required this.walletName,
  });
}

/// The A2UI v0.9 messages of smart add. The server writes them, not Claude:
/// the cards save money, so what a card shows must be what it saves. Each
/// card reads its item from the data model, and its Save button sends the
/// same values back, with the keys of POST /expenses.
class SmartAddScreen {
  SmartAddScreen(String lang)
    : text = smartAddText[lang] ?? smartAddText['en']!;

  final Map<String, String> text;

  /// A card per item, each with a Save button (`save_<index>`).
  List<Map<String, Object?>> cards(List<SmartAddItem> items, String currency) {
    if (items.isEmpty) {
      return <Map<String, Object?>>[
        _message('createSurface', <String, Object?>{
          'catalogId': BasicCatalog.v0_9Id,
        }),
        _message('updateComponents', <String, Object?>{
          'components': <Map<String, Object?>>[_text('root', text['nothing']!)],
        }),
      ];
    }
    List<Map<String, Object?>> components = <Map<String, Object?>>[
      <String, Object?>{
        'id': 'root',
        'component': 'Column',
        'children': <String>[for (int i = 0; i < items.length; i++) 'card_$i'],
      },
    ];
    for (int i = 0; i < items.length; i++) {
      components.addAll(_card(i));
    }
    return <Map<String, Object?>>[
      _message('createSurface', <String, Object?>{
        'catalogId': BasicCatalog.v0_9Id,
      }),
      _message('updateDataModel', <String, Object?>{
        'path': '/',
        'value': <String, Object?>{
          'items': <Map<String, Object?>>[
            for (SmartAddItem item in items)
              <String, Object?>{
                'note': item.note,
                'amount': item.amount,
                'occurredOn': item.occurredOn,
                'accountId': item.accountId,
                'amountText': '${_number(item.amount)} $currency',
                'wallet': item.walletName,
              },
          ],
        },
      }),
      _message('updateComponents', <String, Object?>{'components': components}),
    ];
  }

  /// After a save: the button becomes a "Saved" label, so it cannot be
  /// tapped twice.
  List<Map<String, Object?>> saved(String buttonId) {
    return <Map<String, Object?>>[
      _message('updateComponents', <String, Object?>{
        'components': <Map<String, Object?>>[
          _text(buttonId, text['saved']!, variant: 'caption'),
        ],
      }),
    ];
  }

  List<Map<String, Object?>> _card(int i) {
    Map<String, Object?> at(String key) => <String, Object?>{
      'path': '/items/$i/$key',
    };
    return <Map<String, Object?>>[
      <String, Object?>{
        'id': 'card_$i',
        'component': 'Card',
        'child': 'col_$i',
      },
      <String, Object?>{
        'id': 'col_$i',
        'component': 'Column',
        'children': <String>['row_$i', 'wallet_$i', 'save_$i'],
      },
      <String, Object?>{
        'id': 'row_$i',
        'component': 'Row',
        'justify': 'spaceBetween',
        'children': <String>['note_$i', 'amount_$i'],
      },
      <String, Object?>{
        'id': 'note_$i',
        'component': 'Text',
        'text': at('note'),
      },
      <String, Object?>{
        'id': 'amount_$i',
        'component': 'Text',
        'text': at('amountText'),
      },
      <String, Object?>{
        'id': 'wallet_$i',
        'component': 'Text',
        'variant': 'caption',
        'text': at('wallet'),
      },
      <String, Object?>{
        'id': 'save_$i',
        'component': 'Button',
        'variant': 'primary',
        'child': 'save_label_$i',
        'action': <String, Object?>{
          'event': <String, Object?>{
            'name': 'save_expense',
            'context': <String, Object?>{
              'note': at('note'),
              'amount': at('amount'),
              'occurredOn': at('occurredOn'),
              'accountId': at('accountId'),
            },
          },
        },
      },
      _text('save_label_$i', text['save']!),
    ];
  }

  static Map<String, Object?> _text(String id, String text, {String? variant}) {
    return <String, Object?>{
      'id': id,
      'component': 'Text',
      'text': text,
      'variant': ?variant,
    };
  }

  static Map<String, Object?> _message(String type, Map<String, Object?> body) {
    return <String, Object?>{
      'version': 'v0.9',
      type: <String, Object?>{'surfaceId': smartAddSurfaceId, ...body},
    };
  }

  /// 5000 -> "5,000", 12.5 -> "12.50".
  static String _number(num value) {
    bool whole = value == value.roundToDouble();
    String fixed = value.toStringAsFixed(whole ? 0 : 2);
    List<String> parts = fixed.split('.');
    String digits = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => ',',
    );
    return parts.length > 1 ? '$digits.${parts[1]}' : digits;
  }
}
