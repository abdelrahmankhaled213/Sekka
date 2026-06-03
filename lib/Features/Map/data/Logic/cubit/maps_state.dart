import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

import '../../../../../Core/Helper/transport_type_helper.dart';


enum MapStatus {
  initial,
  locationLoading,
  locationDenied,
  locationDeniedForever,
  stationsLoading,
  stationsLoaded,
  stationsEmpty,
  stationsError,
}

class MapState extends Equatable {
  final MapStatus       status;
  final List<NearestStationModel>  stations;
  final Set<Marker>                markers;
  final NearestStationModel?       selectedStation;
  final LatLng?                    userLocation;
  final TransportType?             selectedType;
  final String?                    errorMsg;

  const MapState({
    this.status          = MapStatus.initial,
    this.stations        = const [],
    this.markers         = const {},
    this.selectedStation,
    this.userLocation,
    this.selectedType,
    this.errorMsg,
  });

  MapState copyWith({
    MapStatus?      status,
    List<NearestStationModel>? stations,
    Set<Marker>?               markers,
    NearestStationModel?       selectedStation,
    bool                       clearSelected = false,
    LatLng?                    userLocation,
    TransportType?             selectedType,
    bool                       clearType = false,
    String?                    errorMsg,
  }) => MapState(
    status:          status          ?? this.status,
    stations:        stations        ?? this.stations,
    markers:         markers         ?? this.markers,
    selectedStation: clearSelected   ? null : selectedStation ?? this.selectedStation,
    userLocation:    userLocation    ?? this.userLocation,
    selectedType:    clearType       ? null : selectedType    ?? this.selectedType,
    errorMsg:        errorMsg        ?? this.errorMsg,
  );

  @override
  List<Object?> get props => [
    status, stations, markers, selectedStation,
    userLocation, selectedType, errorMsg,
  ];
}
