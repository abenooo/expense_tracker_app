import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/utility.dart';
import '../constants/utility_constants.dart';
import 'package:uuid/uuid.dart';

class UtilityService {
  static const String _boxName = 'utilities';
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  
  UtilityService(this._notificationsPlugin);

  Future<Box<Utility>> get _box async => await Hive.openBox<Utility>(_boxName);

  Future<void> initializeDefaultUtilities() async {
    final box = await _box;
    if (box.isEmpty) {
      for (var utility in UtilityConstants.defaultUtilities) {
        await addUtility(utility);
      }
    }
  }

  Future<List<Utility>> getUtilities() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> addUtility(Utility utility) async {
    final box = await _box;
    if (utility.id.isEmpty) {
      utility.id = const Uuid().v4();
    }
    await box.put(utility.id, utility);
    await _scheduleNotification(utility);
  }

  Future<void> updateUtility(Utility utility) async {
    final box = await _box;
    await box.put(utility.id, utility);
    await _scheduleNotification(utility);
  }

  Future<void> deleteUtility(String id) async {
    final box = await _box;
    await box.delete(id);
    // await _cancelNotification(id);
  }

  Future<void> _scheduleNotification(Utility utility) async {
    // await _cancelNotification(utility.id);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'utility_reminders',
      'Utility Reminders',
      channelDescription: 'Reminders for utility payments',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule notification for 2 days before due date
  //   final notificationDate = utility.endDate.subtract(const Duration(days: 2));
    
  //   if (notificationDate.isAfter(DateTime.now())) {
  //     await _notificationsPlugin.schedule(
  //       utility.id.hashCode,
  //       'Utility Payment Reminder',
  //       '${utility.name} payment of ${utility.amount.toStringAsFixed(2)} ETB is due in 2 days',
  //       notificationDate,
  //       platformChannelSpecifics,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       payload: utility.id,
  //     );
  //   }
  // }

  Future<void> _cancelNotification(String id) async {
    await _notificationsPlugin.cancel(id.hashCode);
  }
}

}