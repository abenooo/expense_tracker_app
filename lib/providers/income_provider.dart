import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/income.dart';

class IncomeProvider with ChangeNotifier {
  late Box<Income> _incomeBox;

  IncomeProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    _incomeBox = await Hive.openBox<Income>('incomes');
    notifyListeners();
  }

  List<Income> get incomes => _incomeBox.values.toList();

  void addIncome(Income income) {
    _incomeBox.add(income);
    notifyListeners();
  }

  void deleteIncome(int index) {
    _incomeBox.deleteAt(index);
    notifyListeners();
  }

  List<Income> getIncomesForPeriod(DateTime start, DateTime end) {
    return incomes.where((income) => income.date.isAfter(start) && income.date.isBefore(end)).toList();
  }
}