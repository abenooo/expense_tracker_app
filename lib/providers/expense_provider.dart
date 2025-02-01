import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final box = await Hive.openBox<Expense>('expenses');
    _expenses = box.values.toList();
    notifyListeners();
  }

  Future<void> addExpense(String title, double amount, DateTime date, String category) async {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
    );

    final box = await Hive.openBox<Expense>('expenses');
    await box.add(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    final box = await Hive.openBox<Expense>('expenses');
    final expenseIndex = _expenses.indexWhere((expense) => expense.id == id);
    if (expenseIndex != -1) {
      await box.deleteAt(expenseIndex);
      _expenses.removeAt(expenseIndex);
      notifyListeners();
    }
  }

  List<Expense> getExpensesForPeriod(DateTime start, DateTime end) {
    return _expenses.where((expense) => expense.date.isAfter(start) && expense.date.isBefore(end)).toList();
  }
}