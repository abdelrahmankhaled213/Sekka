// ─────────────────────────────────────────────────────────────────────────────
// زود الـ getters دي في SegmentModel بتاعك
// ─────────────────────────────────────────────────────────────────────────────

import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';

extension SegmentCostExtension on SegmentModel {
  // ── متوسط وقت per stop بالدقيقة حسب نوع الـ transport ───────────────────
  double get _minutesPerStop {
    switch (type) {
      case TransportType.metro:
        return 2.5;
      case TransportType.monorail:
        return 3.0;
      case TransportType.bus:
        return 4.0;
      default:
        return 4.0;
    }
  }

  // ── تكلفة الـ segment بالجنيه ─────────────────────────────────────────────
  double get costEGP {
    switch (type) {
      case TransportType.metro:
        return stopsCount <= 9 ? 8 : 12;
      case TransportType.monorail:
        return 10.0;
      case TransportType.bus:
        return 3.0;
      default:
        return 3.0;
    }
  }

  // ── وقت الـ segment بالدقيقة ──────────────────────────────────────────────
  int get estimatedMinutes => (stopsCount * _minutesPerStop).round().clamp(1, 999);
}

// ── helpers على List<SegmentModel> ───────────────────────────────────────────

extension SegmentListExtension on List<SegmentModel> {
  double get totalCost =>
      fold(0.0, (sum, s) => sum + s.costEGP);

  int get totalMinutes =>
      fold(0, (sum, s) => sum + s.estimatedMinutes);

  int get totalStops =>
      fold(0, (sum, s) => sum + s.stopsCount);

  int get transferCount =>
      where((s) => s.isTransfer).length;
}