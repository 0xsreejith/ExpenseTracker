import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

class GetAllTimeTotal {
  double call(List<ExpenseEntity> expenses) {
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
}
