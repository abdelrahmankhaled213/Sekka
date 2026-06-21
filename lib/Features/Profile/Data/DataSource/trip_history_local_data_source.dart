import 'package:hive/hive.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

class TripHistoryLocalDataSource {
  static const String _boxName = 'tripHistory';


// في TripHistoryLocalDataSource — عدل الـ _box getter
Future<Box<TripHistoryModel>> get _box async {
  if (!Hive.isBoxOpen(_boxName)) {
    try {
      await Hive.openBox<TripHistoryModel>(_boxName);
    } catch (e) {
      // لو في corruption — امسح وافتح من أول
      await Hive.deleteBoxFromDisk(_boxName);
      await Hive.openBox<TripHistoryModel>(_boxName);
    }
  }
  return Hive.box<TripHistoryModel>(_boxName);
}
  // ── Save Single Trip ──────────────────────────────────────────────────────
  Future<void> saveTrip(TripHistoryModel trip) async {
    final box = await _box;
    await box.put(trip.id, trip);
  }

  // ── Save All Trips ────────────────────────────────────────────────────────
  Future<void> saveAllTrips(List<TripHistoryModel> trips) async {
    final box = await _box;
    final map = {for (final t in trips) t.id: t};
    await box.putAll(map);
  }

  // ── Get All Trips ─────────────────────────────────────────────────────────
  Future<List<TripHistoryModel>> getTrips() async {
    final box = await _box;
    final list = box.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  // ── Get Single Trip Details (الدالة الجديدة) ──────────────────────────────
  Future<TripHistoryModel> getTripDetails(String tripId) async {
    final box = await _box;
    final trip = box.get(tripId);
    
    if (trip == null) {
      throw Exception("Trip not found in local storage");
    }
    return trip;
  }

  // ── Delete Trip ───────────────────────────────────────────────────────────
  Future<void> deleteTrip(String tripId) async {
    final box = await _box;
    await box.delete(tripId);
  }

  // ── Get Total Trips Count ─────────────────────────────────────────────────
  Future<int> getTotalTrips() async {
    final box = await _box;
    return box.length;
  }

  // ── Clear All Cache ───────────────────────────────────────────────────────
  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}