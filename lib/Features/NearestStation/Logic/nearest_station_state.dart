// import 'package:equatable/equatable.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sekka/Core/Helper/transport_type_helper.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

// enum NearestStationStatus { initial, loading, loaded, error }

// class NearestStationState extends Equatable {
//   final NearestStationStatus    status;
//   final List<NearestStationModel> stations;
//   final String                  locationName;
//   final double?                 userLat;
//   final double?                 userLng;
//   final TransportType?          selectedFilter;
//   final String?                 errorMessage;

//   // ── map-specific ───────────────────────────────────────────────────────────
//   final Set<Marker>             markers;
//   final NearestStationModel?    selectedStation;

//   const NearestStationState({
//     this.status         = NearestStationStatus.initial,
//     this.stations       = const [],
//     this.locationName   = 'Your Location',
//     this.userLat,
//     this.userLng,
//     this.selectedFilter,
//     this.errorMessage,
//     this.markers        = const {},
//     this.selectedStation,
//   });

//   NearestStationState copyWith({
//     NearestStationStatus?       status,
//     List<NearestStationModel>?  stations,
//     String?                     locationName,
//     double?                     userLat,
//     double?                     userLng,
//     TransportType?              selectedFilter,
//     bool                        clearFilter = false,
//     String?                     errorMessage,
//     Set<Marker>?                markers,
//     NearestStationModel?        selectedStation,
//     bool                        clearSelected = false,
//   }) => NearestStationState(
//     status:          status          ?? this.status,
//     stations:        stations        ?? this.stations,
//     locationName:    locationName    ?? this.locationName,
//     userLat:         userLat         ?? this.userLat,
//     userLng:         userLng         ?? this.userLng,
//     selectedFilter:  clearFilter     ? null : selectedFilter ?? this.selectedFilter,
//     errorMessage:    errorMessage    ?? this.errorMessage,
//     markers:         markers         ?? this.markers,
//     selectedStation: clearSelected   ? null : selectedStation ?? this.selectedStation,
//   );

//   @override
//   List<Object?> get props => [
//     status, stations, locationName, userLat, userLng,
//     selectedFilter, errorMessage, markers, selectedStation,
//   ];
// }
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

enum NearestStationStatus { initial, loading, loaded, error }

class NearestStationState {
  final NearestStationStatus       status;
  final List<NearestStationModel>  stations;
  final Set<Marker>                markers;
  final String                     locationName;
  final NearestStationModel?       selectedStation;
  final TransportType?             selectedFilter;
  final String?                    errorMessage;

  // ── user's real GPS location (never changes after first load) ──────────────
  final double? userLat;
  final double? userLng;

  // ── searched place location (set when user picks from search) ──────────────
  final double? searchedLat;
  final double? searchedLng;

  const NearestStationState({
    this.status          = NearestStationStatus.initial,
    this.stations        = const [],
    this.markers         = const {},
    this.locationName    = '',
    this.selectedStation,
    this.selectedFilter,
    this.errorMessage,
    this.userLat,
    this.userLng,
    this.searchedLat,
    this.searchedLng,
  });

  NearestStationState copyWith({
    NearestStationStatus?      status,
    List<NearestStationModel>? stations,
    Set<Marker>?               markers,
    String?                    locationName,
    NearestStationModel?       selectedStation,
    TransportType?             selectedFilter,
    String?                    errorMessage,
    double?                    userLat,
    double?                    userLng,
    double?                    searchedLat,
    double?                    searchedLng,
    bool                       clearSelected  = false,
    bool                       clearFilter    = false,
    bool                       clearSearched  = false,
  }) {
    return NearestStationState(
      status:          status          ?? this.status,
      stations:        stations        ?? this.stations,
      markers:         markers         ?? this.markers,
      locationName:    locationName    ?? this.locationName,
      selectedStation: clearSelected   ? null : selectedStation ?? this.selectedStation,
      selectedFilter:  clearFilter     ? null : selectedFilter  ?? this.selectedFilter,
      errorMessage:    errorMessage    ?? this.errorMessage,
      userLat:         userLat         ?? this.userLat,
      userLng:         userLng         ?? this.userLng,
      searchedLat:     clearSearched   ? null : searchedLat     ?? this.searchedLat,
      searchedLng:     clearSearched   ? null : searchedLng     ?? this.searchedLng,
    );
  }
}