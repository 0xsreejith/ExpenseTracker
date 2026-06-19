import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';

class UpdateExpense {
  final ExpenseRepository repository;
  const UpdateExpense(this.repository);

  Future<void> call(ExpenseEntity expense) async {
    return await repository.updateExpense(expense);
  }
}
