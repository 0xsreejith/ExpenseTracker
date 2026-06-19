class ExpenseEntity {
  final int id;
  final String name;
  final double amount;
  final DateTime date;

  const ExpenseEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  ExpenseEntity copyWith({
    int? id,
    String? name,
    double? amount,
    DateTime? date,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
