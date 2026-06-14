import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Profile/Data/DataSource/Repo/profile_repo.dart';
import 'package:sekka/Features/Profile/Profile/Logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repo;

  ProfileCubit(this.repo)
      : super(const ProfileState(profileStateEnum: ProfileStateEnum.initial));

  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Transport selection ──────────────────────────────────────

  void initSelectedTransport(List<TransportType?> favList) {
    // Filter out nulls so the list stays List<TransportType>
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

  // ── Load profile ─────────────────────────────────────────────

  Future<void> getProfile() async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.getProfileLoading));
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final profile = await repo.getUser(userId);
      if (isClosed) return;
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.getProfileSuccess,
        userModel: profile,
        // Filter nulls from favTrasnportation (which is List<TransportType?>?)
        selectedTransports:
        profile.favTrasnportation?.whereType<TransportType>().toList() ??
            [],
        isImageRemoved: false,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.getProfileError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Image helpers ────────────────────────────────────────────

  void removeNetworkImage() {
    final currentUser = state.userModel;
    if (currentUser == null) return;
    emit(state.copyWith(
      userModel: currentUser.copyWith(image: null),
      isImageRemoved: true,
    ));
  }

  void clearRemovedImageFlag() {
    if (state.isImageRemoved) {
      emit(state.copyWith(isImageRemoved: false));
    }
  }

  // ── Edit profile ─────────────────────────────────────────────

  Future<void> editProfile(UpdateUserRequest request) async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.editProfileLoading));
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await repo.editUser(request);
      final updatedUser = await repo.getUser(userId);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.editProfileSuccess,
        userModel: updatedUser,
        isImageRemoved: false,
      ));
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.editProfileError,
        errorMsg: failure.message,
      ));
    }
  }

  // ── Logout ───────────────────────────────────────────────────

  Future<void> logout() async {
    emit(state.copyWith(profileStateEnum: ProfileStateEnum.logoutLoading));
    try {
      await FirebaseAuth.instance.signOut();
      emit(state.copyWith(profileStateEnum: ProfileStateEnum.logoutSuccess));
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.logoutError,
        errorMsg: failure.message,
      ));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
