import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NearestStationDataSource {
  final SupabaseClient supabaseClient;

  NearestStationDataSource({required this.supabaseClient});

  Future<List<NearestStationModel>> getNearestStops({
    required double lat,
    required double lng,
    TransportType? type,
    int limit = 10,
  }) async {
    final params = <String, dynamic>{
      'p_lat': lat,
      'p_lng': lng,
      'p_limit': limit,
      if (type != null) 'p_type': type.toJson(),
    };

    final response = await supabaseClient
        .rpc('get_nearest_stops', params: params)
        .select();

    final data = response as List<dynamic>;

    return data
        .map((json) => NearestStationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
