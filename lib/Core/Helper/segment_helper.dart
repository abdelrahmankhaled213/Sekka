import 'package:sekka/Features/Auth/Logic/transport_model.dart';

class RouteSegment {
  final TransportType type; 
  final List<StepModel> stops;

  RouteSegment({
    required this.type,
    required this.stops,
  });
}
class StepModel {

  final TransportType type; 
  final String routeName;
  final String stopName;

  StepModel({
    required this.type,
    required this.routeName,
    required this.stopName,
  });
  
}
class SegmentModel {
  
  final TransportType type;
  final List<StepModel> stops;
  final String? lineName;

  bool get hasMoreStops => stops.length > 6;

  List<StepModel> get previewStops =>
      stops.length <= 6 ? stops : stops.take(6).toList();

  SegmentModel({
    required this.lineName,
    required this.type,
    required this.stops,
  });
}


List<SegmentModel> buildSegmentModel(List<StepModel> steps) {
 
  List<SegmentModel> segments = [];

  if (steps.isEmpty) return segments;

  List<StepModel> current = [];
  TransportType? currentType;
  String? currentLineName;

  for (var step in steps) {

    if (currentType == null) {
      currentType = step.type;
      currentLineName = step.routeName;
      current.add(step);
      continue;
    }

    if (step.type == currentType) {
      current.add(step);
    } else {
      segments.add(
        SegmentModel(
          type: currentType,
          lineName: currentLineName, 
          stops: List.from(current),
        ),
      );

      current = [step];
      currentType = step.type;
      currentLineName = step.routeName; 
    }
  }

  
  segments.add(
    SegmentModel(
      type: currentType!,
      lineName: currentLineName,
      stops: current,
    ),
  );

  return segments;
}