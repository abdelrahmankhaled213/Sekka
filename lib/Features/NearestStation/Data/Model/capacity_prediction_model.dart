import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class CapacityPredictionModel {
  final String timestamp;
  final int carriageId;
  final int predictedCount;
  final double capacityPercent;
  final bool seatsAvailable;
  final bool isOffline;

  CapacityPredictionModel({
    required this.timestamp,
    required this.carriageId,
    required this.predictedCount,
    required this.capacityPercent,
    required this.seatsAvailable,
    required this.isOffline,
  });

  factory CapacityPredictionModel.fromJson(Map<String, dynamic> json) {
    return CapacityPredictionModel(
      timestamp: json['timestamp'] as String? ?? '',
      carriageId: (json['carriage_id'] as num?)?.toInt() ?? 0,
      predictedCount: (json['predicted_count'] as num?)?.toInt() ?? 0,
      capacityPercent: (json['capacity_percent'] as num?)?.toDouble() ?? 0.0,
      seatsAvailable: (json['seats_available'] as String?)?.toUpperCase() == 'YES',
      isOffline: json['is_offline'] as bool? ?? false,
    );
  }

  CrowdingLevel get crowdingLevel {
    if (capacityPercent < 40) return CrowdingLevel.low;
    if (capacityPercent < 70) return CrowdingLevel.medium;
    return CrowdingLevel.high;
  }
}
