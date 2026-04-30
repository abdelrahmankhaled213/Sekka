import 'package:dio/dio.dart';
import 'api_service.dart';

class DioConsumer extends ApiConsumer {

  final Dio dio;

  DioConsumer({required this.dio});

  @override
  Future delete(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {


  }

  @override
  Future get(String path, {Object? data
    , Map<String, dynamic>? queryParameters}) async {
   
      final response = await dio.
      get(path, queryParameters: queryParameters,
          data: data
      );

      return response.data;
    }

  

  @override
  Future post(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
 
final  response = await dio.post(path, data: data, queryParameters: queryParameters);
print(response.data.toString());
    return response.data;
    
    }

  @override
  Future put(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) {
    // TODO: implement put
    throw UnimplementedError();
  }

}