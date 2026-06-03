import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/location_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Features/WhereToGo/Data/Repo/where_to_go.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class WhereToGoCubit extends Cubit<WhereToGoState> {
  
  final WhereToGoRepo            _repo;
  final PlaceAutocompleteService _places;

  Timer? _debounce;

  WhereToGoCubit({
    required WhereToGoRepo            repo,
    required PlaceAutocompleteService places,
  })  : _repo   = repo,
        _places = places,
        super(const WhereToGoState()) {
    fetchCurrentLocation();
  }

  // ── current location ──────────────────────────────────────────────────────

  Future<void> fetchCurrentLocation() async {
    emit(state.copyWith(
      status:    WhereToGoStatus.locating,
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
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status:       WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

 
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