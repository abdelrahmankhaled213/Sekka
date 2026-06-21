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
  final double predictionScore;
  final bool isBestPrediction;
  final int? totalSeats;
  final int? occupiedSeats;

  NearestStationModel({
    this.id,
    required this.routes,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.crowding,
    required this.type,
    this.predictionScore = 0.0,
    this.isBestPrediction = false,
    this.totalSeats,
    this.occupiedSeats,
  });

  /// المقاعد المتاحة = الكلي - المشغول
  int? get availableSeats =>
      (totalSeats != null && occupiedSeats != null)
          ? totalSeats! - occupiedSeats!
          : null;

  /// نسبة الزحمة من 0 لـ 100
  double? get occupancyPercentage =>
      (totalSeats != null && totalSeats! > 0 && occupiedSeats != null)
          ? (occupiedSeats! / totalSeats!) * 100
          : null;

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
    double? predictionScore,
    bool? isBestPrediction,
    int? totalSeats,
    int? occupiedSeats,
  }) {
    return NearestStationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      crowding: crowding ?? this.crowding,
      routes: routes ?? this.routes,
      type: type ?? this.type,
      predictionScore: predictionScore ?? this.predictionScore,
      isBestPrediction: isBestPrediction ?? this.isBestPrediction,
      totalSeats: totalSeats ?? this.totalSeats,
      occupiedSeats: occupiedSeats ?? this.occupiedSeats,
    );
  }
}