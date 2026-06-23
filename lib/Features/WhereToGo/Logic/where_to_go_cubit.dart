// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:sekka/Core/Error/error_handler.dart';
// import 'package:sekka/Core/Helper/location_helper.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
// import 'package:sekka/Features/WhereToGo/Data/Repo/where_to_go.dart';
// import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

// class WhereToGoCubit extends Cubit<WhereToGoState> {
  
//   final WhereToGoRepo            _repo;
//   final PlaceAutocompleteService _places;

//   Timer? _debounce;

//   WhereToGoCubit({
//     required WhereToGoRepo            repo,
//     required PlaceAutocompleteService places,
//   })  : _repo   = repo,
//         _places = places,
//         super(const WhereToGoState()) {
//     fetchCurrentLocation();
//   }

//   // ── current location ──────────────────────────────────────────────────────

//   Future<void> fetchCurrentLocation() async {
//     emit(state.copyWith(
//       status:    WhereToGoStatus.locating,
//       clearError: true,
//     ));

//     try {
//       final position = await LocationHelper.determinePosition();

//       if (position == null) {
//         emit(state.copyWith(
//           status:       WhereToGoStatus.error,
//           errorMessage: 'Could not get your location. Please enable location services.',
//         ));
//         return;
//       }

//       emit(state.copyWith(
//         status:               WhereToGoStatus.locationReady,
//         currentLat:           position.latitude,
//         currentLng:           position.longitude,
//         currentLocationLabel: 'My Location',
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         status:       WhereToGoStatus.error,
//         errorMessage: ErrorHandler.handleError(e).message,
//       ));
//     }
//   }

//   // ── search suggestions ────────────────────────────────────────────────────

//   void onSearchChanged(String query) {
//     _debounce?.cancel();

//     if (query.trim().isEmpty) {
//       emit(state.copyWith(
//         status:           WhereToGoStatus.locationReady,
//         clearSuggestions: true,
//       ));
//       return;
//     }

//     _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
//   }

//   Future<void> _search(String query) async {
//     if (isClosed) return;

//     emit(state.copyWith(status: WhereToGoStatus.searching));

//     try {
//       final suggestions = await _places.getSuggestions(query);
//       if (isClosed) return;

//       emit(state.copyWith(
//         status:      WhereToGoStatus.searchReady,
//         suggestions: suggestions,
//       ));
//     } catch (e) {
//       if (isClosed) return;
//       emit(state.copyWith(
//         status:       WhereToGoStatus.error,
//         errorMessage: ErrorHandler.handleError(e).message,
//       ));
//     }
//   }

//   // ── select place ──────────────────────────────────────────────────────────

//   Future<void> selectPlace(PlacePrediction place) async {
//     emit(state.copyWith(
//       status:           WhereToGoStatus.locating,
//       selectedPlace:    place,
//       clearSuggestions: true,
//       clearError:       true,
//     ));

//     try {
//       final location = await _places.getPlaceLocation(place.placeId);

//       if (location == null) {
//         emit(state.copyWith(
//           status:       WhereToGoStatus.error,
//           errorMessage: 'Could not get location for this place.',
//           clearDest:    true,
//         ));
//         return;
//       }

//       emit(state.copyWith(
//         status:  WhereToGoStatus.locationReady,
//         destLat: location.lat,
//         destLng: location.lng,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         status:       WhereToGoStatus.error,
//         errorMessage: ErrorHandler.handleError(e).message,
//         clearDest:    true,
//       ));
//     }
//   }

 
//   Future<void> findRoute() async {
//     if (!state.canSearch) return;

//     emit(state.copyWith(
//       status:        WhereToGoStatus.loadingRoute,
//       clearSegments: true,
//       clearError:    true,
//     ));

//     try {
//       final segments = await _repo.fetchRoute(
//         startLat: state.currentLat!,
//         startLng: state.currentLng!,
//         endLat:   state.destLat!,
//         endLng:   state.destLng!,
//       );

//       if (isClosed) return;

//       emit(state.copyWith(
//         status:   WhereToGoStatus.routeReady,
//         segments: segments,
//       ));
//     } catch (e) {
//       if (isClosed) return;
//       emit(state.copyWith(
//         status:       WhereToGoStatus.error,
//         errorMessage: ErrorHandler.handleError(e).message,
//       ));
//     }
//   }

 
//   void reset() {
//     emit(state.copyWith(
//       status:           WhereToGoStatus.locationReady,
//       clearDest:        true,
//       clearSuggestions: true,
//       clearSegments:    true,
//       clearError:       true,
//     ));
//   }

//   @override
//   Future<void> close() {
//     _debounce?.cancel();
//     return super.close();
//   }
// }
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/location_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Features/WhereToGo/Data/Repo/where_to_go.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class WhereToGoCubit extends Cubit<WhereToGoState> {
  final WhereToGoRepo _repo;
  final PlaceAutocompleteService _places;

  Timer? _debounce;

  WhereToGoCubit({
    required WhereToGoRepo repo,
    required PlaceAutocompleteService places,
  })  : _repo = repo,
        _places = places,
        super(const WhereToGoState()) {
    fetchCurrentLocation();
  }

  // ── current location ──────────────────────────────────────────────────────

  Future<void> fetchCurrentLocation() async {
    emit(state.copyWith(
      status: WhereToGoStatus.locating,
      clearError: true,
    ));

    try {
      final position = await LocationHelper.determinePosition();

      if (position == null) {
        emit(state.copyWith(
          status: WhereToGoStatus.error,
          errorMessage:
              'Could not get your location. Please enable location services.',
        ));
        return;
      }

      emit(state.copyWith(
        status: WhereToGoStatus.locationReady,
        currentLat: position.latitude,
        currentLng: position.longitude,
        currentLocationLabel: 'My Location',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  // ── FROM field ────────────────────────────────────────────────────────────

  /// Switch origin back to device GPS
  void useCurrentLocation() {
    emit(state.copyWith(
      useCurrentLocationAsFrom: true,
      clearFrom: true,
      clearFromPlace: true,
      clearFromSuggestions: true,
      status: WhereToGoStatus.locationReady,
    ));
  }

  /// User started typing in the FROM field
  void onFromSearchChanged(String query) {
    _debounce?.cancel();

    emit(state.copyWith(
      activeField: ActiveSearchField.from,
      useCurrentLocationAsFrom: false,
    ));

    if (query.trim().isEmpty) {
      emit(state.copyWith(clearFromSuggestions: true));
      return;
    }

    _debounce =
        Timer(const Duration(milliseconds: 400), () => _searchFrom(query));
  }

  Future<void> _searchFrom(String query) async {
    if (isClosed) return;

    emit(state.copyWith(status: WhereToGoStatus.searching));

    try {
      final suggestions = await _places.getSuggestions(query);
      if (isClosed) return;

      emit(state.copyWith(
        status: WhereToGoStatus.searchReady,
        fromSuggestions: suggestions,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  Future<void> selectFromPlace(PlacePrediction place) async {
    emit(state.copyWith(
      status: WhereToGoStatus.locating,
      fromSelectedPlace: place,
      clearFromSuggestions: true,
      clearError: true,
      useCurrentLocationAsFrom: false,
    ));

    try {
      final location = await _places.getPlaceLocation(place.placeId);

      if (location == null) {
        emit(state.copyWith(
          status: WhereToGoStatus.error,
          errorMessage: 'Could not get location for this place.',
          clearFrom: true,
        ));
        return;
      }

      emit(state.copyWith(
        status: WhereToGoStatus.locationReady,
        fromLat: location.lat,
        fromLng: location.lng,
        fromLocationLabel: place.mainText,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
        clearFrom: true,
      ));
    }
  }

  // ── TO field ──────────────────────────────────────────────────────────────

  void onSearchChanged(String query) {
    _debounce?.cancel();

    emit(state.copyWith(activeField: ActiveSearchField.to));

    if (query.trim().isEmpty) {
      emit(state.copyWith(
        status: WhereToGoStatus.locationReady,
        clearSuggestions: true,
      ));
      return;
    }

    _debounce =
        Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    if (isClosed) return;

    emit(state.copyWith(status: WhereToGoStatus.searching));

    try {
      final suggestions = await _places.getSuggestions(query);
      if (isClosed) return;

      emit(state.copyWith(
        status: WhereToGoStatus.searchReady,
        suggestions: suggestions,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  Future<void> selectPlace(PlacePrediction place) async {
    emit(state.copyWith(
      status: WhereToGoStatus.locating,
      selectedPlace: place,
      clearSuggestions: true,
      clearError: true,
    ));

    try {
      final location = await _places.getPlaceLocation(place.placeId);

      if (location == null) {
        emit(state.copyWith(
          status: WhereToGoStatus.error,
          errorMessage: 'Could not get location for this place.',
          clearDest: true,
        ));
        return;
      }

      emit(state.copyWith(
        status: WhereToGoStatus.locationReady,
        destLat: location.lat,
        destLng: location.lng,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
        clearDest: true,
      ));
    }
  }

  // ── swap from ↔ to ────────────────────────────────────────────────────────

  void swapLocations() {
    // Only swap if both sides are set
    if (state.destLat == null || state.effectiveFromLat == null) return;

    final prevFromLat = state.effectiveFromLat;
    final prevFromLng = state.effectiveFromLng;
    final prevFromLabel = state.useCurrentLocationAsFrom
        ? (state.currentLocationLabel ?? 'My Location')
        : state.fromLocationLabel;
    final prevFromPlace = state.fromSelectedPlace;

    final prevDestLat = state.destLat;
    final prevDestLng = state.destLng;
    final prevDestPlace = state.selectedPlace;

    emit(state.copyWith(
      useCurrentLocationAsFrom: false,
      fromLat: prevDestLat,
      fromLng: prevDestLng,
      fromLocationLabel: prevDestPlace?.mainText,
      fromSelectedPlace: prevDestPlace,
      destLat: prevFromLat,
      destLng: prevFromLng,
      selectedPlace: prevFromPlace,
      clearSuggestions: true,
      clearFromSuggestions: true,
      status: WhereToGoStatus.locationReady,
    ));

  }

  // ── route ─────────────────────────────────────────────────────────────────

  Future<void> findRoute() async {
    if (!state.canSearch) return;

    emit(state.copyWith(
      status: WhereToGoStatus.loadingRoute,
      clearSegments: true,
      clearError: true,
    ));

    try {
      final segments = await _repo.fetchRoute(
        startLat: state.effectiveFromLat!,
        startLng: state.effectiveFromLng!,
        endLat: state.destLat!,
        endLng: state.destLng!,
      );

      if (isClosed) return;

      emit(state.copyWith(
        status: WhereToGoStatus.routeReady,
        segments: segments,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: WhereToGoStatus.error,
        errorMessage: ErrorHandler.handleError(e).message,
      ));
    }
  }

  // ── reset ─────────────────────────────────────────────────────────────────

  void reset() {
    emit(state.copyWith(
      status: WhereToGoStatus.locationReady,
      useCurrentLocationAsFrom: true,
      clearFrom: true,
      clearFromPlace: true,
      clearDest: true,
      clearSuggestions: true,
      clearFromSuggestions: true,
      clearSegments: true,
      clearError: true,
    ));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}