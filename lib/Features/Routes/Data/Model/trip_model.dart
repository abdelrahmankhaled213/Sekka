
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';

enum TripStatus {
  active,
  completed,
  cancelled,
}

class TripModel {

  final String id;

  final int startStationId;

  final String startStationName;
  

  final int endStationId;

  final String endStationName;

  final GeoPoint destLocation;

  final String date;

  final TripStatus status;

  final String? fcmToken;

  TripModel({
    required this.id,
    required this.startStationId,
    required this.startStationName,
    required this.endStationId,
    required this.endStationName,
    required this.destLocation,
    required this.date,
    this.status = TripStatus.active,
    this.fcmToken,
  });

  TripModel copyWith({TripStatus? status}) => TripModel(
        id: id,
        startStationId: startStationId,
        startStationName: startStationName,
        endStationId: endStationId,
        endStationName: endStationName,
        destLocation: destLocation,
        date: date,
        status: status ?? this.status,
        fcmToken: fcmToken,
      );

  Map<String, dynamic> toJson() => {
        'start_station_id': startStationId,
        'end_station_id': endStationId,
        'fcm_token': fcmToken,
        'date': date,
        'status': status.toString(),
      };

  
}