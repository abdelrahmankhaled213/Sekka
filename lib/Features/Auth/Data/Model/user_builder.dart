import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import '../../Logic/transport_model.dart';

class UserBuilder {

  final LocalUserDataSource localDataSource;

  UserBuilder(this.localDataSource);

  Future<UserModel> buildUser({

    required String id,
    String? email,
    String? phone,
    String? name,
    String? image,
    List<TransportType>? transport,
    bool? isGetStarted
    
  }) async {

    final cached = await localDataSource.getUser(id);

    final safeCached = cached ?? UserModel();

    return safeCached.copyWith(
      id: id,
      email: email ?? safeCached.email,
      phone: phone ?? safeCached.phone,
      name: name ?? safeCached.name,
      image: image ?? safeCached.image,
      favTrasnportation:
       transport ?? safeCached.favTrasnportation,
       isGetStarted:  isGetStarted??safeCached.isGetStarted??false
    );
  }
}