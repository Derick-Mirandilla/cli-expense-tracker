import 'dart:io';
import 'package:expense_tracker/expense_manager.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/storage_service.dart';

void main() {
  final storage = StorageService();
  final manager = ExpenseManager(storage: storage);
  manager.load();
  int choice;

  do {
    print('\n\n');
    print('CLI Expense Tracker:');
    print('1. Add expense');
    print('2. View all expenses');
    print('3. Filter by category');
    print('4. Delete expense');
    print('5. View summary');
    print('0. Exit');
    
    choice = readInt('Enter your choice: ');

    switch (choice) {
      case 1:
        handleAdd(manager);
      case 2:
        handleView(manager);
      case 3:
        handleFilter(manager);
      case 4:
        handleDelete(manager);
      case 5:
        handleSummary(manager);
      case 0:
        print('Good bye!');
      
      default:
        print('Invalid choice! Try again!\n\n');
    }

  } while (choice != 0);
}

int readInt(String prompt) {
  stdout.write(prompt);
  return int.tryParse(stdin.readLineSync() ?? '') ?? -1;
}

double readDouble(String prompt) {
  stdout.write(prompt);
  return double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;
}

String readString(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync() ?? '';
}

void categoryPrinter() {
  print('\nSelect category: ');
  for (final category in Category.values) {
    print('${category.index + 1}. ${category.name}');
  }
}

Category? switchChoice (int choice) {
  final index = choice - 1; 
  if (index < 0 || index >= Category.values.length) return null;
  return Category.values[index];
}

void handleAdd(ExpenseManager m) {
  final amount = readDouble('Enter amount: ');
  categoryPrinter();
  final category = switchChoice(readInt('Enter category number: '));
  if (category == null) {
    print('Invalid category.');
    return;
  }
  final description = readString('Enter description: ');
  m.addExpense(amount: amount, category: category, description: description);
  print('Expense added successfully!');
}

void handleView(ExpenseManager m) {
  final expenses = m.getAllExpenses();
  if (expenses.isEmpty) {
    print('No expenses found');
    return;
  } 
  for (final expense in expenses) {
    print(expense);
  }
}

void handleFilter(ExpenseManager m) {
  while (true) {
    categoryPrinter();
    final category = switchChoice(readInt('Enter category number: '));
    if (category == null) {
      print('Invalid category.');
      return;
    }
    final expenses = m.filterByCategory(category);

    if (expenses.isNotEmpty) {
      print('--- ${category.name.toUpperCase()} EXPENSES ---');
      for (final expense in expenses) {
        print(expense);
      } 
      return;
    } else {
      print('No expense found for ${category.name}');
      return;
    }
  }
}

void handleDelete(ExpenseManager m) {
  int id = readInt('Enter expense ID to delete: ');
  final result = m.deleteExpense(id);

  if (!result) {
    print('Expense with ID $id not found.');
  } else {
    print('Expense deleted successfully');
  }

}

void handleSummary(ExpenseManager m) {
  print('--- SUMMARY ---');
  print('Total spent: ₱${m.getTotalSpent().toStringAsFixed(2)}');

  print('Breakdown by category');
  final expenses = m.getSummary();

  for (final expense in expenses.keys) {
    final amount  =expenses[expense];
    if (amount != 0) {
      print('${expense.name}\t₱${amount?.toStringAsFixed(2)}');
    } 
  }
}
