import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/saving_goal.dart';

class SavingGoalsProvider with ChangeNotifier {
  List<SavingGoal> _goals = [];
  List<SavingGoal> get goals => _goals;

  SavingGoalsProvider() {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final box = await Hive.openBox<SavingGoal>('saving_goals');
    _goals = box.values.toList();
    notifyListeners();
  }

  Future<void> addGoal(SavingGoal goal) async {
    final box = await Hive.openBox<SavingGoal>('saving_goals');
    await box.add(goal);
    _goals.add(goal);
    notifyListeners();
  }

  Future<void> updateGoal(SavingGoal goal) async {
    final box = await Hive.openBox<SavingGoal>('saving_goals');
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      await box.putAt(index, goal);
      _goals[index] = goal;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    final box = await Hive.openBox<SavingGoal>('saving_goals');
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      await box.deleteAt(index);
      _goals.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> addToGoal(String goalId, double amount) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final updatedGoal = _goals[index].copyWith(
        currentAmount: _goals[index].currentAmount + amount,
      );
      await updateGoal(updatedGoal);
    }
  }
}