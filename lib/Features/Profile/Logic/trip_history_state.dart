import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

enum TripHistoryStatus {
  initial,
  loading,
  success,
  error,
}

class TripHistoryState extends Equatable {
  final TripHistoryStatus status;
  final List<TripHistoryModel> trips;
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;
  final String? errorMessage;

  const TripHistoryState({
    this.status = TripHistoryStatus.initial,
    this.trips = const [],
    this.totalTrips = 0,
    this.completedTrips = 0,
    this.cancelledTrips = 0,
    this.errorMessage,
  });

  TripHistoryState copyWith({
    TripHistoryStatus? status,
    List<TripHistoryModel>? trips,
    int? totalTrips,
    int? completedTrips,
    int? cancelledTrips,
    String? errorMessage,
  }) {
    return TripHistoryState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      totalTrips: totalTrips ?? this.totalTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      cancelledTrips: cancelledTrips ?? this.cancelledTrips,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        trips,
        totalTrips,
        completedTrips,
        cancelledTrips,
        errorMessage,
      ];
}
