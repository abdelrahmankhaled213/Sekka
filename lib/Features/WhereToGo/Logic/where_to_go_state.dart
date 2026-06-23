// import 'package:equatable/equatable.dart';
// import 'package:sekka/Core/Helper/segment_helper.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';

// enum WhereToGoStatus {
//   initial,
//   locating,         // جاري تحديد الموقع
//   locationReady,    // الموقع جاهز
//   searching,        // جاري البحث في Google Places
//   searchReady,      // نتائج البحث جاهزة
//   loadingRoute,     // جاري حساب المسار
//   routeReady,       // المسار جاهز
//   error,
// }

// class WhereToGoState extends Equatable {
//   final WhereToGoStatus status;
//   final String? errorMessage;

//   // ── current location ──────────────────────────────────────────────────────
//   final double? currentLat;
//   final double? currentLng;
//   final String? currentLocationLabel;

//   // ── destination ───────────────────────────────────────────────────────────
//   final PlacePrediction? selectedPlace;
//   final double? destLat;
//   final double? destLng;

//   // ── search suggestions ────────────────────────────────────────────────────
//   final List<PlacePrediction> suggestions;

//   // ── route result ──────────────────────────────────────────────────────────
//   final List<SegmentModel> segments;

//   const WhereToGoState({
//     this.status             = WhereToGoStatus.initial,
//     this.errorMessage,
//     this.currentLat,
//     this.currentLng,
//     this.currentLocationLabel,
//     this.selectedPlace,
//     this.destLat,
//     this.destLng,
//     this.suggestions        = const [],
//     this.segments           = const [],
//   });

//   bool get hasLocation  => currentLat != null && currentLng != null;
//   bool get hasDestination => destLat != null && destLng != null;
//   bool get canSearch    => hasLocation && hasDestination;
//   bool get isLoading    =>
//       status == WhereToGoStatus.locating ||
//       status == WhereToGoStatus.searching ||
//       status == WhereToGoStatus.loadingRoute;

//   WhereToGoState copyWith({
//     WhereToGoStatus? status,
//     String? errorMessage,
//     double? currentLat,
//     double? currentLng,
//     String? currentLocationLabel,
//     PlacePrediction? selectedPlace,
//     double? destLat,
//     double? destLng,
//     List<PlacePrediction>? suggestions,
//     List<SegmentModel>? segments,
//     bool clearError       = false,
//     bool clearSuggestions = false,
//     bool clearSegments    = false,
//     bool clearDest        = false,
//   }) {
//     return WhereToGoState(
//       status:               status              ?? this.status,
//       errorMessage:         clearError          ? null : (errorMessage ?? this.errorMessage),
//       currentLat:           currentLat          ?? this.currentLat,
//       currentLng:           currentLng          ?? this.currentLng,
//       currentLocationLabel: currentLocationLabel ?? this.currentLocationLabel,
//       selectedPlace:        clearDest           ? null : (selectedPlace ?? this.selectedPlace),
//       destLat:              clearDest           ? null : (destLat       ?? this.destLat),
//       destLng:              clearDest           ? null : (destLng       ?? this.destLng),
//       suggestions:          clearSuggestions    ? []   : (suggestions   ?? this.suggestions),
//       segments:             clearSegments       ? []   : (segments      ?? this.segments),
//     );
//   }

//   @override
//   List<Object?> get props => [
//     status, errorMessage,
//     currentLat, currentLng, currentLocationLabel,
//     selectedPlace, destLat, destLng,
//     suggestions, segments,
//   ];
// }
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';

enum WhereToGoStatus {
  idle,
  locating,
  locationReady,
  searching,
  searchReady,
  loadingRoute,
  routeReady,
  error,
}

/// Which field is currently being typed into
enum ActiveSearchField { from, to }

class WhereToGoState {
  // ── current device location ───────────────────────────────────────────────
  final double? currentLat;
  final double? currentLng;
  final String? currentLocationLabel;

  // ── FROM location ─────────────────────────────────────────────────────────
  /// true  → use device GPS as origin
  /// false → user typed a custom origin
  final bool useCurrentLocationAsFrom;
  final double? fromLat;
  final double? fromLng;
  final String? fromLocationLabel;
  final PlacePrediction? fromSelectedPlace;
  final List<PlacePrediction> fromSuggestions;

  // ── TO location ───────────────────────────────────────────────────────────
  final double? destLat;
  final double? destLng;
  final PlacePrediction? selectedPlace; // destination place

  // ── shared suggestions (the active field drives which list to show) ───────
  final List<PlacePrediction> suggestions; // TO-field suggestions

  // ── which field is focused ────────────────────────────────────────────────
  final ActiveSearchField activeField;

  // ── route ─────────────────────────────────────────────────────────────────
  final List<SegmentModel> segments;

  // ── status / error ────────────────────────────────────────────────────────
  final WhereToGoStatus status;
  final String? errorMessage;

  const WhereToGoState({
    this.currentLat,
    this.currentLng,
    this.currentLocationLabel,
    this.useCurrentLocationAsFrom = true,
    this.fromLat,
    this.fromLng,
    this.fromLocationLabel,
    this.fromSelectedPlace,
    this.fromSuggestions = const [],
    this.destLat,
    this.destLng,
    this.selectedPlace,
    this.suggestions = const [],
    this.activeField = ActiveSearchField.to,
    this.segments = const [],
    this.status = WhereToGoStatus.idle,
    this.errorMessage,
  });

  /// Effective origin coordinates (GPS or custom)
  double? get effectiveFromLat =>
      useCurrentLocationAsFrom ? currentLat : fromLat;
  double? get effectiveFromLng =>
      useCurrentLocationAsFrom ? currentLng : fromLng;

  bool get canSearch =>
      effectiveFromLat != null &&
      effectiveFromLng != null &&
      destLat != null &&
      destLng != null;

  WhereToGoState copyWith({
    double? currentLat,
    double? currentLng,
    String? currentLocationLabel,
    bool? useCurrentLocationAsFrom,
    double? fromLat,
    double? fromLng,
    String? fromLocationLabel,
    PlacePrediction? fromSelectedPlace,
    List<PlacePrediction>? fromSuggestions,
    double? destLat,
    double? destLng,
    PlacePrediction? selectedPlace,
    List<PlacePrediction>? suggestions,
    ActiveSearchField? activeField,
    List<SegmentModel>? segments,
    WhereToGoStatus? status,
    String? errorMessage,
    // clear flags
    bool clearError = false,
    bool clearDest = false,
    bool clearFrom = false,
    bool clearSuggestions = false,
    bool clearFromSuggestions = false,
    bool clearSegments = false,
    bool clearFromPlace = false,
  }) {
    return WhereToGoState(
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      currentLocationLabel:
          currentLocationLabel ?? this.currentLocationLabel,
      useCurrentLocationAsFrom:
          useCurrentLocationAsFrom ?? this.useCurrentLocationAsFrom,
      fromLat: clearFrom ? null : (fromLat ?? this.fromLat),
      fromLng: clearFrom ? null : (fromLng ?? this.fromLng),
      fromLocationLabel: clearFrom
          ? null
          : (fromLocationLabel ?? this.fromLocationLabel),
      fromSelectedPlace: clearFromPlace
          ? null
          : (fromSelectedPlace ?? this.fromSelectedPlace),
      fromSuggestions:
          clearFromSuggestions ? [] : (fromSuggestions ?? this.fromSuggestions),
      destLat: clearDest ? null : (destLat ?? this.destLat),
      destLng: clearDest ? null : (destLng ?? this.destLng),
      selectedPlace:
          clearDest ? null : (selectedPlace ?? this.selectedPlace),
      suggestions:
          clearSuggestions ? [] : (suggestions ?? this.suggestions),
      activeField: activeField ?? this.activeField,
      segments: clearSegments ? [] : (segments ?? this.segments),
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}