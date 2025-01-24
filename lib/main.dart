import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import 'services/localization_service.dart';
import 'theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Request permission for Android
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // Request permission for iOS
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  // Initialize notifications
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iOSInitializationSettings =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iOSInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      // Handle notification taps here
      debugPrint('Notification clicked: ${notificationResponse.payload}');
    },
  );

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await initNotifications();

  final localizationService = LocalizationService();
  await localizationService.init();

  runApp(
    ChangeNotifierProvider.value(
      value: localizationService,
      child: MyApp(notificationsPlugin: flutterLocalNotificationsPlugin),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const MyApp({super.key, required this.notificationsPlugin});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localizationService, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ethiopian Bank Tracker',
          theme: AppTheme.lightTheme,
          home: HomeScreen(notificationsPlugin: notificationsPlugin),
          locale: localizationService.currentLocale,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
