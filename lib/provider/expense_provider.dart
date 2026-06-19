import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseProvider  extends ChangeNotifier{
  static late Isar isar;
  List<Expense> _allExpenses = [];
 
 // SETUP

  //initaialze isar
  static Future<void> initialize() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }


// GETTERS
List<Expense> get allExpenses => _allExpenses;

// OPERATIONS

// CRAETE EXPENSE
Future<void> createExpense(Expense expense) async {
  // ADD TO ISAR DATABASE
  await isar.writeTxn(() async {
    await isar.expenses.put(expense);
  });
  // ADD TO LOCAL LIST
  _allExpenses.add(expense);
  // NOTIFY LISTENERS THAT DATA HAS CHANGED UPON ADDITION
  notifyListeners();
}

// READ EXPENSE
Future<List<Expense>> readExpenses() async {
  // FETCH ALL EXPENSES FROM ISAR DATABASE
  final expeenses = await isar.expenses.where().findAll();
  // ADD TO LOCAL LIST
  _allExpenses.clear();
  _allExpenses.addAll(expeenses);
  // NOTIFY LISTENERS THAT DATA HAS CHANGED UPON READ
  notifyListeners();
  // RETURN LIST OF EXPENSES
  return _allExpenses;
}

// UPDATE EXPENSE
Future<void> updateExpense(int id, Expense expense) async {
// CHECK UPDATED EXPENSE ID MATCHES THE ID OF THE EXPENSE TO BE UPDATED
expense.id=id;
// UPDATE EXPENSE IN ISAR DATABASE
await isar.writeTxn(() async {
  await isar.expenses.put(expense);
});
// UPDATE EXPENSE IN LOCAL LIST
_allExpenses.removeWhere((element) => element.id == id);
_allExpenses.add(expense);
// REREAD EXPENSES FROM DB
 await readExpenses();
}

// DELETE EXPENSE
Future<void> deleteExpense(int id) async {
// DELETE EXPENSE FROM ISAR DATABASE
await isar.writeTxn(() async {
  await isar.expenses.delete(id);
});
// DELETE EXPENSE FROM LOCAL LIST
_allExpenses.removeWhere((element) => element.id == id);
// REREAD EXPENSES FROM DB
 await readExpenses();
}


}