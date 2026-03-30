import 'dart:io';
import 'dart:convert';
import 'models/expense.dart';

class StorageService {
  final String filePath;

  StorageService({this.filePath = 'expense.json'});

  void saveExpenses(List<Expense> expenses) {
    try {
      final file = File(filePath);
      final data = expenses.map((e) => e.toMap()).toList();
      file.writeAsStringSync(jsonEncode(data));
    } catch (e) {
      print('Error saving expense: $e');
    }
  }

  List<Expense> loadExpenses() {
    try {
      final file = File(filePath);
      if(!file.existsSync()) return [];
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) return [];
      final List<dynamic> data = jsonDecode(content);
      return data.map((map) => Expense.fromMap(map as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading expenses: $e');
      return [];
    }
  }
}