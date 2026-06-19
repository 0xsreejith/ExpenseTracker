import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

class GetCurrentMonthTotal {
  double call(List<ExpenseEntity> expenses) {
    final now = DateTime.now();
    double total = 0.0;
    for (final expense in expenses) {
      if (expense.date.year == now.year && expense.date.month == now.month) {
        total += expense.amount;
      }
    }
    return total;
  }
}
