import 'package:sekka/Features/Routes/Data/Model/DataSource/routes_data_source.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Data/Model/fetch_params.dart';
import 'package:sekka/Features/Routes/Data/Model/params_route_path.dart';
import 'package:sekka/Features/Routes/Data/Model/params_search.dart';

class RoutesRepo {

final RoutesDataSource routesDataSource;

RoutesRepo({required this.routesDataSource});

Future<List<Transport>> fetchTransports(ParamsOfFetchRoutes params) async {
 final metros = await routesDataSource.fetchMetros(params);
  return metros;
}

Future<List<Transport>> fetchTransportsFilter(ParamsOfFetchRoutesWithSearch params) async {

 final metros = await routesDataSource.fetchMetrosWithFilter(params);
  return metros;

}

Future<List<Transport>> fetchTransportsPath(ParamsRoutePath params) async{

final data=await routesDataSource.fetchTransportsPath(params);

print("data length ${data.length}");

return data;

}


}