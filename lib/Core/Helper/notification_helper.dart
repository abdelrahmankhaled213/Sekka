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

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

const String kGeneralChannelId   = 'high_importance_channel';
const String kTripChannelId      = 'trip_notifications_channel';

class NotificationHelper {
  
  final SecureStorageService secureStoargeService;
  final ApiConsumer apiConsumer;

  NotificationHelper({
    required this.secureStoargeService,
    required this.apiConsumer,
  });

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

   FlutterLocalNotificationsPlugin get localNotifications => _localNotifications;

  static const AndroidNotificationChannel _generalChannel =
      AndroidNotificationChannel(
    kGeneralChannelId,
    'General Notifications',
    description: 'General app notifications',
    importance: Importance.max,
  );

  static const AndroidNotificationChannel _tripChannel =
      AndroidNotificationChannel(
    kTripChannelId,
    'Trip Notifications',
    description: 'Notifications for trip arrival and tracking',
    importance: Importance.max,
  );

  

  Future<void> init() async {
    await _requestPermission();
    await _createAndroidChannels();   
    await _initLocalNotifications();
    await _getFcmToken();
    _listenToTokenRefresh();
    _listenToForegroundMessages();
    _handleNotificationClicks();
  }

  
  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
    );
  }

  

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_generalChannel);
    await androidPlugin?.createNotificationChannel(_tripChannel);
  }

  
  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(

      onDidReceiveNotificationResponse: (details) {
        
        final payload = details.payload;
        if (payload != null) _handlePayload(payload);
      }, settings:  const InitializationSettings(android: android, iOS: iOS) ,
    );
  }

  
  Future<void> _getFcmToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newToken = await _messaging.getToken();
    if (newToken == null) return;

    final savedToken = await secureStoargeService.getFcmToken();
    if (savedToken == newToken) return;

    try {
      await _saveTokenLocalAndServer(newToken, user.uid);
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      FlutterToastHelper.showToast(text: failure.message, color: AppColor.error);
    }
  }

  Future<void> _saveTokenLocalAndServer(String token, String userId) async {
    await secureStoargeService.saveFcmToken(token);
    await apiConsumer.post(
      'save-token',
      data: {
        'user_id': userId,
        'token': token,
        'device_type': Platform.operatingSystem,
      },
    );
  }

  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await _saveTokenLocalAndServer(newToken, user.uid);
    });
  }

  
  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showGeneralNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data['postId'],
        );
      }
    });
  }


  void _handleNotificationClicks() {
    
   
    _messaging.getInitialMessage().then((message) {
      if (message != null) _navigateFromMessage(message);
    });

     FirebaseMessaging.onMessageOpenedApp.listen(_navigateFromMessage);
  }

  void _navigateFromMessage(RemoteMessage message) {
    final postId = message.data['postId'];
    if (postId != null) {
      navigatorKey.currentState?.pushNamed(
        AppRoute.itemDetailAndChatScreen,
        arguments: postId,
      );
    }
  }

  void _handlePayload(String payload) {
   
    navigatorKey.currentState?.pushNamed(
      AppRoute.itemDetailAndChatScreen,
      arguments: payload,
    );
  }

  
  
  Future<void> showGeneralNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id: title.hashCode ^ body.hashCode,
      title: title,
      body: body,
      notificationDetails:  const NotificationDetails(
        android: AndroidNotificationDetails(
          kGeneralChannelId,
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  
 
  Future<void> showTripNotification({
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      id: 
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
     notificationDetails:  const NotificationDetails(
        android: AndroidNotificationDetails(
          kTripChannelId,
          'Trip Notifications',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.navigation,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
    );
  }
}