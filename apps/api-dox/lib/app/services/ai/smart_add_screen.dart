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

  /// Null: none found; POST /expenses sorts it then.
  final int? categoryId;
  final String? categoryName;

  const SmartAddItem({
    required this.note,
    required this.amount,
    required this.occurredOn,
    required this.accountId,
    required this.walletName,
    this.categoryId,
    this.categoryName,
  });

  SmartAddItem withCategory(int? id, String? name) {
    return SmartAddItem(
      note: note,
      amount: amount,
      occurredOn: occurredOn,
      accountId: accountId,
      walletName: walletName,
      categoryId: id,
      categoryName: id == null ? null : name,
    );
  }

  /// "Food · Kbank", or the wallet alone.
  String get details =>
      categoryName == null ? walletName : '$categoryName · $walletName';
}

/// The A2UI v0.9 messages of smart add. The server writes them, not Claude:
/// the cards save money, so what a card shows must be what it saves. Each
/// card reads its item from the data model, and its Save button sends the
/// same values back, with the keys of POST /expenses.
class SmartAddScreen {
  SmartAddScreen(String lang)
    : text = smartAddText[lang] ?? smartAddText['en']!;

  final Map<String, String> text;

  /// One card that lists the items, a row each: the note and its category
  /// and wallet on the left, the amount and a Save button (`save_<index>`)
  /// on the right.
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
      <String, Object?>{'id': 'root', 'component': 'Card', 'child': 'list'},
      <String, Object?>{
        'id': 'list',
        'component': 'Column',
        'children': <String>[
          for (int i = 0; i < items.length; i++) ...<String>[
            if (i > 0) 'divider_$i',
            'item_$i',
          ],
        ],
      },
    ];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) {
        components.add(<String, Object?>{
          'id': 'divider_$i',
          'component': 'Divider',
        });
      }
      components.addAll(_row(i));
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
                'categoryId': item.categoryId,
                'amountText': '${_number(item.amount)} $currency',
                'details': item.details,
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

  List<Map<String, Object?>> _row(int i) {
    Map<String, Object?> at(String key) => <String, Object?>{
      'path': '/items/$i/$key',
    };
    return <Map<String, Object?>>[
      <String, Object?>{
        'id': 'item_$i',
        'component': 'Row',
        'align': 'center',
        'children': <String>['info_$i', 'amount_$i', 'save_$i'],
      },
      <String, Object?>{
        'id': 'info_$i',
        'component': 'Column',
        'weight': 1,
        'children': <String>['note_$i', 'details_$i'],
      },
      <String, Object?>{
        'id': 'note_$i',
        'component': 'Text',
        'text': at('note'),
      },
      <String, Object?>{
        'id': 'details_$i',
        'component': 'Text',
        'variant': 'caption',
        'text': at('details'),
      },
      <String, Object?>{
        'id': 'amount_$i',
        'component': 'Text',
        'variant': 'h5',
        'text': at('amountText'),
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
              'categoryId': at('categoryId'),
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
