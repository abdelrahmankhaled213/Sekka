import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

class TripHistoryLocalDataSource {
  static const String _boxName = 'tripHistory';

  // Guards against concurrent open attempts (the race condition).
  static Future<Box<TripHistoryModel>>? _openingFuture;

  Future<Box<TripHistoryModel>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<TripHistoryModel>(_boxName);
    }
    // If an open is already in flight, await the same future instead of
    // racing it with a second open/delete.
    return _openingFuture ??= _openSafely().whenComplete(() {
      _openingFuture = null;
    });
  }

  Future<Box<TripHistoryModel>> _openSafely() async {
    try {
      return await Hive.openBox<TripHistoryModel>(_boxName);
    } catch (e) {
      // Box file is corrupted/truncated — wipe it and start fresh.
      await _forceDeleteBoxFiles();
      return await Hive.openBox<TripHistoryModel>(_boxName);
    }
  }

  Future<void> _forceDeleteBoxFiles() async {
    try {
      await Hive.deleteBoxFromDisk(_boxName);
    } catch (_) {
      // Hive's own delete can throw (e.g. missing .lock file). Fall back
      // to removing the known files by hand so we don't get stuck.
      try {
        final dir = await getApplicationDocumentsDirectory();
        for (final ext in ['.hive', '.lock']) {
          final file = File('${dir.path}/$_boxName$ext');
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (_) {
        // Ignore — if this fails too, the next openBox call will surface
        // a clear error instead of a silent crash loop.
      }
    }
  }

  // ── rest of your methods unchanged ──
  Future<void> saveTrip(TripHistoryModel trip) async {
    final box = await _box;
    await box.put(trip.id, trip);
  }

  Future<void> saveAllTrips(List<TripHistoryModel> trips) async {
    final box = await _box;
    final map = {for (final t in trips) t.id: t};
    await box.putAll(map);
  }

  Future<List<TripHistoryModel>> getTrips() async {
    final box = await _box;
    final list = box.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  Future<TripHistoryModel> getTripDetails(String tripId) async {
    final box = await _box;
    final trip = box.get(tripId);
    if (trip == null) {
      throw Exception("Trip not found in local storage");
    }
    return trip;
  }

  Future<void> deleteTrip(String tripId) async {
    final box = await _box;
    await box.delete(tripId);
  }

  Future<int> getTotalTrips() async {
    final box = await _box;
    return box.length;
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}