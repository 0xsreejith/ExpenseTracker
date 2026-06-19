import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:isar/isar.dart';

abstract class ExpenseLocalDatasource {
  Future<List<ExpenseModel>> getExpenses();
  Future<void> saveExpense(ExpenseModel model);
  Future<void> deleteExpense(int id);
}

class IsarExpenseLocalDatasourceImpl implements ExpenseLocalDatasource {
  final Isar isar;

  IsarExpenseLocalDatasourceImpl(this.isar);

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return await isar.expenseModels.where().findAll();
  }

  @override
  Future<void> saveExpense(ExpenseModel model) async {
    await isar.writeTxn(() async {
      await isar.expenseModels.put(model);
    });
  }

  @override
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() async {
      await isar.expenseModels.delete(id);
    });
  }
}
