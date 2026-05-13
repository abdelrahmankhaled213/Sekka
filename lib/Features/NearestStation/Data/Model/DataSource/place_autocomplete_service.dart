import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';

class PlaceAutocompleteService {
  static const _apiKey = 'AIzaSyD8wJ57Gu5X__PvixWBSbknjnDL41YBjcY';
  static const _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<PlacePrediction>> getSuggestions(String input) async {
    if (input.trim().isEmpty) return [];

    final uri = Uri.parse(
      '$_baseUrl/autocomplete/json'
          '?input=${Uri.encodeComponent(input)}'
          '&key=$_apiKey'
          '&components=country:eg',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body) as Map<String, dynamic>;
    final status = data['status'] as String?;

    if (status != 'OK' && status != 'ZERO_RESULTS') return [];
    if (status == 'ZERO_RESULTS') return [];

    return (data['predictions'] as List)
        .map((e) => PlacePrediction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<({double lat, double lng})?> getPlaceLocation(String placeId) async {
    final uri = Uri.parse(
      '$_baseUrl/details/json'
          '?place_id=$placeId'
          '&fields=geometry'
          '&key=$_apiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return null;

    final location =
    data['result']['geometry']['location'] as Map<String, dynamic>;

    return (
    lat: (location['lat'] as num).toDouble(),
    lng: (location['lng'] as num).toDouble(),
    );
  }
}
