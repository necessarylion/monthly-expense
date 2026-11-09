import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'recurring_expense.model.g.dart';

/// An expense that repeats every month. See the migration for the columns.
@DoxModel(table: 'recurring_expenses', timestamps: false)
class RecurringExpense extends RecurringExpenseGenerator {
  @Column(name: 'group_id')
  int groupId = 0;

  @Column(name: 'created_by_user_id')
  int? createdByUserId;

  @Column(name: 'category_id')
  int? categoryId;

  /// Null: the creator's default wallet when it runs.
  @Column(name: 'account_id')
  int? accountId;

  @Column(name: 'amount_cents')
  int amountCents = 0;

  @Column()
  String? note;

  /// 1 to 31. A short month uses its last day.
  @Column(name: 'day_of_month')
  int dayOfMonth = 1;

  /// `YYYY-MM-DD`: the date of the next expense it adds.
  @Column(name: 'next_on', cast: DateText())
  String nextOn = '';

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'group_id',
    'created_by_user_id',
    'category_id',
    'account_id',
    'amount_cents',
    'note',
    'day_of_month',
    'next_on',
    'created_at',
    'updated_at',
  ];
}
