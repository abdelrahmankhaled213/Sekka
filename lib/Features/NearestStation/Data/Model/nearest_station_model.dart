import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';

class NearestStationModel {
  final int? id;
  final String name;
  final String? routes;
  final GeoPoint location;
  final double distanceKm;
  final TransportType? type;
  final CrowdingLevel crowding;

  /// Fake capacity data injected after fetching the prediction.
  final int fakeSeatsAvailable;
  final double fakeCapacityPercent;

  NearestStationModel({
    this.id,
    required this.routes,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.crowding,
    required this.type,
    this.fakeSeatsAvailable = 0,
    this.fakeCapacityPercent = 0.0,
  });

  factory NearestStationModel.fromJson(Map<String, dynamic> json) {
    return NearestStationModel(
      id: json['id'],
      routes: json['routes'] ?? '',
      name: json['stop_name'] ?? '',
      location: GeoPoint.fromJson(json['location']),
      distanceKm: json['distance_km']?.toDouble() ?? 0.0,
      crowding: CrowdingLevelX.fromString(json['crowding_level']),
      type: TransportTypeX.fromString(json['edge_type']),
    );
  }

  NearestStationModel copyWith({
    int? id,
    String? name,
    GeoPoint? location,
    double? distanceKm,
    CrowdingLevel? crowding,
    String? routes,
    TransportType? type,
    int? fakeSeatsAvailable,
    double? fakeCapacityPercent,
  }) {
    return NearestStationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      crowding: crowding ?? this.crowding,
      routes: routes ?? this.routes,
      type: type ?? this.type,
      fakeSeatsAvailable: fakeSeatsAvailable ?? this.fakeSeatsAvailable,
      fakeCapacityPercent: fakeCapacityPercent ?? this.fakeCapacityPercent,
    );
  }
}
