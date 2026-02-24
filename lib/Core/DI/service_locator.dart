import 'package:get_it/get_it.dart';
import 'package:sekka/Core/Database/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt=GetIt.instance;

void setUpServiceLocator()async{

  final sharedpref=await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedpref,);
  getIt.registerLazySingleton(() => CacheHelper(getIt<SharedPreferences>()));

}