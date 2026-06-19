import 'package:expense_tracker/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource localDatasource;

  ExpenseRepositoryImpl({required this.localDatasource});

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    final models = await localDatasource.getExpenses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDatasource.saveExpense(model);
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDatasource.saveExpense(model);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await localDatasource.deleteExpense(id);
  }
}
