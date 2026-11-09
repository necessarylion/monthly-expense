import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'account_entry.model.g.dart';

@DoxModel(table: 'account_entries', timestamps: false)
class AccountEntry extends AccountEntryGenerator {
  @Column(name: 'account_id')
  int accountId = 0;

  /// Set when booked from an expense. Deleting the expense deletes this entry.
  @Column(name: 'expense_id')
  int? expenseId;

  /// Signed cents: positive is money in, negative is money out.
  @Column(name: 'amount_cents')
  int amountCents = 0;

  /// `YYYY-MM-DD`
  @Column(name: 'occurred_on', cast: DateText())
  String occurredOn = '';

  @Column()
  String? note;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'account_id',
    'expense_id',
    'amount_cents',
    'occurred_on',
    'note',
    'created_at',
    'updated_at',
  ];
}
