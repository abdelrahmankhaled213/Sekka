import 'package:hive_flutter/hive_flutter.dart';
part 'transport_type_helper.g.dart';

@HiveType(typeId: 1)
enum TransportType {
  @HiveField(0)
  metro,
  @HiveField(1)
  monorail,
  @HiveField(2)
  bus,
  @HiveField(3)
  microbus,
  @HiveField(4)
  transfer,
}

extension TransportTypeX on TransportType {

  String? toJson() {
    switch (this) {

      case TransportType.metro:    return 'metro';
      case TransportType.monorail: return 'monorail';
      case TransportType.bus:      return 'bus';
      case TransportType.microbus: return 'microbus';

      default: return null;
 
    }
  }

  String get label {
    switch (this) {
      case TransportType.metro:    return 'Metro';
      case TransportType.monorail: return 'Monorail';
      case TransportType.bus:      return 'Bus';
      case TransportType.microbus: return 'Microbus';
      case TransportType.transfer: return 'Transfer';
    }
  }

  
  static TransportType? fromString(String? val) {
    if (val == null) return null;
    return TransportType.values.firstWhere(
      (e) => e.toJson() == val.toLowerCase(),
      orElse: () => TransportType.bus,
    );
  }

  static TransportType fromJson(String value) {
    return TransportType.values.firstWhere(
      (e) => e.toJson() == value,
    );
  }
}

enum CrowdingLevel { low, medium, high, unknown }

extension CrowdingLevelX on CrowdingLevel {

  static CrowdingLevel fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'low':    return CrowdingLevel.low;
      case 'medium': return CrowdingLevel.medium;
      case 'high':   return CrowdingLevel.high;
      default:       return CrowdingLevel.low;
    }
  }

  String get label {
    switch (this) {
      case CrowdingLevel.low:     return 'Not Crowded';
      case CrowdingLevel.medium:  return 'Moderate';
      case CrowdingLevel.high:    return 'Crowded';
      case CrowdingLevel.unknown: return 'Unknown';
    }
  }
}