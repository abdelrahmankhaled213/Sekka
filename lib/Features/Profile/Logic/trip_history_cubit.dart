import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';
import 'package:sekka/Features/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_state.dart';

class TripHistoryCubit extends Cubit<TripHistoryState> {
  final TripHistoryRepository repository;

  TripHistoryCubit(this.repository) : super(const TripHistoryState());

  Future<void> loadTrips() async {
    emit(state.copyWith(status: TripHistoryStatus.loading));
    try {
      final trips = await repository.getTrips();
      final total = await repository.getTotalTrips();
      final completed = await repository.getCompletedTrips();
      final cancelled = await repository.getCancelledTrips();

      emit(state.copyWith(
        status: TripHistoryStatus.success,
        trips: trips,
        totalTrips: total,
        completedTrips: completed,
        cancelledTrips: cancelled,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: TripHistoryStatus.error,
        errorMessage: failure.message,
      ));
    }
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
