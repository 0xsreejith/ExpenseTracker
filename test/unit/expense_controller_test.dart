import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/core/logging/logger_service.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_all_time_total.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_current_month_total.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_monthly_summary.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/update_expense.dart';
import 'package:expense_tracker/features/expenses/presentation/controllers/expense_controller.dart';

class MockGetExpenses extends Mock implements GetExpenses {}
class MockAddExpense extends Mock implements AddExpense {}
class MockUpdateExpense extends Mock implements UpdateExpense {}
class MockDeleteExpense extends Mock implements DeleteExpense {}
class MockGetMonthlySummary extends Mock implements GetMonthlySummary {}
class MockGetCurrentMonthTotal extends Mock implements GetCurrentMonthTotal {}
class MockGetAllTimeTotal extends Mock implements GetAllTimeTotal {}
class MockLoggerService extends Mock implements LoggerService {}

class FakeExpenseEntity extends Fake implements ExpenseEntity {}

void main() {
  late ExpenseController controller;
  late MockGetExpenses mockGetExpenses;
  late MockAddExpense mockAddExpense;
  late MockUpdateExpense mockUpdateExpense;
  late MockDeleteExpense mockDeleteExpense;
  late MockGetMonthlySummary mockGetMonthlySummary;
  late MockGetCurrentMonthTotal mockGetCurrentMonthTotal;
  late MockGetAllTimeTotal mockGetAllTimeTotal;
  late MockLoggerService mockLogger;

  setUpAll(() {
    registerFallbackValue(FakeExpenseEntity());
  });

  setUp(() {
    mockGetExpenses = MockGetExpenses();
    mockAddExpense = MockAddExpense();
    mockUpdateExpense = MockUpdateExpense();
    mockDeleteExpense = MockDeleteExpense();
    mockGetMonthlySummary = MockGetMonthlySummary();
    mockGetCurrentMonthTotal = MockGetCurrentMonthTotal();
    mockGetAllTimeTotal = MockGetAllTimeTotal();
    mockLogger = MockLoggerService();

    controller = ExpenseController(
      getExpensesUseCase: mockGetExpenses,
      addExpenseUseCase: mockAddExpense,
      updateExpenseUseCase: mockUpdateExpense,
      deleteExpenseUseCase: mockDeleteExpense,
      getMonthlySummaryUseCase: mockGetMonthlySummary,
      getCurrentMonthTotalUseCase: mockGetCurrentMonthTotal,
      getAllTimeTotalUseCase: mockGetAllTimeTotal,
      logger: mockLogger,
    );
  });

  final testDate = DateTime(2026, 6, 19);
  final testEntity = ExpenseEntity(
    id: 1,
    name: 'Groceries',
    amount: 150.0,
    date: testDate,
  );

  group('fetchExpenses', () {
    test('should set loading state, fetch expenses, and notify listeners', () async {
      when(() => mockGetExpenses()).thenAnswer((_) async => [testEntity]);

      final List<bool> loadingStates = [];
      controller.addListener(() {
        loadingStates.add(controller.isLoading);
      });

      await controller.fetchExpenses();

      expect(controller.allExpenses, equals([testEntity]));
      expect(loadingStates.contains(true), isTrue);
      expect(controller.isLoading, isFalse);
      verify(() => mockGetExpenses()).called(1);
    });
  });

  group('addExpense', () {
    test('should call addExpenseUseCase and then fetchExpenses', () async {
      when(() => mockAddExpense(any())).thenAnswer((_) async => {});
      when(() => mockGetExpenses()).thenAnswer((_) async => [testEntity]);

      await controller.addExpense('Coffee', 5.0);

      verify(() => mockAddExpense(any())).called(1);
      verify(() => mockGetExpenses()).called(1);
    });
  });

  group('deleteExpense', () {
    test('should call deleteExpenseUseCase and then fetchExpenses', () async {
      when(() => mockDeleteExpense(any())).thenAnswer((_) async => {});
      when(() => mockGetExpenses()).thenAnswer((_) async => []);

      await controller.deleteExpense(1);

      verify(() => mockDeleteExpense(1)).called(1);
      verify(() => mockGetExpenses()).called(1);
    });
  });
}
