import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sekka/Core/API/api_service.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Database/secure_storage.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Background Message");
  print(message.notification?.title);
  print(message.notification?.body);
}

class NotificationHelper {

  final SecureStorageService secureStoargeService;
  final ApiConsumer apiConsumer;

  NotificationHelper({
    required this.secureStoargeService,
    required this.apiConsumer,
  });

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();


  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> _requestNotificationPermission() async {
    await _messaging.requestPermission(
      announcement: true,
      alert: true,
      badge: true,
      sound: true,
    );
  }

Future<void>handleClickNotification()async{

RemoteMessage? message = await _messaging.getInitialMessage();

if(message!=null){
   _navigateToDetails(message);
}
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToDetails(message);
    });
    
}

void _navigateToDetails(RemoteMessage message) {
    if (message.data['postId'] != null) {
      
      String postId = message.data['postId'];
      

      navigatorKey.currentState?.pushNamed(AppRoute.itemDetailAndChatScreen, arguments: postId);

      
      
      print("🚀 Go to Post ID: $postId");
    }
  }



  Future<void> _getFcmToken() async {
    
    final newToken = await _messaging.getToken();
  
    if (newToken == null) return;

    final savedToken = await secureStoargeService.getFcmToken();

    if (savedToken == newToken) return;

    try {
      await _savingTokenLocalAndServer(newToken);
    } catch (e) {
        final failure = ErrorHandler.handleError(e);
        FlutterToastHelper.showToast(text: failure.message,color: AppColor.error);
    }
  }

   Future<void> _savingTokenLocalAndServer(String token) async {
 
    await secureStoargeService.saveFcmToken(token);

    await apiConsumer.post(
      "save-token",
      data: {
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "token": token,
        "device_type": Platform.operatingSystem,
      },
    );
  }

 
  void listenToRefreshToken() {

        _messaging.onTokenRefresh.listen((newToken) async {
      await _savingTokenLocalAndServer(newToken);
    });
  }

  Future<void> handleForegroundNotification() async {

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await localNotifications.initialize(
    settings:  settings,
      onDidReceiveNotificationResponse: (details) {
        print("🔔 Notification clicked");
      },
    );

   
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

    Future<void> _showLocalNotification(RemoteMessage message) async {

    RemoteNotification? notification = message.notification;
    
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await localNotifications.show(

      id: notification.hashCode,
      body: notification.body,
      notificationDetails: details,
      title: notification.title,
    );
  }

  Future<void> init() async {

    await _requestNotificationPermission();
    await _getFcmToken();
    listenToRefreshToken();
    await handleForegroundNotification();
    await handleClickNotification();
    
    FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler);

  }
}