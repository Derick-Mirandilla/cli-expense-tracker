import 'package:test/test.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/expense_manager.dart';

void main() {
  late ExpenseManager manager;

  setUp(() {
    manager = ExpenseManager();
  });

  group('ExpenseManager', () {
    test('adds an expense and retrieves it', () {
      manager.addExpense(
        amount: 100, 
        category: Category.food, 
        description: 'Lunch');
      
      final expense = manager.getAllExpenses();
      expect(expense.length, 1);
      expect(expense.first.description, 'Lunch');
      expect(expense.first.id, 1);
    });

    test('id auto-increments', () {
      manager.addExpense(amount: 10.0, category: Category.food, description: 'A');
      manager.addExpense(amount: 20.0, category: Category.transport, description: 'B');

      final expense = manager.getAllExpenses();
      expect(expense[1].id, 2);
      expect(expense[0].id, 1);
    });

    test('getAllExpenses() returns unmodifiable list', () {
      manager.addExpense(amount: 10.0, category: Category.food, description: 'A');

      expect(
        () => manager.getAllExpenses().add(
           Expense(id: 99, amount: 0, category: Category.other, description: 'hack'),
        ),
        throwsUnsupportedError,
      );
    });

    test('deletes an expense by ID', () {
      manager.addExpense(amount: 10.0, category: Category.food, description: 'A');

      final result = manager.deleteExpense(1);

      expect(result, true);
      expect(manager.getAllExpenses().isEmpty, true);
    });

    test('deleting a non-existent expense by ID returns false', () {
      final result = manager.deleteExpense(2);
      expect(result, false);
    });

    test('filters expense by category', () {
      manager.addExpense(amount: 10.0, category: Category.food, description: 'Snack');
      manager.addExpense(amount: 20.0, category: Category.transport, description: 'Taxi');
      manager.addExpense(amount: 30.0, category: Category.food, description: 'Dinner');

      final foodExpenses = manager.filterByCategory(Category.food);
      expect(foodExpenses.length, 2);
      expect(foodExpenses.every((e) => e.category == Category.food), true);
    });

    test('getSummary() returns correct totals per category', () {
      manager.addExpense(amount: 10.0, category: Category.food, description: 'A');
      manager.addExpense(amount: 20.0, category: Category.food, description: 'B');
      manager.addExpense(amount: 15.0, category: Category.transport, description: 'C');

      final summary = manager.getSummary();
      expect(summary[Category.food], 30.0);
      expect(summary[Category.transport], 15.0);
    });

    test('getTotalSpent() returns correct total', () {
      manager.addExpense(amount: 10.0, category: Category.food, description: 'A');
      manager.addExpense(amount: 20.0, category: Category.food, description: 'B');
      manager.addExpense(amount: 15.0, category: Category.transport, description: 'C');

      final totalSpent = manager.getTotalSpent();
      expect(totalSpent, 45.0);
    });
  });
  
}