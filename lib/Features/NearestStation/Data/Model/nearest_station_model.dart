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
  final GeoPoint location;
  final double distanceKm;
  final CrowdingLevel crowding;

  NearestStationModel({
    this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.crowding,
  });

  factory NearestStationModel.fromJson(Map<String, dynamic> json) {

    final distanceM = (json['distance_m'] as num?)?.toDouble() ?? 0.0;

    return NearestStationModel(
      id: json['id'],
      name: json['stop_name'] ?? '',
      location: GeoPoint.fromJson(json['location']),
      distanceKm: distanceM / 1000,
      crowding: CrowdingLevelX.fromString(json['crowding_level']),
    );
  }
}
