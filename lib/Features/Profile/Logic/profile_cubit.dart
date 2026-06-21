import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Data/Repo/profile_repo.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  
  final ProfileRepo repo;

  ProfileCubit(this.repo)
      : super(const ProfileState(
          profileStateEnum: ProfileStateEnum.initial,
        ));

  // ── Transport selection ──────────────────────────────────────

  void initSelectedTransport(List<TransportType?> favList) {

    final nonNull = favList.whereType<TransportType>().toList();
    emit(state.copyWith(selectedTransports: nonNull));
  }

  void toggleTransport(TransportType type) {
    final list = List<TransportType>.from(state.selectedTransports);
    if (list.contains(type)) {
      list.remove(type);
    } else {
      list.add(type);
    }
    emit(state.copyWith(selectedTransports: list));
  }








  // ── Get Profile ───────────────────────────────────────────────────────────
  Future<void> getProfile() async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.getProfileLoading));
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final user = await repo.getUser(userId);
      if (isClosed) return;
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.getProfileSuccess,
        userModel: user,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.getProfileError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Update Profile (text fields only) ────────────────────────────────────
  Future<void> editProfile(UpdateUserRequest request) async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.updating));
    try {
      await repo.editUser(request);
      if (isClosed) return;
      // editUser already refreshes remote + local, so re-fetch cached state
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final updatedUser = await repo.getUser(userId);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.updateSuccess,
        userModel: updatedUser,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.updateError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Upload / Replace Profile Image ───────────────────────────────────────
  Future<void> uploadProfileImage(File imageFile) async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.uploadingImage));
    try {
      final newUrl = await repo.uploadProfileImage(imageFile);
      if (isClosed) return;
      final updatedUser = state.userModel?.copyWith(image: newUrl);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.imageUploadSuccess,
        userModel: updatedUser,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.imageUploadError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Delete Profile Image ──────────────────────────────────────────────────
  Future<void> deleteProfileImage() async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.deletingImage));
    try {
      await repo.deleteProfileImage();
      if (isClosed) return;
      final updatedUser = state.userModel?.copyWith(image: null);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.imageDeleteSuccess,
        userModel: updatedUser,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.imageDeleteError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Update Profile with optional image (used by EditProfileBottomSheet) ──
  Future<void> updateProfile({
    required String name,
    required String phone,
    File? imageFile,
  }) async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.updating));
    try {
      // 1. Upload new image if provided
      String? newAvatarUrl;
      if (imageFile != null) {
        newAvatarUrl = await repo.uploadProfileImage(imageFile);
        if (isClosed) return;
      }

      // 2. Update text fields (+ avatar url if changed)
      await repo.editUser(UpdateUserRequest(
        name: name,
        phone: phone,
        image: newAvatarUrl, // null = don't touch existing url on server
      ));
      if (isClosed) return;

      // 3. Re-fetch to get the latest persisted user
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final updatedUser = await repo.getUser(userId);

      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.updateSuccess,
        userModel: updatedUser,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.updateError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await repo.logout();
      if (isClosed) return;
      emit(state.copyWith(profileStateEnum: ProfileStateEnum.logoutSuccess));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.logoutError,
        errorMsg: failure.message,
      ));
    }
  }
}