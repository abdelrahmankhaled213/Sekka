import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';

enum ProfileStateEnum {
  initial,
  getProfileLoading,
  getProfileSuccess,
  getProfileError,
  editProfileLoading,
  editProfileSuccess,
  editProfileError,
  logoutLoading,
  logoutSuccess,
  logoutError,
}

class ProfileState extends Equatable {
  final ProfileStateEnum profileStateEnum;
  final UserModel? userModel;
  final UpdateUserRequest? updateUserRequest;
  final String? errorMsg;
  final List<TransportType> selectedTransports; // non-nullable items
  final bool isImageRemoved;

  const ProfileState({
    required this.profileStateEnum,
    this.userModel,
    this.updateUserRequest,
    this.errorMsg,
    this.selectedTransports = const [],
    this.isImageRemoved = false,
  });

  ProfileState copyWith({
    ProfileStateEnum? profileStateEnum,
    UserModel? userModel,
    UpdateUserRequest? updateUserRequest,
    String? errorMsg,
    List<TransportType>? selectedTransports, // non-nullable items
    bool? isImageRemoved,
  }) {
    return ProfileState(
      profileStateEnum: profileStateEnum ?? this.profileStateEnum,
      userModel: userModel ?? this.userModel,
      updateUserRequest: updateUserRequest ?? this.updateUserRequest,
      errorMsg: errorMsg ?? this.errorMsg,
      selectedTransports: selectedTransports ?? this.selectedTransports,
      isImageRemoved: isImageRemoved ?? this.isImageRemoved,
    );
  }

  @override
  List<Object?> get props => [
    profileStateEnum,
    userModel,
    updateUserRequest,
    errorMsg,
    selectedTransports,
    isImageRemoved,
  ];
}
