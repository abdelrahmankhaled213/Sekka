import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WhereToGoRepo {

  final SupabaseClient _client;

  WhereToGoRepo(this._client);

  Future<List<SegmentModel>> fetchRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final response = await _client.rpc(
      'get_route_segments_by_location',
      params: {
        'p_start_lat': startLat,
        'p_start_lng': startLng,
        'p_end_lat':   endLat,
        'p_end_lng':   endLng,
      },
    );

    return parseSegments(response as List);
  }
}