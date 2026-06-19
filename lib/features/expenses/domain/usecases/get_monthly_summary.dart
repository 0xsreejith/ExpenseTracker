import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

class GetMonthlySummary {
  List<double> call(List<ExpenseEntity> expenses) {
    final now = DateTime.now();
    final monthlySummary = List.filled(12, 0.0);

    for (final expense in expenses) {
      final int diffMonths = (now.year * 12 + now.month) - (expense.date.year * 12 + expense.date.month);
      if (diffMonths >= 0 && diffMonths < 12) {
        final int index = 11 - diffMonths;
        monthlySummary[index] += expense.amount;
      }
    }
    return monthlySummary;
  }
}
