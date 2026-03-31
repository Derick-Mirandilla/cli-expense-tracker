enum Category { food, transport, entertainment, health, other }

class Expense {
  final int id;
  final double amount;
  final Category category;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category.name,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      amount: (map['amount'] as num).toDouble(),
      category: Category.values.firstWhere((c) => c.name == map['category'] as String, orElse: () => Category.other),
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  String toString() {
    return '[${category.name.toUpperCase()}] $description — \₱${amount.toStringAsFixed(2)} on ${date.toLocal().toString().split(' ')[0]}';
  }
}