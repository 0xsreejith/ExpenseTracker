import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/core/constants/app_config.dart';
import 'package:expense_tracker/core/logging/logger_service.dart';
import 'package:expense_tracker/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_all_time_total.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_current_month_total.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_monthly_summary.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/update_expense.dart';
import 'package:expense_tracker/features/expenses/presentation/controllers/expense_controller.dart';

final sl = GetIt.instance;

Future<void> init(AppConfig config) async {
  // Config
  if (!sl.isRegistered<AppConfig>()) {
    sl.registerSingleton<AppConfig>(config);
  }

  // Core (Logging)
  if (!sl.isRegistered<LoggerService>()) {
    sl.registerLazySingleton<LoggerService>(() => LoggerService());
  }

  // Database (Isar)
  if (!sl.isRegistered<Isar>()) {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [ExpenseModelSchema],
      directory: dir.path,
      name: config.databaseName,
    );
    sl.registerSingleton<Isar>(isar);
  }

  // Datasources
  if (!sl.isRegistered<ExpenseLocalDatasource>()) {
    sl.registerLazySingleton<ExpenseLocalDatasource>(
      () => IsarExpenseLocalDatasourceImpl(sl<Isar>()),
    );
  }

  // Repositories
  if (!sl.isRegistered<ExpenseRepository>()) {
    sl.registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(localDatasource: sl<ExpenseLocalDatasource>()),
    );
  }

  // Use cases
  if (!sl.isRegistered<GetExpenses>()) {
    sl.registerLazySingleton<GetExpenses>(() => GetExpenses(sl<ExpenseRepository>()));
  }
  if (!sl.isRegistered<AddExpense>()) {
    sl.registerLazySingleton<AddExpense>(() => AddExpense(sl<ExpenseRepository>()));
  }
  if (!sl.isRegistered<UpdateExpense>()) {
    sl.registerLazySingleton<UpdateExpense>(() => UpdateExpense(sl<ExpenseRepository>()));
  }
  if (!sl.isRegistered<DeleteExpense>()) {
    sl.registerLazySingleton<DeleteExpense>(() => DeleteExpense(sl<ExpenseRepository>()));
  }
  if (!sl.isRegistered<GetMonthlySummary>()) {
    sl.registerLazySingleton<GetMonthlySummary>(() => GetMonthlySummary());
  }
  if (!sl.isRegistered<GetCurrentMonthTotal>()) {
    sl.registerLazySingleton<GetCurrentMonthTotal>(() => GetCurrentMonthTotal());
  }
  if (!sl.isRegistered<GetAllTimeTotal>()) {
    sl.registerLazySingleton<GetAllTimeTotal>(() => GetAllTimeTotal());
  }

  // Controllers/Providers (ChangeNotifier registered as factory)
  if (!sl.isRegistered<ExpenseController>()) {
    sl.registerFactory<ExpenseController>(
      () => ExpenseController(
        getExpensesUseCase: sl<GetExpenses>(),
        addExpenseUseCase: sl<AddExpense>(),
        updateExpenseUseCase: sl<UpdateExpense>(),
        deleteExpenseUseCase: sl<DeleteExpense>(),
        getMonthlySummaryUseCase: sl<GetMonthlySummary>(),
        getCurrentMonthTotalUseCase: sl<GetCurrentMonthTotal>(),
        getAllTimeTotalUseCase: sl<GetAllTimeTotal>(),
        logger: sl<LoggerService>(),
      ),
    );
  }
}
