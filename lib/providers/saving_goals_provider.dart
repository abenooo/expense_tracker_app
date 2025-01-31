import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/saving_goal.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SavingGoalsProvider with ChangeNotifier {
  List<SavingGoal> _goals = [];
  List<SavingGoal> get goals => _goals;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  SavingGoalsProvider(this.flutterLocalNotificationsPlugin) {
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
    _scheduleReminders(goal);
    notifyListeners();
  }

  Future<void> updateGoal(SavingGoal goal) async {
    final box = await Hive.openBox<SavingGoal>('saving_goals');
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      await box.putAt(index, goal);
      _goals[index] = goal;
      _cancelReminders(goal.id);
      _scheduleReminders(goal);
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    final box = await Hive.openBox<SavingGoal>('saving_goals');
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      await box.deleteAt(index);
      _goals.removeAt(index);
      _cancelReminders(goalId);
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

  void _scheduleReminders(SavingGoal goal) {
    final int totalDays = goal.targetDate.difference(DateTime.now()).inDays;
    final int reminderInterval = (totalDays * goal.reminderFrequency / 100).round();

    for (int i = 1; i <= (100 / goal.reminderFrequency).floor(); i++) {
      final scheduledDate = DateTime.now().add(Duration(days: i * reminderInterval));
      if (scheduledDate.isBefore(goal.targetDate)) {
        _scheduleNotification(
          id: goal.id.hashCode + i,
          title: 'Savings Goal Reminder',
          body: 'Remember to save for your goal: ${goal.name}',
          scheduledDate: scheduledDate,
        );
      }
    }
  }

void _scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) {
  flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'savings_reminders',
        'Savings Reminders',
        channelDescription: 'Reminders for savings goals',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
  void _cancelReminders(String goalId) {
    for (int i = 1; i <= 10; i++) {
      flutterLocalNotificationsPlugin.cancel(goalId.hashCode + i);
    }
  }
}