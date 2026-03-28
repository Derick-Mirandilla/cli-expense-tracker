import 'package:test/test.dart';
import 'package:expense_tracker/models/expense.dart';

void main() {
  group('Expense model', () {
    test('creates an expense with required fields', () {
      final expense = Expense(
        id: 1,
        amount: 992.99,
        category: Category.food,
        description: 'Grocery', 
      );

      expect(expense.id, 1);
      expect(expense.amount, 992.99);
      expect(expense.category, Category.food);
      expect(expense.description, 'Grocery');
      expect(expense.date, isNotNull);
    });

    test('creates an expense with a specific date', () {
      final date = DateTime(2026, 3, 24);
      final expense = Expense(
        id: 2,
        amount: 20,
        category: Category.transport,
        description: 'Jeep fare', 
        date: date,
      );

      expect(expense.id, 2);
      expect(expense.amount, 20);
      expect(expense.category, Category.transport);
      expect(expense.description, 'Jeep fare');
      expect(expense.date, date);
    });

    test('toMap() returns correct keys and values', () {
      final date = DateTime(2026, 3, 28);
      final expense = Expense(
        id: 3,
        amount: 500,
        category: Category.health,
        description: 'Asthma inhaler',
        date: date,
      );

      final map = expense.toMap();
      expect(map['id'], 3);
      expect(map['amount'], 500);
      expect(map['category'], 'health');
      expect(map['description'], 'Asthma inhaler');
      expect(map['date'], date.toIso8601String());
    });

    test('fromMap() reconstructs an expense correctly', () {
      final map = {
        'id': 4,
        'amount': 150,
        'category': 'entertainment',
        'description': 'Movie tickets',
        'date': '2026-03-29T00:00:00.000Z',
      };

      final expense = Expense.fromMap(map);
      expect(expense.id, 4);
      expect(expense.amount, 150);
      expect(expense.category, Category.entertainment);
      expect(expense.description, 'Movie tickets');
    });

    test('toMap() and fromMap() are inverses of each other', () {
      final original = Expense(
        id: 5,
        amount: 75.50,
        category: Category.other,
        description: 'Gift',
        date: DateTime(2026, 3, 30),
      );

      final reconstructed = Expense.fromMap(original.toMap());
      expect(reconstructed.id, original.id);
      expect(reconstructed.amount, original.amount);  
      expect(reconstructed.category, original.category);
      expect(reconstructed.description, original.description);
    });

  });
}