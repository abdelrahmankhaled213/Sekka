import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {

final SupabaseClient client;

RemoteDataSource(this.client);

Future<void> post(ItemModel data)async{

return await client.from('posts').insert(data);
}

}
