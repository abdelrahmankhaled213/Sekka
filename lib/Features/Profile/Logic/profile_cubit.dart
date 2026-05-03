import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';

import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:sekka/Features/Profile/Data/DataSource/Repo/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  
  final ProfileRepo repo;

  ProfileCubit(this.repo) : super(ProfileState(
     profileStateEnum: ProfileStateEnum.initial
  ));


TextEditingController nameController = TextEditingController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

void initSelectedTransport(List<TransportType> favList) {

  emit(state.copyWith(selectedTransports: favList));

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

  Future<void> getProfile() async {
    
    emit(state.copyWith(
      profileStateEnum: ProfileStateEnum.getProfileLoading
    ));
    try{



      final profile = await repo.getUser(FirebaseAuth.instance.currentUser!.uid);


      if(isClosed) return;


      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.getProfileSuccess,
       
        userModel: profile,
       selectedTransports: profile.favTrasnportation??[],
       isImageRemoved: false,
     
      ));

    }catch(e){


      final failure=ErrorHandler.handleError(e);
      emit(state.copyWith(
        profileStateEnum: ProfileStateEnum.getProfileError,
        errorMsg: failure.message
      ));
    }

  }


void removeNetworkImage(){

  final currentUser=state.userModel;
  if(currentUser==null) return;
    
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

Future<void> editProfile(UpdateUserRequest request) async {
  emit(state.copyWith(
    profileStateEnum: ProfileStateEnum.editProfileLoading,
  ));

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



@override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}