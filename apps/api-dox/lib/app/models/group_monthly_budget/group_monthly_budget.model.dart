import 'package:api_dox/app/models/casts.dart';
import 'package:dox_orm/dox_orm.dart';

part 'group_monthly_budget.model.g.dart';

@DoxModel(table: 'group_monthly_budgets', timestamps: false)
class GroupMonthlyBudget extends GroupMonthlyBudgetGenerator {
  @Column(name: 'group_id')
  int groupId = 0;

  /// `YYYY-MM`
  @Column(name: 'month_key')
  String monthKey = '';

  @Column(name: 'budget_cents')
  int budgetCents = 0;

  @Column(name: 'created_at', cast: TimestampText())
  String createdAtText = '';

  @Column(name: 'updated_at', cast: TimestampText())
  String updatedAtText = '';

  /// Columns that `create(map)` and `update(map)` may set.
  @override
  List<String> get fillable => <String>[
    'group_id',
    'month_key',
    'budget_cents',
    'created_at',
    'updated_at',
  ];
}
