
import '../Data/Model/trip_history_model.dart';

enum TripStateEnum {
  initial,
  loading,
  success,
  error,
  loadingDetails,
  detailsSuccess,
  detailsError,
  deleting,
  deleteError,
}

class TripHistoryState {
  final TripStateEnum tripStateEnum;
  final List<TripHistoryModel> trips;
  final List<TripHistoryModel> filteredTrips;
  final String? errorMsg;

  // ── Statistics ───────────────────────────────────────────────────
  final int totalTripsCount;
  final int metroTripsCount;
  final int monorailTripsCount;
  final int busTripsCount;
  final int microbusTripsCount;
  final int brtTripsCount;

  // ── Filtering & Sorting ───────────────────────────────────────────
  final String? selectedFilter; // 'metro' | 'monorail' | 'bus' | 'microbus' | 'brt' | null
  final SortBy currentSortBy;

  // ── Trip Details ───────────────────────────────────────────────────
  final TripHistoryModel? selectedTripDetails;

  const TripHistoryState({
    required this.tripStateEnum,
    required this.trips,
    required this.filteredTrips,
    this.errorMsg,
    this.totalTripsCount = 0,
    this.metroTripsCount = 0,
    this.monorailTripsCount = 0,
    this.busTripsCount = 0,
    this.microbusTripsCount = 0,
    this.brtTripsCount = 0,
    this.selectedFilter,
    this.currentSortBy = SortBy.newestFirst,
    this.selectedTripDetails,
  });

  TripHistoryState copyWith({
    TripStateEnum? tripStateEnum,
    List<TripHistoryModel>? trips,
    List<TripHistoryModel>? filteredTrips,
    String? errorMsg,
    int? totalTripsCount,
    int? metroTripsCount,
    int? monorailTripsCount,
    int? busTripsCount,
    int? microbusTripsCount,
    int? brtTripsCount,
    String? selectedFilter,
    SortBy? currentSortBy,
    TripHistoryModel? selectedTripDetails,
  }) {
    return TripHistoryState(
      tripStateEnum: tripStateEnum ?? this.tripStateEnum,
      trips: trips ?? this.trips,
      filteredTrips: filteredTrips ?? this.filteredTrips,
      errorMsg: errorMsg,
      totalTripsCount: totalTripsCount ?? this.totalTripsCount,
      metroTripsCount: metroTripsCount ?? this.metroTripsCount,
      monorailTripsCount: monorailTripsCount ?? this.monorailTripsCount,
      busTripsCount: busTripsCount ?? this.busTripsCount,
      microbusTripsCount: microbusTripsCount ?? this.microbusTripsCount,
      brtTripsCount: brtTripsCount ?? this.brtTripsCount,
      selectedFilter: selectedFilter,
      currentSortBy: currentSortBy ?? this.currentSortBy,
      selectedTripDetails: selectedTripDetails,
    );
  }
}

enum SortBy {
  newestFirst,
  oldestFirst,
  longestDuration,
  shortestDuration,
}