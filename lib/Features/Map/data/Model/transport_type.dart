enum TransportType { metro, monorail, bus, microbus }

extension TransportTypeX on TransportType {
  String toJson() {
    switch (this) {
      case TransportType.metro:    return 'metro';
      case TransportType.monorail: return 'monorail';
      case TransportType.bus:      return 'bus';
      case TransportType.microbus: return 'microbus';
    }
  }

  String get label {
    switch (this) {
      case TransportType.metro:    return 'Metro';
      case TransportType.monorail: return 'Monorail';
      case TransportType.bus:      return 'Bus';
      case TransportType.microbus: return 'Microbus';
    }
  }

  // أيقونة كل نوع
  String get emoji {
    switch (this) {
      case TransportType.metro:    return '🚇';
      case TransportType.monorail: return '🚝';
      case TransportType.bus:      return '🚌';
      case TransportType.microbus: return '🚐';
    }
  }

  static TransportType? fromString(String? val) {
    if (val == null) return null;
    return TransportType.values.firstWhere(
      (e) => e.toJson() == val.toLowerCase(),
      orElse: () => TransportType.bus,
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
      default:       return CrowdingLevel.unknown;
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
