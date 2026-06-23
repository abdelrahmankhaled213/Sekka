import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';
import 'package:uuid/uuid.dart';

enum SegmentPosition { start, transfer, end }

// ─────────────────────────────────────────────────────────────────────────────
// StepModel
// ─────────────────────────────────────────────────────────────────────────────

class StepModel {
  final String  stopName;
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
      stopName:  json['stop_name'] as String? ?? '',
      stopId:    json['stop_id']?.toString(),
      latitude:  lat,
      longitude: lng,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SegmentModel
// ─────────────────────────────────────────────────────────────────────────────

class SegmentModel {
  final int             segmentId;
  final String?         lineName;
  final String?         direction;
  final SegmentPosition position;
  final String          boardingStop;
  final String          alightingStop;
  final String?         nextLineName;
  final List<StepModel> stops;
  final int             stopsCount;
  final TransportType   type;

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

  // ── Getters ───────────────────────────────────────────────────────────────

  bool get isStart    => position == SegmentPosition.start;
  bool get isTransfer => position == SegmentPosition.transfer;
  bool get isEnd      => position == SegmentPosition.end;

  String? get transferAtStop => isEnd ? null : alightingStop;

  bool get hasMoreStops => stops.length > 6;

  List<StepModel> get previewStops =>
      stops.length <= 6 ? stops : stops.take(6).toList();

  // ── Duration ──────────────────────────────────────────────────────────────

  int get durationMinutes {
    const minutesPerStop = {
      TransportType.metro:    2,
      TransportType.monorail: 3,
      TransportType.bus:      5,
      TransportType.microbus: 4,
      TransportType.transfer: 3,
    };
    const waitingMinutes = {
      TransportType.metro:    3,
      TransportType.monorail: 5,
      TransportType.bus:      7,
      TransportType.microbus: 5,
      TransportType.transfer: 0,
    };
    return (minutesPerStop[type] ?? 3) * stopsCount +
        (waitingMinutes[type] ?? 0);
  }

  // ── Ticket price ──────────────────────────────────────────────────────────

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
        return 20;
      case TransportType.BRT:
        if(stopsCount <= 4) return 5;
        if(stopsCount <= 10) return  10;
        return 15;  
      case TransportType.microbus:
        return 0;
      case TransportType.transfer:
        return 0;
    }
  }

  // ── Factory ───────────────────────────────────────────────────────────────

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

  // ── Type detection ────────────────────────────────────────────────────────

  static TransportType _typeFromLineName(String? name) {
    if (name == null) return TransportType.bus;
    final lower = name.toLowerCase().trim();

    if (lower.startsWith('metro'))    return TransportType.metro;
    if (lower.startsWith('monorail')) return TransportType.monorail;
    if (lower.startsWith('micro'))    return TransportType.microbus;
    if (lower.startsWith('bus'))      return TransportType.bus;
    if (lower.startsWith('BRT'))      return TransportType.BRT;

    if (lower.contains('metro'))      return TransportType.metro;
    if (lower.contains('monorail'))   return TransportType.monorail;
    if (lower.contains('micro'))      return TransportType.microbus;
    if (lower.contains('BRT'))        return TransportType.BRT;

    return TransportType.bus;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top-level helpers
// ─────────────────────────────────────────────────────────────────────────────

List<SegmentModel> parseSegments(List<dynamic> json) {
  return json
      .map((s) => SegmentModel.fromJson(s as Map<String, dynamic>))
      .toList();
}

String buildRouteCode(List<SegmentModel> segments) {
  return segments
      .where((s) => s.type != TransportType.transfer)
      .map((s) => s.lineName ?? s.type.name)
      .join(' → ');
}

String dominantMode(List<SegmentModel> segments) {
  final counts = <TransportType, int>{};
  for (final s in segments) {
    if (s.type != TransportType.transfer) {
      counts[s.type] = (counts[s.type] ?? 0) + 1;
    }
  }
  if (counts.isEmpty) return 'bus';
  return counts.entries
      .reduce((a, b) => a.value >= b.value ? a : b)
      .key
      .name;
}

TripHistoryModel buildTripFromSegments(List<SegmentModel> segments) {
  final totalPrice   = segments.fold(0.0, (s, e) => s + e.ticketPrice);
  final totalMinutes = segments.fold(0,   (s, e) => s + e.durationMinutes);

  return TripHistoryModel(
    id:          const Uuid().v4(),
    userId:      FirebaseAuth.instance.currentUser!.uid,
    fromStation: segments.first.boardingStop,
    toStation:   segments.last.alightingStop,
    dateTime:    DateTime.now().toIso8601String(),
    routeCode:   buildRouteCode(segments),
    mode:        dominantMode(segments),
    durationMin: totalMinutes,
    fareEGP:     totalPrice,
  );
}