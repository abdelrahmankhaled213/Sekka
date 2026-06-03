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
  final String fromTransport;

  @HiveField(2)
  final String toTransport;

  @HiveField(3)
  final String dateTime;

  @HiveField(4)
  final TripStatus status;

  TripHistoryModel({
    required this.id,
    required this.fromTransport,
    required this.toTransport,
    required this.dateTime,
    required this.status,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryModel(
      id: json['id'] as String,
      fromTransport: json['from_transport'] as String,
      toTransport: json['to_transport'] as String,
      dateTime: json['date_time'] as String,
      status: json['status'] == 'completed' ? TripStatus.completed : TripStatus.cancelled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_transport': fromTransport,
      'to_transport': toTransport,
      'date_time': dateTime,
      'status': status == TripStatus.completed ? 'completed' : 'cancelled',
    };
  }

  TripHistoryModel copyWith({
    String? id,
    String? fromTransport,
    String? toTransport,
    String? dateTime,
    TripStatus? status,
  }) {
    return TripHistoryModel(
      id: id ?? this.id,
      fromTransport: fromTransport ?? this.fromTransport,
      toTransport: toTransport ?? this.toTransport,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }
}
