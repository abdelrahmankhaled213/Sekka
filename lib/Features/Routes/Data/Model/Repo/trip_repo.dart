import 'package:sekka/Core/API/api_service.dart';
import 'package:sekka/Features/Routes/Data/Model/trip_model.dart';

class TripsRepo {
  final ApiConsumer _client;

  TripsRepo(this._client);

  Future<String> startTrip(TripModel trip) async {
    final response = await _client.post('trips', data: trip.toJson());
    return response['id'] as String;
  }

  Future<void> cancelTrip(String tripId) async {
    await _client.put('trips/$tripId/cancelled');
  }

  Future<void> notifyArrival(String tripId) async {
    await _client.put('trips/$tripId/completed');
  }
}