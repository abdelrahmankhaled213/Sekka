import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

enum TripHistoryStatus { initial, loading, success, error }

class TripHistoryState extends Equatable {
  final TripHistoryStatus status;
  final List<TripHistoryModel> trips;
  final String selectedFilter; // 'all' | 'metro' | 'monorail' | 'bus' | 'microbus'
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;
  final double totalSpentEGP;
  final String? errorMessage;

  const TripHistoryState({
    this.status = TripHistoryStatus.initial,
    this.trips = const [],
    this.selectedFilter = 'all',
    this.totalTrips = 0,
    this.completedTrips = 0,
    this.cancelledTrips = 0,
    this.totalSpentEGP = 0.0,
    this.errorMessage,
  });

  /// Trips visible after applying [selectedFilter].
  List<TripHistoryModel> get filteredTrips {
    if (selectedFilter == 'all') return trips;
    return trips.where((t) => t.mode == selectedFilter).toList();
  }

  TripHistoryState copyWith({
    TripHistoryStatus? status,
    List<TripHistoryModel>? trips,
    String? selectedFilter,
    int? totalTrips,
    int? completedTrips,
    int? cancelledTrips,
    double? totalSpentEGP,
    String? errorMessage,
  }) {
    return TripHistoryState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      totalTrips: totalTrips ?? this.totalTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      cancelledTrips: cancelledTrips ?? this.cancelledTrips,
      totalSpentEGP: totalSpentEGP ?? this.totalSpentEGP,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        trips,
        selectedFilter,
        totalTrips,
        completedTrips,
        cancelledTrips,
        totalSpentEGP,
        errorMessage,
      ];
}
