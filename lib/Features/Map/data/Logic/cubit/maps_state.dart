import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
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
  routeLoading,
  routeLoaded,
}

class MapState extends Equatable {
  final MapStatus       status;
  final List<NearestStationModel>  stations;
  final Set<Marker>                markers;
  final Set<Polyline>              polylines;
  final NearestStationModel?       selectedStation;
  final LatLng?                    userLocation;
  final TransportType?             selectedType;
  final String?                    errorMsg;
  final List<SegmentModel>?        routeSegments;

  const MapState({
    this.status          = MapStatus.initial,
    this.stations        = const [],
    this.markers         = const {},
    this.polylines       = const {},
    this.selectedStation,
    this.userLocation,
    this.selectedType,
    this.errorMsg,
    this.routeSegments,
  });

  MapState copyWith({
    MapStatus?      status,
    List<NearestStationModel>? stations,
    Set<Marker>?               markers,
    Set<Polyline>?             polylines,
    NearestStationModel?       selectedStation,
    bool                       clearSelected = false,
    LatLng?                    userLocation,
    TransportType?             selectedType,
    bool                       clearType = false,
    String?                    errorMsg,
    List<SegmentModel>?        routeSegments,
  }) => MapState(
    status:          status          ?? this.status,
    stations:        stations        ?? this.stations,
    markers:         markers         ?? this.markers,
    polylines:       polylines       ?? this.polylines,
    selectedStation: clearSelected   ? null : selectedStation ?? this.selectedStation,
    userLocation:    userLocation    ?? this.userLocation,
    selectedType:    clearType       ? null : selectedType    ?? this.selectedType,
    errorMsg:        errorMsg        ?? this.errorMsg,
    routeSegments:   routeSegments   ?? this.routeSegments,
  );

  @override
  List<Object?> get props => [
    status, stations, markers, polylines, selectedStation,
    userLocation, selectedType, errorMsg, routeSegments,
  ];
}
