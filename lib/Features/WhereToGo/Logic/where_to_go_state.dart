import 'package:equatable/equatable.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';

enum WhereToGoStatus {
  initial,
  locating,         // جاري تحديد الموقع
  locationReady,    // الموقع جاهز
  searching,        // جاري البحث في Google Places
  searchReady,      // نتائج البحث جاهزة
  loadingRoute,     // جاري حساب المسار
  routeReady,       // المسار جاهز
  error,
}

class WhereToGoState extends Equatable {
  final WhereToGoStatus status;
  final String? errorMessage;

  // ── current location ──────────────────────────────────────────────────────
  final double? currentLat;
  final double? currentLng;
  final String? currentLocationLabel;

  // ── destination ───────────────────────────────────────────────────────────
  final PlacePrediction? selectedPlace;
  final double? destLat;
  final double? destLng;

  // ── search suggestions ────────────────────────────────────────────────────
  final List<PlacePrediction> suggestions;

  // ── route result ──────────────────────────────────────────────────────────
  final List<SegmentModel> segments;

  const WhereToGoState({
    this.status             = WhereToGoStatus.initial,
    this.errorMessage,
    this.currentLat,
    this.currentLng,
    this.currentLocationLabel,
    this.selectedPlace,
    this.destLat,
    this.destLng,
    this.suggestions        = const [],
    this.segments           = const [],
  });

  bool get hasLocation  => currentLat != null && currentLng != null;
  bool get hasDestination => destLat != null && destLng != null;
  bool get canSearch    => hasLocation && hasDestination;
  bool get isLoading    =>
      status == WhereToGoStatus.locating ||
      status == WhereToGoStatus.searching ||
      status == WhereToGoStatus.loadingRoute;

  WhereToGoState copyWith({
    WhereToGoStatus? status,
    String? errorMessage,
    double? currentLat,
    double? currentLng,
    String? currentLocationLabel,
    PlacePrediction? selectedPlace,
    double? destLat,
    double? destLng,
    List<PlacePrediction>? suggestions,
    List<SegmentModel>? segments,
    bool clearError       = false,
    bool clearSuggestions = false,
    bool clearSegments    = false,
    bool clearDest        = false,
  }) {
    return WhereToGoState(
      status:               status              ?? this.status,
      errorMessage:         clearError          ? null : (errorMessage ?? this.errorMessage),
      currentLat:           currentLat          ?? this.currentLat,
      currentLng:           currentLng          ?? this.currentLng,
      currentLocationLabel: currentLocationLabel ?? this.currentLocationLabel,
      selectedPlace:        clearDest           ? null : (selectedPlace ?? this.selectedPlace),
      destLat:              clearDest           ? null : (destLat       ?? this.destLat),
      destLng:              clearDest           ? null : (destLng       ?? this.destLng),
      suggestions:          clearSuggestions    ? []   : (suggestions   ?? this.suggestions),
      segments:             clearSegments       ? []   : (segments      ?? this.segments),
    );
  }

  @override
  List<Object?> get props => [
    status, errorMessage,
    currentLat, currentLng, currentLocationLabel,
    selectedPlace, destLat, destLng,
    suggestions, segments,
  ];
}