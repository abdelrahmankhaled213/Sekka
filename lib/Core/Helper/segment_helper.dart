import 'package:sekka/Features/Auth/Logic/transport_model.dart';


class StepModel {

  final TransportType type; 
  final String routeName;
  final String stopName;
  final String direction;
  bool isTransferPoint;
  
  StepModel({
    required this.direction,
    required this.type,
    required this.routeName,
    required this.stopName,
    this.isTransferPoint = false
  });
  
}
class SegmentModel {
  
  final TransportType type;
  final List<StepModel> stops;
  final String? lineName;
  final String? direction;
  final String? transferAtStop;
  final String? nextLineName;
  bool get hasMoreStops => stops.length > 6;

  List<StepModel> get previewStops =>
      stops.length <= 6 ? stops : stops.take(6).toList();

  SegmentModel({
     this.direction='',
    required this.lineName,
    required this.type,
    required this.stops,
    this.transferAtStop,
    this.nextLineName,
  });
}
List<SegmentModel> buildSegmentModel(List<StepModel> steps) {
  List<SegmentModel> segments = [];
  if (steps.isEmpty) return segments;

  List<StepModel> currentStops = [];
  
  for (var i = 0; i < steps.length; i++) {
    var step = steps[i];
    
    if (currentStops.isEmpty) {
      currentStops.add(step);
      continue;
    }

    var lastStep = currentStops.last;

    // بنشوف لو لسه في نفس الـ Segment
    bool isSameSegment = step.type == lastStep.type && 
                         step.routeName == lastStep.routeName &&
                         step.direction == lastStep.direction;

    if (isSameSegment) {
      currentStops.add(step);
    } else {
      // إحنا هنا لقينا تبديل!
      lastStep.isTransferPoint = true;

      segments.add(
        SegmentModel(
          direction: lastStep.direction,
          type: lastStep.type,
          lineName: lastStep.routeName,
          stops: List.from(currentStops),
          transferAtStop: lastStep.stopName,
          nextLineName: step.routeName, 
        ),
      );

      currentStops = [step];
    }
  }

  // إضافة آخر Segment
  if (currentStops.isNotEmpty) {
    var lastPart = currentStops.last;
    segments.add(
      SegmentModel(
        direction: lastPart.direction,
        type: lastPart.type,
        lineName: lastPart.routeName,
        stops: currentStops,
        // آخر Segment ملوش NextLine لأنه نهاية الرحلة
        nextLineName: null, 
      ),
    );
  }

  return segments;
}