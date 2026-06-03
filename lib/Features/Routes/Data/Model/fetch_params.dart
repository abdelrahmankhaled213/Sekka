

import 'package:sekka/Core/Helper/transport_type_helper.dart';

class ParamsOfFetchRoutes {
 final int limit;
 final int offset;
 final TransportType? type;

 ParamsOfFetchRoutes({required this.limit, required this.offset,required this.type});

Map<String, dynamic> toJson() {
  return {

    'p_transport_type': type?.toJson(),
    'p_limit': limit,
    'p_offset': offset,
  
  };
}

 }