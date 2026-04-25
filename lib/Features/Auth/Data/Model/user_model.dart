import 'package:hive/hive.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import '../../Logic/transport_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? phone;

  @HiveField(2)
  final String? image;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? name;

  @HiveField(5)
  final List<TransportType>? favTrasnportation;

  @HiveField(6)
  final bool? isGetStarted;

  UserModel({

    this.isGetStarted,
    this.id,
    this.phone,
    this.image,
    this.email,
    this.name,
    this.favTrasnportation,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      image: json["image"],
      favTrasnportation: json["Favourite_Transport"] == null
          ? []
          : List<String>.from(json["Favourite_Transport"])
          .map((e) => TransportTypeMapper.fromJson(e))
          .toList(),
      isGetStarted: json["flag"]==1?true:false,    
    );
  }

Map<String, dynamic> toJson() {
  return {
    'id': id,
    if (email != null) 'email': email,
    if (name != null) 'name': name,
    if (phone != null) 'phone': phone,
    if (image != null) 'image': image,
    if (isGetStarted != null) 'flag': isGetStarted==true?1:0,
    if (favTrasnportation != null)
      'Favourite_Transport': favTrasnportation!.map((e) => e.name).toList(),
  };
}

  UserModel copyWith({
    String? id,
    String? phone,
    String? image,
    String? email,
    String? name,
    List<TransportType>? favTrasnportation,
    bool? isGetStarted
  }) {
    return UserModel(

      isGetStarted: isGetStarted ?? this.isGetStarted,
      id: id ?? this.id,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      email: email ?? this.email,
      name: name ?? this.name,
      favTrasnportation: favTrasnportation ?? this.favTrasnportation,
     
    );
  }


}