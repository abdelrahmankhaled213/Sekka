
import 'package:sekka/Features/Profile/Profile/Data/DataSource/trip_history_local_data_source.dart';
import 'package:sekka/Features/Profile/Profile/Data/DataSource/trip_history_remote_data_source.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';

class TripHistoryRepository {
  final TripHistoryRemoteDataSource remoteDataSource;
  final TripHistoryLocalDataSource localDataSource;

  const TripHistoryRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<TripHistoryModel>> getTrips() async {
    try {
      final remoteTrips = await remoteDataSource.getTrips();
      await localDataSource.saveAllTrips(remoteTrips);
      return remoteTrips;
    } catch (_) {
      return localDataSource.getTrips();
    }
  }

  Future<void> createTrip(TripHistoryModel trip) async {
    await remoteDataSource.createTrip(trip);
    await localDataSource.saveTrip(trip);
  }

  Future<void> deleteTrip(String tripId) async {
    await remoteDataSource.deleteTrip(tripId);
    await localDataSource.deleteTrip(tripId);
  }

  Future<int> getTotalTrips() => localDataSource.getTotalTrips();


}
