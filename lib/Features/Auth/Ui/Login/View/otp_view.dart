import 'package:flutter/material.dart';
import '../Widget/otp_body.dart';

class OtpView extends StatelessWidget {

  final String phoneNumber;

  const OtpView({super.key,required this.phoneNumber
    ,});

  @override
  Widget build(BuildContext context) {

    return OtpBody(phoneNumber: phoneNumber);

  }
}
