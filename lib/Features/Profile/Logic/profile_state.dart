import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';

enum ProfileStateEnum{
  initial,
  getProfileLoading,
  getProfileSuccess,
  getProfileError,
  editProfileLoading,
  editProfileSuccess,
  editProfileError
}
class ProfileState extends Equatable{

final ProfileStateEnum profileStateEnum;
final UserModel? userModel;
final UpdateUserRequest?updateUserRequest;

final String? errorMsg;
final List<TransportType> selectedTransports;
final bool isImageRemoved;


  const ProfileState({
    this.userModel,
    required this.profileStateEnum
  , this.updateUserRequest,this.errorMsg, this.selectedTransports = const [], this.isImageRemoved = false,});

  ProfileState copyWith({
    ProfileStateEnum? profileStateEnum,
    UserModel? userModel,
    UpdateUserRequest?updateUserRequest,
    String? errorMsg,
   TransportType? selectedTransport,
  List<TransportType>? selectedTransports,
  bool? isImageRemoved,
  }) {
    return ProfileState(
      profileStateEnum: profileStateEnum ?? this.profileStateEnum,
      updateUserRequest: updateUserRequest ?? this.updateUserRequest,
      errorMsg: errorMsg ?? this.errorMsg,
      userModel: userModel ?? this.userModel,
      selectedTransports:  selectedTransports ?? this.selectedTransports,
      isImageRemoved: isImageRemoved ?? this.isImageRemoved,

    );
  }
  
  @override
  List<Object?> get props => [profileStateEnum,updateUserRequest,errorMsg,selectedTransports,userModel,isImageRemoved];
  
}