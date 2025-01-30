import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './screens/home_screen.dart';
import 'services/localization_service.dart';
import 'theme.dart';
import 'models/utility.dart';
import 'models/saving_goal.dart';
import 'providers/saving_goals_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

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

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(UtilityAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(SavingGoalAdapter());
  }

  // Open Hive Boxes
  await Hive.openBox<Utility>('utilities');
  await Hive.openBox<SavingGoal>('saving_goals');

  // Initialize notifications
  await initNotifications();

  // Initialize timezone
  tz.initializeTimeZones();

  final localizationService = LocalizationService();
  await localizationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavingGoalsProvider(flutterLocalNotificationsPlugin)),
        ChangeNotifierProvider.value(value: localizationService),
      ],
      child: MyApp(notificationsPlugin: flutterLocalNotificationsPlugin),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const MyApp({Key? key, required this.notificationsPlugin}) : super(key: key);

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