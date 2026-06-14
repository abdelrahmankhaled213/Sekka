import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Features/Profile/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/Profile/Profile/Logic/trip_history_state.dart';

import '../Data/Model/trip_history_model.dart';

class TripHistoryCubit extends Cubit<TripHistoryState> {
  final TripHistoryRepository repository;

  TripHistoryCubit(this.repository) : super(const TripHistoryState());

  Future<void> loadTrips() async {
    emit(state.copyWith(status: TripHistoryStatus.loading));
    try {
      final trips = await repository.getTrips();
      final total = trips.length;

      emit(state.copyWith(
        status: TripHistoryStatus.success,
        trips: trips,
        totalTrips: total,
       ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: TripHistoryStatus.error,
        errorMessage: failure.message,
      ));
    }
  }

  void setFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  Future<void> createTrip(TripHistoryModel trip) async {
    try {
      await repository.createTrip(trip);
      await loadTrips();
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: TripHistoryStatus.error,
        errorMessage: failure.message,
      ));
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await repository.deleteTrip(tripId);
      await loadTrips();
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: TripHistoryStatus.error,
        errorMessage: failure.message,
      ));
    }
  }
}
