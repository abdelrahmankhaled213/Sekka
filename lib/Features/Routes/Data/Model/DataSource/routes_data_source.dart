import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Data/Model/fetch_params.dart';
import 'package:sekka/Features/Routes/Data/Model/params_route_path.dart';
import 'package:sekka/Features/Routes/Data/Model/params_search.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoutesDataSource {


  
final SupabaseClient supabaseClient;

RoutesDataSource({required this.supabaseClient});

Future<List<Transport>> fetchMetros(ParamsOfFetchRoutes params) async {

  final response = await supabaseClient.
  rpc('get_stops_paginated',params: params.toJson()).select();
      
  final data = response as List<dynamic>;

  return data.map((json) => Transport.fromJson(json)).toList();
}

Future<List<Transport>> fetchMetrosWithFilter(ParamsOfFetchRoutesWithSearch params) async {

  final response = await supabaseClient.
  rpc('get_stops_by_search',params: params.toJson()).select();
      
  final data = response as List<dynamic>;

  return data.map((json) => Transport.fromJson(json)).toList();
}

Future<List<Transport>> fetchTransportsPath(ParamsRoutePath params) async {

  final response = await supabaseClient.
  rpc('get_route_between_stops',params:params.toJson()).select();
     
  final data = response as List<dynamic>;

  return data.map((json) => Transport.fromJson(json)).toList();

}


}