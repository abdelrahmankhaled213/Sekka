import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Routes/Data/Model/trip_model.dart';

enum TripStateEnum {
  initial,
  startingTrip,    // awaiting backend POST
  tracking,        // background location running
  arrived,         // notifyArrival sent, FCM dispatched
  error,
}

class TripState extends Equatable {

  final TripStateEnum status;
  
  final TripModel? activeTrip;

  final double? distanceMeters;

  final String? errorMessage;

  
  const TripState({
    this.status = TripStateEnum.initial,
    this.activeTrip,
    this.distanceMeters,
    this.errorMessage,
  });

  TripState copyWith({
    TripStateEnum? status,
    TripModel? activeTrip,
    double? distanceMeters,
    String? errorMessage,
    List<TripModel>? tripHistory,
    bool clearActiveTrip = false,
    bool clearDistance = false,
  }) {
    return TripState(
      status: status ?? this.status,
      activeTrip: clearActiveTrip ? null : (activeTrip ?? this.activeTrip),
      distanceMeters: clearDistance ? null : (distanceMeters ?? this.distanceMeters),
      errorMessage: errorMessage ?? this.errorMessage,
       );
  }

  bool get isTracking => status == TripStateEnum.tracking;
  bool get hasArrived => status == TripStateEnum.arrived;

  @override
  List<Object?> get props => [
        status,
        activeTrip,
        distanceMeters,
        errorMessage,
      
      ];
}