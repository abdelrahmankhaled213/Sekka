import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sekka/Core/Helper/location_helper.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';


const double kArrivalThresholdMeters = 100;

const String kTaskDestLat  = 'destLat';
const String kTaskDestLng  = 'destLng';
const String kTaskTripId   = 'tripId';
const String kTaskEndName  = 'endName';
const String kTaskArrived  = 'arrived';
const String kTaskDistance = 'distance';
const String kTaskError    = 'taskError';


@pragma('vm:entry-point')
void startTripTaskCallback() {
  FlutterForegroundTask.setTaskHandler(TripTaskHandler());
}

class TripTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionSub;
  double? _destLat;
  double? _destLng;
  String? _tripId;
  String? _endName;
  bool _arrived = false;


@override
Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
  _destLat = await FlutterForegroundTask.getData<double>(key: kTaskDestLat);
  _destLng = await FlutterForegroundTask.getData<double>(key: kTaskDestLng);
  _tripId  = await FlutterForegroundTask.getData<String>(key: kTaskTripId);
  _endName = await FlutterForegroundTask.getData<String>(key: kTaskEndName);

  if (_destLat == null || _destLng == null) return;

  // ✅ تحقق من الـ permission جوا الـ isolate
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    FlutterForegroundTask.sendDataToMain({
      kTaskError: 'Location permission denied inside task isolate',
    });
    return;
  }

  _startLocationStream();
}


  @override
  void onRepeatEvent(DateTime timestamp) {
    // مش محتاجينه — الـ location stream هو المحرك
  }

  @override
  void onReceiveData(Object data) {
    if (data == 'cancel') {
      _positionSub?.cancel();
      FlutterForegroundTask.stopService();
    }
  }

  // ── location stream ───────────────────────────────────────────────────────

void _startLocationStream() {
  _positionSub = Geolocator.getPositionStream(
    locationSettings:  AndroidSettings( // ✅ استخدم AndroidSettings
      accuracy: LocationAccuracy.high,
      distanceFilter: 15,
      foregroundNotificationConfig: ForegroundNotificationConfig(
        notificationTitle: 'Trip in progress',
        notificationText: 'Tracking your location',
        
      ),
    ),
  ).listen(
    _onPosition,
    onError: _onError,
    cancelOnError: false, // ✅ متوقفش على أول error
  );
}
  void _onPosition(Position pos) {
    if (_arrived || _destLat == null || _destLng == null) return;

    
    
    final dist = Geolocator.distanceBetween(
      pos.latitude, pos.longitude,
      _destLat!, _destLng!,
    );

    
    FlutterForegroundTask.sendDataToMain({kTaskDistance: dist});

    
    final label = dist < 1000
        ? '${dist.toStringAsFixed(0)} m remaining'
        : '${(dist / 1000).toStringAsFixed(1)} km remaining';

    FlutterForegroundTask.updateService(
      notificationTitle: 'Trip in progress 🚇',
      notificationText: label,
    );

    if (dist <= kArrivalThresholdMeters) {
      _arrived = true;
      _positionSub?.cancel();

      FlutterForegroundTask.updateService(
        notificationTitle: 'You have arrived! 🎉',
        notificationText: 'Trip to ${_endName ?? 'destination'} completed.',
      );

      FlutterForegroundTask.sendDataToMain({
        kTaskArrived: true,
        kTaskTripId: _tripId,
      });

      Future.delayed(
        const Duration(seconds: 3),
        FlutterForegroundTask.stopService,
      );
    }
  }

  void _onError(Object error) {
    FlutterForegroundTask.sendDataToMain({kTaskError: error.toString()});
  }
  
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async{

    await _positionSub?.cancel();
    _positionSub = null;
  }
}

class TripTrackingService {

  final Future<void> Function(String tripId) onArrival;
  final void Function(double meters)? onDistanceUpdate;
  final void Function(String message)? onError;

  
  
  final NotificationHelper _notificationHelper;

  ReceivePort? _receivePort;

  TripTrackingService({
    required this.onArrival,
    required NotificationHelper notificationHelper,
    this.onDistanceUpdate,
    this.onError,
  }) : _notificationHelper = notificationHelper;

  

  static void initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: kTripChannelId,
        channelName: 'Trip Tracking',
        channelDescription: 'Tracks your trip and notifies you on arrival',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }


Future<bool> start({
  required double destLat,
  required double destLng,
  required String tripId,
  required String endStationName,
}) async {
  final permission = await Geolocator.checkPermission();
  debugPrint('🔵 Permission: $permission');

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    final position = await LocationHelper.determinePosition();
    if (position == null) return false;
  }

  // ✅ لو الـ service شغال — وقفه الأول
  final isRunning = await FlutterForegroundTask.isRunningService;
  debugPrint('🔵 isRunning before start: $isRunning');
  if (isRunning) {
    await FlutterForegroundTask.stopService();
    await Future.delayed(const Duration(milliseconds: 500)); // ✅ استنى يوقف
  }

  // ✅ اطلب الـ notification permission على Android 13+
  await FlutterForegroundTask.requestNotificationPermission();

  await FlutterForegroundTask.saveData(key: kTaskDestLat, value: destLat);
  await FlutterForegroundTask.saveData(key: kTaskDestLng, value: destLng);
  await FlutterForegroundTask.saveData(key: kTaskTripId,  value: tripId);
  await FlutterForegroundTask.saveData(key: kTaskEndName, value: endStationName);

  _receivePort = FlutterForegroundTask.receivePort;
  _receivePort?.listen(_onDataFromTask);

try {
  final result = await FlutterForegroundTask.startService(
    notificationTitle: 'Trip started',
    notificationText:  'Tracking your trip to $endStationName',
    callback:          startTripTaskCallback,
  );
  debugPrint('🔵 startService result: $result');
  return result is ServiceRequestSuccess;
} catch (e, st) {
  debugPrint('🔴 startService EXCEPTION: $e');
  debugPrint('🔴 StackTrace: $st');
  return false;
}


  // return result is ServiceRequestSuccess;
}


  Future<void> stop() async {
    FlutterForegroundTask.sendDataToTask('cancelled');
    await Future.delayed(const Duration(milliseconds: 300));
    await FlutterForegroundTask.stopService();
    _receivePort = null;
  }

  void _onDataFromTask(dynamic data) {
    if (data is! Map) return;

    if (data.containsKey(kTaskDistance)) {
      onDistanceUpdate?.call((data[kTaskDistance] as num).toDouble());
    }

    if (data[kTaskArrived] == true) {
      final tripId = data[kTaskTripId] as String? ?? '';

      
      _notificationHelper.showTripNotification(
        title: 'You have arrived! 🎉',
        body: 'Your trip has been completed successfully.',
      );

      onArrival(tripId);
    }

    if (data.containsKey(kTaskError)) {
      onError?.call(data[kTaskError] as String);
    }
  }

  static Future<bool> get isRunning => FlutterForegroundTask.isRunningService;
}