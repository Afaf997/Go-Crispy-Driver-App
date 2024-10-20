import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    // Retrieve the FCM token
    final fCMToken = await firebaseMessaging.getToken();
    log('FCM Token: $fCMToken');

    // Save the token in SharedPreferences
    await saveFCMToken(fCMToken);
  }

  Future<void> saveFCMToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('fcm_token', token);
      log('FCM Token saved in SharedPreferences: $token');
    }
  }

  // Get FCM token from SharedPreferences
  Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}
