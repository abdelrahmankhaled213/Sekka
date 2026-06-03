import 'package:sekka/Features/Profile/Data/DataSource/trip_history_local_data_source.dart';
import 'package:sekka/Features/Profile/Data/DataSource/trip_history_remote_data_source.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

class TripHistoryRepository {
  final TripHistoryRemoteDataSource remoteDataSource;
  final TripHistoryLocalDataSource localDataSource;

  TripHistoryRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<void> createTrip(TripHistoryModel trip) async {
    await remoteDataSource.createTrip(trip);
    await localDataSource.saveTrip(trip);
  }

  Future<List<TripHistoryModel>> getTrips() async {
    try {
      final remoteTrips = await remoteDataSource.getTrips('user_id');
      for (final trip in remoteTrips) {
        await localDataSource.saveTrip(trip);
      }
      return remoteTrips;
    } catch (e) {
      return await localDataSource.getTrips();
    }
  }

  Future<void> deleteTrip(String tripId) async {
    await remoteDataSource.deleteTrip(tripId);
    await localDataSource.deleteTrip(tripId);
  }

  Future<int> getTotalTrips() async {
    return await localDataSource.getTotalTrips();
  }

  Future<int> getCompletedTrips() async {
    return await localDataSource.getCompletedTrips();
  }

  Future<int> getCancelledTrips() async {
    return await localDataSource.getCancelledTrips();
  }
}
