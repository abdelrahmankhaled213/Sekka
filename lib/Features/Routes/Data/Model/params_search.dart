import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';

class ParamsOfFetchRoutesWithSearch {

  final String searchQuery;
  final TransportType? selectedTransportType;

  ParamsOfFetchRoutesWithSearch({required this.searchQuery, this.selectedTransportType});

Map<String, dynamic> toJson() => {

    'search_text': searchQuery,
    'stop_type_param': selectedTransportType?.toJson(),
  
  };

}