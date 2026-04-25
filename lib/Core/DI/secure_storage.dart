import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Database/secure_storage.dart';

Future<void>initSecureStorage()async{

getIt.registerLazySingleton(() => SecureStorageService());

}