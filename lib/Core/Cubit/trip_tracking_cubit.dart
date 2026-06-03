import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Cubit/trip_tracking_state.dart';
import 'package:sekka/Core/Database/secure_storage.dart';
import 'package:sekka/Features/Routes/Data/Model/Repo/trip_repo.dart';
import 'package:sekka/Features/Routes/Data/Model/Repo/trip_tracking_service.dart';
import 'package:sekka/Features/Routes/Data/Model/trip_model.dart';
import 'package:uuid/uuid.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';

class TripCubit extends Cubit<TripState> {
  final TripsRepo _repo;
  late final TripTrackingService _tracker;

  TripCubit(
    this._repo,
    NotificationHelper notificationHelper,
  ) : super(const TripState()) {
    _tracker = TripTrackingService(
      notificationHelper: notificationHelper,
      onArrival: _handleArrival,
      onDistanceUpdate: (dist) {
        if (!isClosed) emit(state.copyWith(distanceMeters: dist));
      },
      onError: (msg) {
        if (!isClosed) {
          emit(state.copyWith(
            status: TripStateEnum.error,
            errorMessage: msg,
          ));
        }
      },
    );


  }

  Future<void> startTrip({
    required Transport startStation,
    required Transport endStation,
  }) async {
    if (state.isTracking) return;

    emit(state.copyWith(status: TripStateEnum.startingTrip));

    try {

final fcmToken = await SecureStorageService().getFcmToken();

      final tempTrip = TripModel(
        id: const Uuid().v4(),
         startStationName: startStation.name,
        endStationId: endStation.id! ,
        endStationName: endStation.name,
        destLocation: GeoPoint(lat: endStation.location.lat, lng: endStation.location.lng),
        status: TripStatus.active,
        fcmToken: fcmToken, startStationId: startStation.id!, date: DateTime.now().toIso8601String(),
      );

      final serverId = await _repo.startTrip(tempTrip);

      final trip = TripModel(
        id: serverId,
        startStationId: tempTrip.startStationId,
        startStationName: tempTrip.startStationName,
        endStationId: tempTrip.endStationId,
        endStationName: tempTrip.endStationName,
        destLocation: tempTrip.destLocation,
        date: tempTrip.date,
        status: TripStatus.active,
        fcmToken: fcmToken,
      );

      final started = await _tracker.start(
        destLat: trip.destLocation.lat,
        destLng: trip.destLocation.lng,
        tripId: trip.id,
        endStationName: trip.endStationName,

      );

      if (!started) {
        emit(state.copyWith(
          status: TripStateEnum.error,
          errorMessage: 'Location permission denied. Please enable it from settings.',
        ));
        return;
      }

      emit(state.copyWith(
        status: TripStateEnum.tracking,
        activeTrip: trip,
      ));
    } catch (e, st) {
      debugPrint('TripCubit startTrip error: $e');
      debugPrint('StackTrace: $st');
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: TripStateEnum.error,
        errorMessage: failure.message,
      ));
      FlutterToastHelper.showToast(text: failure.message, color: AppColor.error);
    }
  }

  Future<void> _handleArrival(String tripId) async {
    try {
      await _repo.notifyArrival(tripId);

    } catch (e) {
      FlutterToastHelper.showToast(text: 'Failed to notify arrival.', color: AppColor.error);
     }

    if (!isClosed) {
      emit(state.copyWith(
        status: TripStateEnum.arrived,
        clearDistance: true,
      ));
    }
  }


Future<void> cancelTrip() async {

  final tripId = state.activeTrip?.id;
  
  // ✅ وقف الـ tracker الأول
  await _tracker.stop();

  // ✅ بعت للـ backend لو فيه tripId
  if (tripId != null) {
    try {
      await _repo.cancelTrip(tripId);
    } catch (e) {
      debugPrint('cancelTrip backend error: $e');
      // مش بنوقف الـ cancel لو الـ backend فشل
    }
  }

  if (!isClosed) {
    emit(state.copyWith(
      status:         TripStateEnum.initial,
      clearActiveTrip: true,
      clearDistance:   true,
    ));
  }
}
  void resetToInitial() {
    emit(state.copyWith(
      status: TripStateEnum.initial,
      clearActiveTrip: true,
      clearDistance: true,
    ));
  }

  @override
  Future<void> close() async {
    
    return super.close();
  }
}