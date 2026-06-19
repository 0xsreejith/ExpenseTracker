import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

class MockExpenseLocalDatasource extends Mock implements ExpenseLocalDatasource {}

class FakeExpenseModel extends Fake implements ExpenseModel {}

void main() {
  late ExpenseRepositoryImpl repository;
  late MockExpenseLocalDatasource mockDatasource;

  setUpAll(() {
    registerFallbackValue(FakeExpenseModel());
  });

  setUp(() {
    mockDatasource = MockExpenseLocalDatasource();
    repository = ExpenseRepositoryImpl(localDatasource: mockDatasource);
  });

  final testDate = DateTime(2026, 6, 19);
  final testModel = ExpenseModel(
    id: 1,
    name: 'Groceries',
    amount: 150.0,
    date: testDate,
  );
  final testEntity = ExpenseEntity(
    id: 1,
    name: 'Groceries',
    amount: 150.0,
    date: testDate,
  );

  group('getExpenses', () {
    test('should return list of expense entities when datasource completes successfully', () async {
      when(() => mockDatasource.getExpenses()).thenAnswer((_) async => [testModel]);

      final result = await repository.getExpenses();

      expect(result.length, equals(1));
      expect(result.first.name, equals(testEntity.name));
      expect(result.first.amount, equals(testEntity.amount));
      expect(result.first.id, equals(testEntity.id));
      verify(() => mockDatasource.getExpenses()).called(1);
    });
  });

  group('addExpense', () {
    test('should call saveExpense on local datasource with mapped model', () async {
      when(() => mockDatasource.saveExpense(any())).thenAnswer((_) async => {});

      await repository.addExpense(testEntity);

      verify(() => mockDatasource.saveExpense(any())).called(1);
    });
  });

  group('deleteExpense', () {
    test('should call deleteExpense on local datasource with correct ID', () async {
      when(() => mockDatasource.deleteExpense(any())).thenAnswer((_) async => {});

      await repository.deleteExpense(1);

      verify(() => mockDatasource.deleteExpense(1)).called(1);
    });
  });
}
