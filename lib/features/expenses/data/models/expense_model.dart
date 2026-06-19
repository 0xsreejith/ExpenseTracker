import 'package:isar/isar.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@Collection()
class ExpenseModel {
  Id id;
  final String name;
  final double amount;
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id == 0 ? Isar.autoIncrement : entity.id,
      name: entity.name,
      amount: entity.amount,
      date: entity.date,
    );
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      name: name,
      amount: amount,
      date: date,
    );
  }
}
