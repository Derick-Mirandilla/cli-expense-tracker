import 'models/expense.dart';
import 'storage_service.dart';

class ExpenseManager {
  final List<Expense> _expenses = [];
  int _nextId = 1;
  final StorageService _storage;

  ExpenseManager({StorageService? storage})
    : _storage = storage ?? StorageService();
  
  void load() {
    final loaded = _storage.loadExpenses();
    _expenses.addAll(loaded);
    if (loaded.isNotEmpty) {
      _nextId = loaded.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  void _save() {
    _storage.saveExpenses(_expenses);
  }

  void addExpense({
    required double amount,
    required Category category,
    required String description,
    DateTime? date,
  }) {
    final expense = Expense(
      id: _nextId++,
      amount: amount,
      category: category,
      description: description,
      date: date,
    );
    _expenses.add(expense);
    _save();
  }

  List<Expense> getAllExpenses() => List.unmodifiable(_expenses);

  bool deleteExpense(int id) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return false;
    _expenses.removeAt(index);
    _save();
    return true;
  }

  List<Expense> filterByCategory(Category category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  Map<Category, double> getSummary() {
    final summary = <Category, double>{};
    for (final expense in _expenses) {
      summary[expense.category] = (summary[expense.category] ?? 0) + expense.amount;
    }
    return summary;
  }

  double getTotalSpent() {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

}