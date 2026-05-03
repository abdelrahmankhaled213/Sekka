import 'package:sekka/Features/Auth/Logic/transport_model.dart';

class UpdateUserRequest {
  final String? name;
  final String? image;
  final bool clearImage;
  final List<TransportType>? favTrasnportation;
  final bool? isGetStarted;
  final String? phone;
  const UpdateUserRequest({
    this.phone,
    this.name,
    this.image,
    this.clearImage = false,
    this.favTrasnportation,
    this.isGetStarted,
  });

 
  Map<String, dynamic> toMap() {
    
    final map = <String, dynamic>{};

    if (name != null) map['name'] = name;
    if(phone!=null) map['phone'] = phone;
    if (clearImage) {
      map['image'] = null;
    } else if (image != null) {
      map['image'] = image;
    }
    if (favTrasnportation != null) {
      map['Favourite_Transport'] =
          favTrasnportation!.map((e) => e.name).toList();
    }
    if (isGetStarted != null) map['flag'] = (isGetStarted??false)?1:0;

    return map;
  }

  bool get isEmpty => toMap().isEmpty;
}