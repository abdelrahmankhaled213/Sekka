
import 'package:sekka/Features/Profile/Data/DataSource/trip_history_local_data_source.dart';
import 'package:sekka/Features/Profile/Data/DataSource/trip_history_remote_data_source.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';
// تذكر تغير المسار ده لمسار الـ Entity الصح في مشروعك

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
      
      print('Remote Trips: ${remoteTrips.length}');
      await localDataSource.saveAllTrips(remoteTrips);
      
      return remoteTrips;
    } catch (e,stackTrace) {
      print('⚠️ Failed to fetch trips from remote: $e');
      print(stackTrace);
      // لو مفيش نت أو حصل مشكلة في السيرفر، بنرجع الـ الكاش
      return await localDataSource.getTrips();
    }
  }

  // ── Get Single Trip Details ───────────────────────────────────────────────
  Future<TripHistoryModel> getTripDetails(String tripId) async {
    try {
      final remoteTrip = await remoteDataSource.getTripDetails(tripId);
      // ممكن برضه تعمل سيف للـ trip دي لوحدها في اللوكال لو حابب تضمن إنها تتحدث
      await localDataSource.saveTrip(remoteTrip); 
      return remoteTrip;
    } catch (_) {
      // لو مفيش نت، جيب تفاصيل الرحلة دي من الـ Local
      return await localDataSource.getTripDetails(tripId);
    }
  }

  // ── Create Trip ───────────────────────────────────────────────────────────
  Future<void> createTrip(TripHistoryModel trip) async {
    await remoteDataSource.createTrip(trip);
    await localDataSource.saveTrip(trip);
  }
  // ── Delete Trip ───────────────────────────────────────────────────────────
  Future<void> deleteTrip(String tripId) async {
    await remoteDataSource.deleteTrip(tripId);
    await localDataSource.deleteTrip(tripId);
  }

  // ── Get Total Trips Count ─────────────────────────────────────────────────
  Future<int> getTotalTrips() async {
    return await localDataSource.getTotalTrips();
  }
}