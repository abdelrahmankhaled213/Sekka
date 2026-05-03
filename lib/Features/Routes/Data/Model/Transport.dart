import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
class Transport{
final int? id;
final String name;
final GeoPoint location;
final String? routeName;
final List<String>?busNumbers;
final String? directionName ;
final TransportType? type;

Transport({

   this.type,
this.id,
  required this.name,
  required this.location,
required this.directionName,
   this.routeName,
  this.busNumbers
});


  factory Transport.fromJson(Map<String, dynamic> json){
   return Transport(
    
        directionName: json['direction_name'],
        id:json['id'],
         type: json['edge_type']==null?null:TransportTypeMapper.fromJson(json['edge_type']),
        name: json['stop_name'],
        location: GeoPoint.fromJson(json['location']),
        routeName: json['routes'],
        busNumbers: json['bus_numbers']

        );
  }
}

class GeoPoint {

  final double lat;
  final double lng;

  GeoPoint({
    required this.lat,
    required this.lng,
  });

  factory GeoPoint.fromJson(dynamic json) {

    final coords = json['coordinates'];
    
    return GeoPoint(
      lng: coords[0].toDouble(), // longitude
      lat: coords[1].toDouble(), // latitude
    );
  }
}