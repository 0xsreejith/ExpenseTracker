import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;
  const DeleteExpense(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteExpense(id);
  }
}
