import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/DataSource/remote_data_source.dart';

class LostAndFoundRepo {

  final RemoteDataSource remoteDataSource;

  LostAndFoundRepo({required this.remoteDataSource});

Future<void> post(ItemModel data) async {
  return await remoteDataSource.post(data);
}

Future<List<ItemModel>>getPosts() async{
return await remoteDataSource.fetchLostAndFoundPosts();
}

}