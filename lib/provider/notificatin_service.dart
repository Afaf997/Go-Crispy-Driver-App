

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    
    // Retrieve the FCM token
    final fCMToken = await firebaseMessaging.getToken();
    // log('FCM Token: $fCMToken');
  }
}
