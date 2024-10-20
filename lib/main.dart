import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/helper/notification_helper.dart';
import 'package:resturant_delivery_boy/provider/chat_provider.dart';
import 'package:resturant_delivery_boy/provider/notificatin_service.dart';
import 'package:resturant_delivery_boy/provider/online_provider.dart';
import 'package:resturant_delivery_boy/provider/status_provider.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/localization/app_localization.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/provider/language_provider.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/provider/tracker_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/view/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'di_container.dart' as di;
import 'provider/time_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel? channel;
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

DioClient? dioClient;
SharedPreferences? sharedPreferences;

const fetchOrdersTask = "fetchOrdersTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await checkOrdersAndPlayAudio();
    return Future.value(true);
  });
}

Future<void> checkOrdersAndPlayAudio() async {
  try {
    final response = await dioClient?.get(
        '${AppConstants.currentOrdersUri}${sharedPreferences?.getString(AppConstants.token)}');

    if (response?.statusCode == 200) {
      int currentOrderLength = response?.data.length ?? 0;
      int? storedOrderLength =
          sharedPreferences?.getInt('storedOrderLength') ?? 0;

      if (currentOrderLength > storedOrderLength) {
        await _playAudio(); // Called without context for background tasks
        await sharedPreferences?.setInt(
            'storedOrderLength', currentOrderLength);
      }
    }
  } catch (e) {
    log('Error in checkOrdersAndPlayAudio: ${ApiErrorHandler.getMessage(e)}');
  }
}

// Audio playback with optional BuildContext
Future<void> _playAudio([BuildContext? context]) async {
  try {
    log('Attempting to play audio');
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('audio/audio.wav')).then((value) {
      log('Audio playback successful');
    }).catchError((error) {
      log('Error playing audio: $error');
    });

    await Future.delayed(
        const Duration(seconds: 10)); // Optional delay to allow audio to play

    await audioPlayer.dispose();
  } catch (e) {
    log('Error playing audio: $e');
    if (context != null) {
      _showErrorDialog(context, e.toString());
    }
  }
}

void _showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text('Error playing audio: $errorMessage'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  NotificationService firebaseApi = NotificationService();
  await firebaseApi.initNotifications();

  // Request notification permission
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }

  await di.init();
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

  // Initialize WorkManager for background tasks
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Schedule a one-time task (testing delay)
  Workmanager().registerOneOffTask(
    fetchOrdersTask,
    fetchOrdersTask,
    initialDelay: const Duration(seconds: 10),
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
  }

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<StatusProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnlineProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrackerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TimerProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Aeonik",
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: ColorResources.COLOR_WHITE,
      ),
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      home: const SplashScreen(),
    );
  }
}

class Get {
  static BuildContext? get context => _navigatorKey.currentContext;
  static NavigatorState? get navigator => _navigatorKey.currentState;
}
