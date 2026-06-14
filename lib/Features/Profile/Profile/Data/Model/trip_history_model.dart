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
  final String? id;

  @HiveField(1)
  final String fromStation;

  @HiveField(2)
  final String toStation;

  @HiveField(3)
  final String dateTime;



  final String? routeCode;
  final String? mode;
  final int? durationMin;
  final double? fareEGP;
  final String? crowdLevel;

  const TripHistoryModel({
     this.id,
    required this.fromStation,
    required this.toStation,
    required this.dateTime,
    this.routeCode,
    this.mode,
    this.durationMin,
    this.fareEGP,
    this.crowdLevel,

  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryModel(
      id: json['id'] as String?,
      fromStation: json['from_station'] as String? ??
          json['from_transport'] as String? ??
          '',
      toStation: json['to_station'] as String? ??
          json['to_transport'] as String? ??
          '',
      dateTime: json['date_time'] as String? ?? json['dateTime'] as String? ?? '',
      routeCode: json['route_code'] as String?,
      mode: json['mode'] as String?,
      durationMin: (json['duration_min'] as num?)?.toInt(),
      fareEGP: (json['fare_egp'] as num?)?.toDouble(),
      crowdLevel: json['crowd_level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_station': fromStation,
      'to_station': toStation,
      'date_time': dateTime,
      if (routeCode != null) 'route_code': routeCode,
      if (mode != null) 'mode': mode,
      if (durationMin != null) 'duration_min': durationMin,
      if (fareEGP != null) 'fare_egp': fareEGP,
      if (crowdLevel != null) 'crowd_level': crowdLevel,
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
        routeCode: routeCode ?? this.routeCode,
      mode: mode ?? this.mode,
      durationMin: durationMin ?? this.durationMin,
      fareEGP: fareEGP ?? this.fareEGP,
      crowdLevel: crowdLevel ?? this.crowdLevel,

    );
  }
}
