import 'package:dio/dio.dart';
import 'package:sekka/Core/API/api_constants.dart';
import 'package:sekka/Core/API/api_service.dart';
import 'package:sekka/Core/API/dio_consumer.dart';
import 'package:sekka/Core/DI/service_locator.dart';

void initDio(){

final Dio dio = Dio(
  BaseOptions(
    baseUrl:baseUrlSekaa,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
   sendTimeout: const Duration(seconds: 30),
   headers: {
    
     'Content-Type': 'application/json',
     'x-vercel-protection-bypass':'zkxcjzxkjckzxcjlkxzkcjzxlkcjzklx'
   }
  ),
);

  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio:dio));



}