import 'package:hive/hive.dart';
import 'package:sekka/Features/Routes/Data/Model/trip_model.dart';
import 'package:uuid/uuid.dart';

part 'trip_history_model.g.dart';


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


  // ── Extra fields (not Hive-persisted – fetched from remote) ──
  final String? userId;
  final String? routeCode;
  final String? mode;       // 'metro' | 'monorail' | 'bus' | 'microbus'
  final int? durationMin;
  final double? fareEGP;
  final String? crowdLevel;
  final double? co2Saved;

  const TripHistoryModel({
    this.userId,
    required this.id,
    required this.fromStation,
    required this.toStation,
    required this.dateTime,
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
      'id': const Uuid().v4(),
      'user_id': userId,
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

    String? routeCode,
    String? mode,
    int? durationMin,
    double? fareEGP,
    String? crowdLevel,
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
