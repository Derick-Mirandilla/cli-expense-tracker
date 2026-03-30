import 'dart:io';
import 'package:test/test.dart';
import 'package:expense_tracker/storage_service.dart';
import 'package:expense_tracker/models/expense.dart';

void main () {
  late StorageService storage;
  const testFilePath = 'test/test_expense.json';

  setUp(() {
    storage = StorageService(filePath: testFilePath);
  });

  tearDown(() {
    final file  = File(testFilePath);
    if(file.existsSync()) file.deleteSync();
  });

  group('StorageService', () {
    test('saves and loads expenses correctly', () {
      final expenses = [
        Expense(id: 1, amount: 50.0, category: Category.food, description: 'Lunch', date: DateTime(2025, 1, 1)),
        Expense(id: 2, amount: 20.0, category: Category.transport, description: 'Taxi', date: DateTime(2025, 1, 2)),
      ];

      storage.saveExpenses(expenses);
      final loaded = storage.loadExpenses();

      expect(loaded.length, 2);
      expect(loaded[0].id, 1);
      expect(loaded[0].description, 'Lunch');
      expect(loaded[1].category, Category.transport);
    });

    test('returns empty list when file does not exist', () {
      final loaded = storage.loadExpenses();
      expect(loaded, isEmpty);
    });

    test('returns empty list when file is empty', () {
      File(testFilePath).writeAsStringSync('');
      final loaded = storage.loadExpenses();
      expect(loaded, isEmpty);
    });

    test('overwrites file on subsequent saves', () {
      final first = [
        Expense(id: 1, amount: 10.0, category: Category.food, description: 'A', date: DateTime(2025, 1, 1)),
      ];
      final second = [
        Expense(id: 2, amount: 20.0, category: Category.health, description: 'B', date: DateTime(2025, 1, 2)),
      ];

      storage.saveExpenses(first);
      storage.saveExpenses(second);
      final loaded = storage.loadExpenses();

      expect(loaded.length, 1);
      expect(loaded.first.id, 2);
    });
  });
}
