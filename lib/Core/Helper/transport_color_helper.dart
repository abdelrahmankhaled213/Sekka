import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../../../../../Core/Constants/app_color.dart';
import '../../Features/Auth/Logic/transport_model.dart';

abstract class TransportColorsHelper {

  static Color background(bool isSelected) =>
      isSelected ? const Color(0xffE7F3FB) : const Color(0xffF5F6F8);

  static Color border(bool isSelected) =>
      isSelected ? AppColor.main : const Color(0xFFE0E0E0);

  static Color iconBackground(TransportType type) {
    switch (type) {
      case TransportType.transfer:
        return AppColor.main;
      case TransportType.metro:
        return AppColor.main;
      case TransportType.bus:
        return AppColor.green;
      case TransportType.monorail:
        return AppColor.secondary;
      case TransportType.microbus:
        return AppColor.orange;
    }
  }

 static IconData icon(TransportType type) {
    switch (type) {
      
      case TransportType.bus:
        return Icons.directions_bus;

      case TransportType.metro:
        return Icons.subway;

      case TransportType.monorail:
        return Icons.train;

      case TransportType.microbus:
        return Icons.directions_bus;
      
      case TransportType.transfer:
        return Icons.swap_horiz;
    }
  }



}