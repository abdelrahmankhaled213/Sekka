import 'package:flutter/material.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';

class TransportUIHelper {
  static IconData icon(TransportType? type) {
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
      default:
        return Icons.location_on;
    }
  }

  static Color color(TransportType? type) {
    switch (type) {
      case TransportType.bus:
        return AppColor.lightGreen;

      case TransportType.metro:
        return AppColor.lightBlue;

      case TransportType.monorail:
        return AppColor.lightPurple;

      case TransportType.microbus:
        return AppColor.orange;

      case TransportType.transfer:
        return AppColor.grey;
      default:
        return AppColor.grey;
    }
  }

  static String label(TransportType? type) {
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
      default:
        return "All";
    }
  }
}