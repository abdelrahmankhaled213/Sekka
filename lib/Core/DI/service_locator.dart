import 'package:get_it/get_it.dart';
import 'package:sekka/Core/DI/auth_di.dart';
import 'package:sekka/Core/DI/core_di.dart';
import 'package:sekka/Core/DI/init_dio.dart';
import 'package:sekka/Core/DI/nearest_station_di.dart';
import 'package:sekka/Core/DI/notification_di.dart';
import 'package:sekka/Core/DI/profile_di.dart';
import 'package:sekka/Core/DI/routes_di.dart';
import 'package:sekka/Core/DI/secure_storage.dart';

final getIt = GetIt.instance;

void setUpServiceLocator() async {
 await initCore();
 await initAuthDI();
 await initRoutesDI();
 await initNearestStationDI();
 await initProfileDI();
 await initDio();
 await initSecureStorage();
 await initNotificationDI();
}
