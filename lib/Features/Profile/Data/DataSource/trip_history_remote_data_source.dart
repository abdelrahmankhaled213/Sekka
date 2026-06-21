import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripHistoryRemoteDataSource {

  final SupabaseClient supabaseClient;

  const TripHistoryRemoteDataSource(this.supabaseClient);

Future<List<TripHistoryModel>> getTrips() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final data = await supabaseClient
      .from('trip_history')
      .select()
      .eq('user_id', userId); // ← كان 'id' غل

  return (data as List)
      .map((json) => TripHistoryModel.fromJson(json as Map<String, dynamic>))
      .toList();
}
  // ── Get Single Trip Details ───────────────────────────────────────────────
  Future<TripHistoryModel> getTripDetails(String tripId) async {
    final data = await supabaseClient
        .from('trip_history')
        .select()
        .eq('id', tripId)
        .single();

    return TripHistoryModel.fromJson(data as Map<String, dynamic>);
  }

  // ── Create Trip ───────────────────────────────────────────────────────────
  
Future<void> createTrip(TripHistoryModel trip) async {
  await supabaseClient
      .from('trip_history')
      .insert(trip.toJson()); // ← من غير user_id
}
  Future<void> deleteTrip(String tripId) async {
    await supabaseClient.from('trip_history').delete().eq('id', tripId);
  }
}