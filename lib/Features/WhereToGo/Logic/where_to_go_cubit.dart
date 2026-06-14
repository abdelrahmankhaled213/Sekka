import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/location_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';
import 'package:sekka/Features/Profile/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/WhereToGo/Data/Repo/where_to_go.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class WhereToGoCubit extends Cubit<WhereToGoState> {
  final WhereToGoRepo            _repo;
  final PlaceAutocompleteService _places;
  final TripHistoryRepository    _tripHistoryRepo;

  Timer? _debounce;

  WhereToGoCubit({
    required WhereToGoRepo            repo,
    required PlaceAutocompleteService places,
    required TripHistoryRepository    tripHistoryRepo,
  })  : _repo            = repo,
        _places          = places,
        _tripHistoryRepo = tripHistoryRepo,
        super(const WhereToGoState()) {
    fetchCurrentLocation();
    loadRecentTrips();
  }

  // ── recent trips ──────────────────────────────────────────────────────────

  Future<void> loadRecentTrips() async {
    emit(state.copyWith(tripsLoading: true));
    try {
      final trips = await _tripHistoryRepo.getTrips();
      emit(state.copyWith(recentTrips: trips, tripsLoading: false));
    } catch (e) {
      debugPrint('WhereToGoCubit loadRecentTrips error: $e');
      emit(state.copyWith(tripsLoading: false));
    }
  }

  // ── repeat a past trip ────────────────────────────────────────────────────
  // Called when the user taps a recent trip card.
  // Geocodes toStation, sets it as destination, then auto-runs findRoute().

  Future<void> repeatTrip(TripHistoryModel trip) async {
    emit(state.copyWith(
      status:           WhereToGoStatus.locating,
      clearSuggestions: true,
      clearError:       true,
    ));

    try {
      // Step 1: search the destination name to get a PlacePrediction
      final suggestions = await _places.getSuggestions(trip.toStation);
      if (isClosed) return;

      if (suggestions.isEmpty) {
        emit(state.copyWith(
          status:       WhereToGoStatus.error,
          errorMessage: 'Could not find "${trip.toStation}". Try searching manually.',
        ));
        return;
      }

      final place = suggestions.first;

      // Step 2: resolve to lat/lng
      final location = await _places.getPlaceLocation(place.placeId);
      if (isClosed) return;

      if (location == null) {
        emit(state.copyWith(
          status:       WhereToGoStatus.error,
          errorMessage: 'Could not get location for "${trip.toStation}".',
        ));
        return;
      }

      // Step 3: store destination and immediately find route
      emit(state.copyWith(
        status:        WhereToGoStatus.locationReady,
        selectedPlace: place,
        destLat:       location.lat,
        destLng:       location.lng,
      ));

      await findRoute();
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status:       WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  // ── current location ──────────────────────────────────────────────────────

  Future<void> fetchCurrentLocation() async {
    emit(state.copyWith(
      status:     WhereToGoStatus.locating,
      clearError: true,
    ));

    try {
      final position = await LocationHelper.determinePosition();

      if (position == null) {
        emit(state.copyWith(
          status:       WhereToGoStatus.error,
          errorMessage: 'Could not get your location. Please enable location services.',
        ));
        return;
      }

      emit(state.copyWith(
        status:               WhereToGoStatus.locationReady,
        currentLat:           position.latitude,
        currentLng:           position.longitude,
        currentLocationLabel: 'My Location',
      ));
    } catch (e) {
      emit(state.copyWith(
        status:       WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  // ── search suggestions ────────────────────────────────────────────────────

  void onSearchChanged(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      emit(state.copyWith(
        status:           WhereToGoStatus.locationReady,
        clearSuggestions: true,
      ));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    if (isClosed) return;

    emit(state.copyWith(status: WhereToGoStatus.searching));

    try {
      final suggestions = await _places.getSuggestions(query);
      if (isClosed) return;

      emit(state.copyWith(
        status:      WhereToGoStatus.searchReady,
        suggestions: suggestions,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status:       WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  // ── select place ──────────────────────────────────────────────────────────

  Future<void> selectPlace(PlacePrediction place) async {
    emit(state.copyWith(
      status:           WhereToGoStatus.locating,
      selectedPlace:    place,
      clearSuggestions: true,
      clearError:       true,
    ));

    try {
      final location = await _places.getPlaceLocation(place.placeId);

      if (location == null) {
        emit(state.copyWith(
          status:       WhereToGoStatus.error,
          errorMessage: 'Could not get location for this place.',
          clearDest:    true,
        ));
        return;
      }

      emit(state.copyWith(
        status:  WhereToGoStatus.locationReady,
        destLat: location.lat,
        destLng: location.lng,
      ));
    } catch (e) {
      emit(state.copyWith(
        status:       WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
        clearDest:    true,
      ));
    }
  }

  // ── find route ────────────────────────────────────────────────────────────

  Future<void> findRoute() async {
    if (!state.canSearch) return;

    emit(state.copyWith(
      status:        WhereToGoStatus.loadingRoute,
      clearSegments: true,
      clearError:    true,
    ));

    try {
      final segments = await _repo.fetchRoute(
        startLat: state.currentLat!,
        startLng: state.currentLng!,
        endLat:   state.destLat!,
        endLng:   state.destLng!,
      );

      if (isClosed) return;

      emit(state.copyWith(
        status:   WhereToGoStatus.routeReady,
        segments: segments,
      ));

      // Save trip then refresh recent list
      await _saveTripAndRefresh();

    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status:       WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  Future<void> _saveTripAndRefresh() async {
    final fromLabel = state.currentLocationLabel ?? 'My Location';
    final toLabel   = state.selectedPlace?.mainText ?? '';
    if (toLabel.isEmpty) return;

    final trip = TripHistoryModel(
      fromStation: fromLabel,
      toStation:   toLabel,
      dateTime:    DateTime.now().toIso8601String(),
    );

    try {
      await _tripHistoryRepo.createTrip(trip);
      // Prepend to the local list immediately — no need for a full reload
      final updated = [trip, ...state.recentTrips];
      if (!isClosed) emit(state.copyWith(recentTrips: updated));
    } catch (e) {
      debugPrint('WhereToGoCubit _saveTripAndRefresh error: $e');
    }
  }

  // ── reset ─────────────────────────────────────────────────────────────────

  void reset() {
    emit(state.copyWith(
      status:           WhereToGoStatus.locationReady,
      clearDest:        true,
      clearSuggestions: true,
      clearSegments:    true,
      clearError:       true,
    ));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
