import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TripHistoryRemoteDataSource {

  final SupabaseClient supabaseClient;

  const TripHistoryRemoteDataSource(this.supabaseClient);

  Future<List<TripHistoryModel>> getTrips() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final data = await supabaseClient
        .from('trips_history')
        .select()
        .eq('user_id', userId)
        .order('date_time', ascending: false);

    return (data as List)
        .map((json) => TripHistoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTrip(TripHistoryModel trip) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await supabaseClient.from('trips_history').insert({
      ...trip.toJson(),
      'user_id': userId,
    });
  }

  Future<void> deleteTrip(String tripId) async {
    await supabaseClient.from('trips_history').delete().eq('id', tripId);
  }
}
