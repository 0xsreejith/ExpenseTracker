import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;
  const GetExpenses(this.repository);

  Future<List<ExpenseEntity>> call() async {
    return await repository.getExpenses();
  }
}
