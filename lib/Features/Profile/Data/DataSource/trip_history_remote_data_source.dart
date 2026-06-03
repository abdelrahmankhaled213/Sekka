import 'package:sekka/Core/API/dio_consumer.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

class TripHistoryRemoteDataSource {
  final DioConsumer api;

  TripHistoryRemoteDataSource({required this.api});

  Future<void> createTrip(TripHistoryModel trip) async {
    await api.post('/trips', data: trip.toJson());
  }

  Future<List<TripHistoryModel>> getTrips(String userId) async {
    final response = await api.get('/trips?user_id=$userId');
    return (response as List)
        .map((json) => TripHistoryModel.fromJson(json))
        .toList();
  }

  Future<void> deleteTrip(String tripId) async {
    await api.delete('/trips/$tripId');
  }
}
