import '../../Features/Auth/Logic/transport_model.dart';

extension TransportTypeMapper on TransportType {


  String toJson() {
    switch (this) {
      case TransportType.transfer:
        return "transfer";
      case TransportType.bus:
        return "bus";
      case TransportType.metro:
        return "metro";
      case TransportType.microbus:
        return "microbus";
      case TransportType.monorail:
        return "monorail";

    }
  }

 static TransportType fromJson(String value) {
    return TransportType.values.firstWhere(
          (e) => e.toJson() == value,
    );
  }
}