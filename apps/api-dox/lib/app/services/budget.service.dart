import 'package:api_dox/app/models/models.dart';
import 'package:api_dox/app/repositories/budget.repository.dart';
import 'package:dox_core/dox_core.dart';

@Inject()
class BudgetService {
  BudgetService(this.budgets);

  final BudgetRepository budgets;

  /// The budget for a month. A month without its own row uses the latest
  /// row before it. Null when no budget was ever set.
  Future<int?> getForMonth(Group group, String monthKey) async {
    GroupMonthlyBudget? row = await budgets.latestAtOrBefore(
      group.id!,
      monthKey,
    );
    return row?.budgetCents;
  }

  /// Set the month's budget, or clear it with null. Returns the budget now
  /// in effect.
  Future<int?> setForMonth(
    Group group,
    String monthKey,
    int? budgetCents,
  ) async {
    GroupMonthlyBudget? existing = await budgets.findByMonth(
      group.id!,
      monthKey,
    );
    if (budgetCents == null) {
      if (existing != null) await budgets.delete(existing.id!);
      return getForMonth(group, monthKey);
    }
    if (existing != null) {
      await budgets.updateCents(existing.id!, budgetCents);
    } else {
      await budgets.create(group.id!, monthKey, budgetCents);
    }
    return budgetCents;
  }
}
