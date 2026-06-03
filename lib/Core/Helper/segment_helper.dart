import 'package:sekka/Core/Helper/transport_type_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// الـ backend دلوقتي بيرجع segments جاهزة من الـ SQL
// Flutter بس بيعمل parse — مفيش grouping logic هنا خالص
// ─────────────────────────────────────────────────────────────────────────────

enum SegmentPosition { start, transfer, end }

// ─────────────────────────────────────────────────────────────────────────────
// StepModel — stop واحد جوا segment
// ─────────────────────────────────────────────────────────────────────────────

class StepModel {
  final String stopName;
  final String? stopId;
  final double? latitude;
  final double? longitude;

  StepModel({
    required this.stopName,
    this.stopId,
    this.latitude,
    this.longitude,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    double? lat, lng;
    final loc = json['location'];
    if (loc != null) {
      final coords = loc['coordinates'] as List?;
      if (coords != null && coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    }
    return StepModel(
      stopName: json['stop_name'] as String? ?? '',
      stopId:   json['stop_id']?.toString(),
      latitude:  lat,
      longitude: lng,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SegmentModel — segment كامل جاي من الـ SQL
// ─────────────────────────────────────────────────────────────────────────────

class SegmentModel {

  final int segmentId;
  final String? lineName;
  final String? direction;
  final SegmentPosition position;
  final String boardingStop;
  final String alightingStop;
  final String? nextLineName;
  final List<StepModel> stops;
  final int stopsCount;

  // transport type مش جاي من الـ backend — بنحدده من اسم الـ line
  final TransportType type;

  const SegmentModel({
    required this.segmentId,
    required this.position,
    required this.boardingStop,
    required this.alightingStop,
    required this.stops,
    required this.stopsCount,
    required this.type,
    this.lineName,
    this.direction,
    this.nextLineName,
  });

  bool get isStart    => position == SegmentPosition.start;
  bool get isTransfer => position == SegmentPosition.transfer;
  bool get isEnd      => position == SegmentPosition.end;

  // transferAtStop = alighting stop لو مش end
  String? get transferAtStop => isEnd ? null : alightingStop;

  bool get hasMoreStops => stops.length > 6;

  List<StepModel> get previewStops =>
      stops.length <= 6 ? stops : stops.take(6).toList();


int get durationMinutes {
  const Map<TransportType, int> minutesPerStop = {
    TransportType.metro:    2,
    TransportType.monorail: 3,
    TransportType.bus:      5,
    TransportType.microbus: 4,
    TransportType.transfer: 3,
  };
  const Map<TransportType, int> waitingMinutes = {
    TransportType.metro:    3,
    TransportType.monorail: 5,
    TransportType.bus:      7,
    TransportType.microbus: 5,
    TransportType.transfer: 0,
  };
  return (minutesPerStop[type] ?? 3) * stopsCount + (waitingMinutes[type] ?? 0);
}

int get ticketPrice {
  switch (type) {
    case TransportType.metro:
      if (stopsCount <= 9)  return 10;
      if (stopsCount <= 16) return 12;
      if (stopsCount <= 23) return 15;
      return 20;
    case TransportType.monorail:
      if (stopsCount <= 5)  return 20;
      if (stopsCount <= 10) return 40;
      if (stopsCount <= 15) return 55;
      return 80;
    case TransportType.bus:
    case TransportType.microbus:
      return 20;
    case TransportType.transfer:
      return 0;
  }
}
  factory SegmentModel.fromJson(Map<String, dynamic> json) {
    final posStr   = (json['position'] as String?)?.toLowerCase() ?? 'end';
    final position = switch (posStr) {
      'start'    => SegmentPosition.start,
      'transfer' => SegmentPosition.transfer,
      _          => SegmentPosition.end,
    };

    final stopsRaw = json['stops'] as List? ?? [];
    final stops    = stopsRaw
        .map((s) => StepModel.fromJson(s as Map<String, dynamic>))
        .toList();

    final lineName = json['line_name'] as String?;

    return SegmentModel(
      segmentId:    (json['segment_id'] as num).toInt(),
      lineName:     lineName,
      direction:    json['direction_name'] as String?,
      position:     position,
      boardingStop:  json['boarding_stop']  as String? ?? '',
      alightingStop: json['alighting_stop'] as String? ?? '',
      nextLineName:  json['next_line_name'] as String?,
      stops:         stops,
      stopsCount:    (json['stops_count'] as num?)?.toInt() ?? stops.length,
      type:          _typeFromLineName(lineName),
    );
  }

  // حدد الـ type من اسم الـ line
  static TransportType _typeFromLineName(String? name) {
    if (name == null) return TransportType.bus;
    final lower = name.toLowerCase();
    if (lower.contains('metro'))    return TransportType.metro;
    if (lower.contains('monorail')) return TransportType.monorail;
    return TransportType.bus;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// parseSegments — الـ entry point الوحيد
// استدعيه بدل buildSegmentModel في الـ RoutesCubit
//
// مثال:
//   final segments = parseSegments(response as List);
// ─────────────────────────────────────────────────────────────────────────────

List<SegmentModel> parseSegments(List<dynamic> json) {
  return json
      .map((s) => SegmentModel.fromJson(s as Map<String, dynamic>))
      .toList();
}