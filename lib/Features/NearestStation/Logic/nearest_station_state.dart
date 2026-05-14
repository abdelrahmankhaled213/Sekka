import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

enum NearestStationStatus { initial, loading, loaded, error }

class NearestStationState extends Equatable {
  final NearestStationStatus status;
  final List<NearestStationModel> stations;
  final TransportType? selectedFilter;
  final String? errorMessage;
  final String locationName;
  final double? userLat;
  final double? userLng;

  const NearestStationState({
    this.status = NearestStationStatus.initial,
    this.stations = const [],
    this.selectedFilter,
    this.errorMessage,
    this.locationName = 'Locating...',
    this.userLat,
    this.userLng,
  });

  NearestStationState copyWith({
    NearestStationStatus? status,
    List<NearestStationModel>? stations,
    TransportType? selectedFilter,
    bool clearFilter = false,
    String? errorMessage,
    String? locationName,
    double? userLat,
    double? userLng,
  }) {
    return NearestStationState(
      status: status ?? this.status,
      stations: stations ?? this.stations,
      selectedFilter: clearFilter ? null : selectedFilter ?? this.selectedFilter,
      errorMessage: errorMessage ?? this.errorMessage,
      locationName: locationName ?? this.locationName,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
    );
  }

  @override
  List<Object?> get props => [
    status,
    stations,
    selectedFilter,
    errorMessage,
    locationName,
    userLat,
    userLng,
  ];
}
