import 'package:sekka/Features/Routes/Data/Model/Transport.dart';

enum CrowdingLevel { low, medium, high }

extension CrowdingLevelX on CrowdingLevel {
  static CrowdingLevel fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'medium':
        return CrowdingLevel.medium;
      case 'high':
        return CrowdingLevel.high;
      default:
        return CrowdingLevel.low;
    }
  }

  String get label {
    switch (this) {
      case CrowdingLevel.low:
        return 'Low';
      case CrowdingLevel.medium:
        return 'Medium';
      case CrowdingLevel.high:
        return 'High';
    }
  }
}

class NearestStationModel {
  final int? id;
  final String name;
  final String? routes;
  final GeoPoint location;
  final double distanceKm;
  final CrowdingLevel crowding;

  NearestStationModel({
    this.id,
    required this.routes,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.crowding,
  });

  factory NearestStationModel.fromJson(Map<String, dynamic> json) {


    return NearestStationModel(
      id: json['id'],
      routes: json['routes'] ?? '',
      name: json['stop_name'] ?? '',
      location: GeoPoint.fromJson(json['location']),
      distanceKm: json['distance_km']?.toDouble() ?? 0.0,
      crowding: CrowdingLevelX.fromString(json['crowding_level']),
    );
  }

  NearestStationModel copyWith({
    int? id,
    String? name,
    GeoPoint? location,
    double? distanceKm,
    CrowdingLevel? crowding,
    String? routes,
  }) {
    return NearestStationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      crowding: crowding ?? this.crowding,
      routes: routes ?? this.routes,
    );
  }
}
