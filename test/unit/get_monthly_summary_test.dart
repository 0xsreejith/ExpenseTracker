import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_monthly_summary.dart';

void main() {
  late GetMonthlySummary getMonthlySummary;

  setUp(() {
    getMonthlySummary = GetMonthlySummary();
  });

  test('should return 12-month rolling summary correctly', () {
    final now = DateTime.now();

    final expenses = [
      ExpenseEntity(id: 1, name: 'Current Month 1', amount: 150.0, date: now),
      ExpenseEntity(id: 2, name: 'Current Month 2', amount: 50.0, date: now),
      ExpenseEntity(
        id: 3,
        name: 'Last Month',
        amount: 200.0,
        date: DateTime(now.year, now.month - 1, 15),
      ),
      ExpenseEntity(
        id: 4,
        name: '11 Months Ago',
        amount: 300.0,
        date: DateTime(now.year, now.month - 11, 10),
      ),
      ExpenseEntity(
        id: 5,
        name: '12 Months Ago (Out of window)',
        amount: 500.0,
        date: DateTime(now.year, now.month - 12, 10),
      ),
    ];

    final summary = getMonthlySummary(expenses);

    expect(summary.length, equals(12));
    expect(summary[11], equals(200.0)); // Index 11 is the current month
    expect(summary[10], equals(200.0)); // Index 10 is 1 month ago
    expect(summary[0], equals(300.0));  // Index 0 is 11 months ago

    for (int i = 1; i < 10; i++) {
      expect(summary[i], equals(0.0));
    }
  });
}
