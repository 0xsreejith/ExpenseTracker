import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/app/app.dart';
import 'package:expense_tracker/app/di/injection_container.dart';
import 'package:expense_tracker/core/constants/app_config.dart';
import 'package:expense_tracker/core/logging/logger_service.dart';
import 'package:expense_tracker/features/expenses/presentation/controllers/expense_controller.dart';

class MockExpenseController extends Mock implements ExpenseController {}
class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockExpenseController mockController;

  setUpAll(() {
    final config = AppConfig(
      environment: AppEnvironment.dev,
      appTitle: 'Expense Tracker [TEST]',
      databaseName: 'test',
    );
    if (!sl.isRegistered<AppConfig>()) {
      sl.registerSingleton<AppConfig>(config);
    }
    if (!sl.isRegistered<LoggerService>()) {
      sl.registerSingleton<LoggerService>(MockLoggerService());
    }
  });

  setUp(() {
    mockController = MockExpenseController();

    when(() => mockController.isLoading).thenReturn(false);
    when(() => mockController.allExpenses).thenReturn([]);
    when(() => mockController.calculateMonthlySummary()).thenReturn(List.filled(12, 0.0));
    when(() => mockController.getStartMonth()).thenReturn(1);
    when(() => mockController.getCurrentMonthTotal()).thenReturn(0.0);
    when(() => mockController.getTotalExpenses()).thenReturn(0.0);
    when(() => mockController.fetchExpenses()).thenAnswer((_) async => {});

    if (sl.isRegistered<ExpenseController>()) {
      sl.unregister<ExpenseController>();
    }
    sl.registerFactory<ExpenseController>(() => mockController);
  });

  testWidgets('Smoke test - Verify HomeScreen displays and compiles', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('No expenses added yet'), findsOneWidget);
  });
}
