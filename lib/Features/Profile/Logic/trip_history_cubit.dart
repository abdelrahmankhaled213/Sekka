import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Features/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_state.dart';

import '../Data/Model/trip_history_model.dart';

class TripHistoryCubit extends Cubit<TripHistoryState> {

  final TripHistoryRepository repo;

  TripHistoryCubit(this.repo)
      : super(const TripHistoryState(
    tripStateEnum: TripStateEnum.initial,
    trips: [],
    filteredTrips: [],
  ));


  Future<void> loadTrips() async {
    emit(state.copyWith(tripStateEnum: TripStateEnum.loading));
    try {

      final trips = await repo.getTrips();
      print('Trips: ${trips.length}');

      if (isClosed) return;

      final metroCount = trips.where((t) => t.mode == 'metro').length;
      final monorailCount = trips.where((t) => t.mode == 'monorail').length;
      final busCount = trips.where((t) => t.mode == 'bus').length;
      final microbusCount = trips.where((t) => t.mode == 'microbus').length;
      final brtCount = trips.where((t) => t.mode == 'brt').length;

      emit(state.copyWith(
        tripStateEnum: TripStateEnum.success,
        trips: trips,
        filteredTrips: trips,
        metroTripsCount: metroCount,
        monorailTripsCount: monorailCount,
        busTripsCount: busCount,
        microbusTripsCount: microbusCount,
        brtTripsCount: brtCount,
        totalTripsCount: trips.length,
      ));
    } catch (e, stackTrace) {
      print('⚠️ Failed to fetch trips from remote: $e');
      print(stackTrace);
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        tripStateEnum: TripStateEnum.error,
        errorMsg: failure.message,
      ));
    }
  }


  void filterByMode(String? mode) {
    if (mode == null) {
      // إظهار الكل
      emit(state.copyWith(
        filteredTrips: state.trips,
        selectedFilter: null,
      ));
    } else {
      // فلترة حسب الـ mode
      final filtered =
      state.trips.where((trip) => trip.mode == mode).toList();
      emit(state.copyWith(
        filteredTrips: filtered,
        selectedFilter: mode,
      ));
    }
  }

  // ── Sort Trips ───────────────────────────────────────────────────────────
  void sortTrips(SortBy sortBy) {
    List<TripHistoryModel> sorted = List.from(state.filteredTrips);

    switch (sortBy) {
      case SortBy.newestFirst:
        sorted.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        break;
      case SortBy.oldestFirst:
        sorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        break;
      case SortBy.longestDuration:
        sorted.sort((a, b) {
          final aDuration = a.durationMin ?? 0;
          final bDuration = b.durationMin ?? 0;
          return bDuration.compareTo(aDuration);
        });
        break;
      case SortBy.shortestDuration:
        sorted.sort((a, b) {
          final aDuration = a.durationMin ?? 0;
          final bDuration = b.durationMin ?? 0;
          return aDuration.compareTo(bDuration);
        });
        break;
    }

    emit(state.copyWith(
      filteredTrips: sorted,
      currentSortBy: sortBy,
    ));
  }

  // ── Get Trip Details ───────────────────────────────────────────────
  Future<void> getTripDetails(String tripId) async {
    emit(state.copyWith(tripStateEnum: TripStateEnum.loadingDetails));
    try {
      // البحث عن المشوار من القائمة الموجودة
      final tripDetails =
      state.trips.firstWhere((trip) => trip.id == tripId);

      if (isClosed) return;

      emit(state.copyWith(
        tripStateEnum: TripStateEnum.detailsSuccess,
        selectedTripDetails: tripDetails,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        tripStateEnum: TripStateEnum.detailsError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Delete Trip ───────────────────────────────────────────────────
  Future<void> deleteTrip(String tripId) async {
    emit(state.copyWith(tripStateEnum: TripStateEnum.deleting));
    try {
      // حذف من Supabase و Hive
      await repo.deleteTrip(tripId);

      // حذف من القائمة المحلية
      final updatedTrips =
      state.trips.where((trip) => trip.id != tripId).toList();

      // إعادة تطبيق الفلترة
      final filteredTrips = state.selectedFilter == null
          ? updatedTrips
          : updatedTrips
          .where((trip) => trip.mode == state.selectedFilter)
          .toList();

      // إعادة حساب الإحصائيات
      final metroCount = updatedTrips.where((t) => t.mode == 'metro').length;
      final monorailCount =
          updatedTrips.where((t) => t.mode == 'monorail').length;
      final busCount = updatedTrips.where((t) => t.mode == 'bus').length;
      final microbusCount =
          updatedTrips.where((t) => t.mode == 'microbus').length;
      final brtCount = updatedTrips.where((t) => t.mode == 'brt').length;

      emit(state.copyWith(
        tripStateEnum: TripStateEnum.success,
        trips: updatedTrips,
        filteredTrips: filteredTrips,
        metroTripsCount: metroCount,
        monorailTripsCount: monorailCount,
        busTripsCount: busCount,
        microbusTripsCount: microbusCount,
        brtTripsCount: brtCount,
        totalTripsCount: updatedTrips.length,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        tripStateEnum: TripStateEnum.deleteError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Clear Selected Trip ───────────────────────────────────────────────────
  void clearSelectedTrip() {
    emit(state.copyWith(selectedTripDetails: null));
  }
}