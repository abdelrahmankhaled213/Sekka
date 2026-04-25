import 'package:flutter/material.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';

class TransportUIHelper {
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

  static Color color(TransportType type) {
    switch (type) {
      case TransportType.bus:
        return AppColor.darkGreen;

      case TransportType.metro:
        return AppColor.darkBlue;

      case TransportType.monorail:
        return AppColor.darkPurple;

      case TransportType.microbus:
        return AppColor.orange;

      case TransportType.transfer:
        return AppColor.grey;
    }
  }

  static String label(TransportType type) {
    switch (type) {
      case TransportType.bus:
        return "Bus";

      case TransportType.metro:
        return "Metro";

      case TransportType.monorail:
        return "Monorail";

      case TransportType.transfer:
        return "Transfer";
      case TransportType.microbus:
        return "Microbus";  
    }
  }
}