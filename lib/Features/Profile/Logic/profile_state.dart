import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';

enum ProfileStateEnum {
  initial,
  // get profile
  getProfileLoading,
  getProfileSuccess,
  getProfileError,
  // update profile (text)
  updating,
  updateSuccess,
  updateError,
  // image upload
  uploadingImage,
  imageUploadSuccess,
  imageUploadError,
  // image delete
  deletingImage,
  imageDeleteSuccess,
  imageDeleteError,
  // logout
  logoutLoading,
  logoutSuccess,
  logoutError,
}

class ProfileState {
  final ProfileStateEnum profileStateEnum;
  final UserModel? userModel; // غيرت الاسم من user لـ userModel عشان يطابق الاستخدام
  final String? errorMsg;
  
  // ── Transport Preferences ───────────────────────────────
  final List<TransportType> selectedTransports;
  
  // ── Image Management ───────────────────────────────
  final bool isImageRemoved;

  const ProfileState({
    required this.profileStateEnum,
    this.userModel,
    this.errorMsg,
    this.selectedTransports = const [],
    this.isImageRemoved = false,
  });

  ProfileState copyWith({
    ProfileStateEnum? profileStateEnum,
    UserModel? userModel,
    String? errorMsg,
    List<TransportType>? selectedTransports,
    bool? isImageRemoved,
  }) {
    return ProfileState(
      profileStateEnum: profileStateEnum ?? this.profileStateEnum,
      userModel: userModel ?? this.userModel,
      errorMsg: errorMsg,
      selectedTransports: selectedTransports ?? this.selectedTransports,
      isImageRemoved: isImageRemoved ?? this.isImageRemoved,
    );
  }
}