import 'package:hive/hive.dart';

part 'trip_history_model.g.dart';

@HiveType(typeId: 1)
enum TripStatus {
  @HiveField(0)
  completed,
  @HiveField(1)
  cancelled,
}

@HiveType(typeId: 2)
class TripHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fromStation;

  @HiveField(2)
  final String toStation;

  @HiveField(3)
  final String dateTime;

  @HiveField(4)
  final TripStatus status;

  // ── Extra fields (not Hive-persisted – fetched from remote) ──
  final String? routeCode;
  final String? mode;       // 'metro' | 'monorail' | 'bus' | 'microbus'
  final int? durationMin;
  final double? fareEGP;
  final String? crowdLevel;
  final double? co2Saved;

  const TripHistoryModel({
    required this.id,
    required this.fromStation,
    required this.toStation,
    required this.dateTime,
    required this.status,
    this.routeCode,
    this.mode,
    this.durationMin,
    this.fareEGP,
    this.crowdLevel,
    this.co2Saved,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryModel(
      id: json['id'] as String,
      fromStation: json['from_station'] as String? ??
          json['from_transport'] as String? ??
          '',
      toStation: json['to_station'] as String? ??
          json['to_transport'] as String? ??
          '',
      dateTime: json['date_time'] as String? ?? json['dateTime'] as String? ?? '',
      status: json['status'] == 'completed'
          ? TripStatus.completed
          : TripStatus.cancelled,
      routeCode: json['route_code'] as String?,
      mode: json['mode'] as String?,
      durationMin: (json['duration_min'] as num?)?.toInt(),
      fareEGP: (json['fare_egp'] as num?)?.toDouble(),
      crowdLevel: json['crowd_level'] as String?,
      co2Saved: (json['co2_saved'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_station': fromStation,
      'to_station': toStation,
      'date_time': dateTime,
      'status': status == TripStatus.completed ? 'completed' : 'cancelled',
      if (routeCode != null) 'route_code': routeCode,
      if (mode != null) 'mode': mode,
      if (durationMin != null) 'duration_min': durationMin,
      if (fareEGP != null) 'fare_egp': fareEGP,
      if (crowdLevel != null) 'crowd_level': crowdLevel,
      if (co2Saved != null) 'co2_saved': co2Saved,
    };
  }

  TripHistoryModel copyWith({
    String? id,
    String? fromStation,
    String? toStation,
    String? dateTime,
    TripStatus? status,
    String? routeCode,
    String? mode,
    int? durationMin,
    double? fareEGP,
    String? crowdLevel,
    double? co2Saved,
  }) {
    return TripHistoryModel(
      id: id ?? this.id,
      fromStation: fromStation ?? this.fromStation,
      toStation: toStation ?? this.toStation,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      routeCode: routeCode ?? this.routeCode,
      mode: mode ?? this.mode,
      durationMin: durationMin ?? this.durationMin,
      fareEGP: fareEGP ?? this.fareEGP,
      crowdLevel: crowdLevel ?? this.crowdLevel,
      co2Saved: co2Saved ?? this.co2Saved,
    );
  }
}
