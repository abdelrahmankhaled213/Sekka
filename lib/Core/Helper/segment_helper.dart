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
  
  bool get hasMoreStops => stops.length > 6;

  List<StepModel> get previewStops =>
      stops.length <= 6 ? stops : stops.take(6).toList();

  SegmentModel({
     this.direction='',
    required this.lineName,
    required this.type,
    required this.stops,
    this.transferAtStop
  });
}
List<SegmentModel> buildSegmentModel(List<StepModel> steps) {
  List<SegmentModel> segments = [];
  if (steps.isEmpty) return segments;

  List<StepModel> currentStops = [];
  TransportType? currentType;
  String? currentLineName;
  String? currentDirection;

  for (var i = 0; i < steps.length; i++) {
    var step = steps[i];

    if (currentType == null) {
      currentType = step.type;
      currentLineName = step.routeName;
      currentDirection = step.direction;
      currentStops.add(step);
      continue;
    }

    
    bool isTypeChanged = step.type != currentType;
    bool isLineChanged = step.routeName != currentLineName;
    bool isDirectionChanged = step.direction.isNotEmpty && step.direction != currentDirection;

    if (!isTypeChanged && !isLineChanged && !isDirectionChanged) {
      currentStops.add(step);
    } else {
      
      String? transferStationName;
      if (currentStops.isNotEmpty) {
        currentStops.last.isTransferPoint = true;
        transferStationName = currentStops.last.stopName; // حفظ اسم محطة التبديل
      }

      segments.add(
        SegmentModel(
          direction: currentDirection ?? '',
          type: currentType!,
          lineName: currentLineName,
          stops: List.from(currentStops),
          transferAtStop: transferStationName, 
        ),
      );

      currentStops = [step];
      currentType = step.type;
      currentLineName = step.routeName;
      currentDirection = step.direction;
    }
  }

 
  if (currentStops.isNotEmpty) {
    segments.add(
      SegmentModel(
        direction: currentDirection ?? '',
        type: currentType!,
        lineName: currentLineName,
        stops: currentStops,
      ),
    );
  }

  return segments;
}

  
 