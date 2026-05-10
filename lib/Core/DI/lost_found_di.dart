import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/LostAndFound/Data/Repo/lost_and_found_repo.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';

import '../../Features/LostAndFound/Data/DataSource/remote_data_source.dart';

void initLostAndFound(){
  
 getIt.registerLazySingleton(() => RemoteDataSource(
  getIt(),getIt(),
 )); 
 
getIt.registerLazySingleton(() => LostAndFoundRepo(remoteDataSource: getIt()));

getIt.registerFactory(() => LostAndFoundCubit(getIt()));
getIt.registerFactory(() => ChatCubit(lostAndFoundRepo: getIt()));

}