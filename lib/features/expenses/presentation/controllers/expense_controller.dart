import 'package:flutter/material.dart';
import 'package:expense_tracker/core/logging/logger_service.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_all_time_total.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_current_month_total.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_monthly_summary.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/update_expense.dart';

class ExpenseController extends ChangeNotifier {
  final GetExpenses getExpensesUseCase;
  final AddExpense addExpenseUseCase;
  final UpdateExpense updateExpenseUseCase;
  final DeleteExpense deleteExpenseUseCase;
  final GetMonthlySummary getMonthlySummaryUseCase;
  final GetCurrentMonthTotal getCurrentMonthTotalUseCase;
  final GetAllTimeTotal getAllTimeTotalUseCase;
  final LoggerService logger;

  ExpenseController({
    required this.getExpensesUseCase,
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getMonthlySummaryUseCase,
    required this.getCurrentMonthTotalUseCase,
    required this.getAllTimeTotalUseCase,
    required this.logger,
  });

  List<ExpenseEntity> _allExpenses = [];
  bool _isLoading = false;

  List<ExpenseEntity> get allExpenses => _allExpenses;
  bool get isLoading => _isLoading;

  Future<void> fetchExpenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allExpenses = await getExpensesUseCase();
      logger.info('Successfully fetched ${_allExpenses.length} expenses');
    } catch (e, stackTrace) {
      logger.error('Error fetching expenses', e, stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(String name, double amount) async {
    try {
      final expense = ExpenseEntity(
        id: 0,
        name: name,
        amount: amount,
        date: DateTime.now(),
      );
      await addExpenseUseCase(expense);
      logger.info('Successfully added expense: $name');
      await fetchExpenses();
    } catch (e, stackTrace) {
      logger.error('Error adding expense', e, stackTrace);
    }
  }

  Future<void> updateExpense(int id, String name, double amount, DateTime date) async {
    try {
      final expense = ExpenseEntity(
        id: id,
        name: name,
        amount: amount,
        date: date,
      );
      await updateExpenseUseCase(expense);
      logger.info('Successfully updated expense ID $id: $name');
      await fetchExpenses();
    } catch (e, stackTrace) {
      logger.error('Error updating expense', e, stackTrace);
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await deleteExpenseUseCase(id);
      logger.info('Successfully deleted expense ID $id');
      await fetchExpenses();
    } catch (e, stackTrace) {
      logger.error('Error deleting expense', e, stackTrace);
    }
  }

  List<double> calculateMonthlySummary() {
    return getMonthlySummaryUseCase(_allExpenses);
  }

  int getStartMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month - 11).month;
  }

  double getCurrentMonthTotal() {
    return getCurrentMonthTotalUseCase(_allExpenses);
  }

  double getTotalExpenses() {
    return getAllTimeTotalUseCase(_allExpenses);
  }
}
