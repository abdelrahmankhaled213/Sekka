import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Database/secure_storage.dart';

void initSecureStorage(){

getIt.registerLazySingleton(() => SecureStorageService());

}