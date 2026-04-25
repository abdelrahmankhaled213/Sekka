import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';

Future<void>initNotificationDI()async{
  
getIt.registerLazySingleton(() => NotificationHelper(secureStoargeService: getIt()
, apiConsumer: getIt()));  

}