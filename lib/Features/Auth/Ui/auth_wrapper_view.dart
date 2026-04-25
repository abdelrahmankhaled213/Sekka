import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import 'package:sekka/Features/Auth/Ui/auth_wrapper.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      return getIt<AuthCubit>();
    },
    child: AuthFlowView(),
    );
  }
}
