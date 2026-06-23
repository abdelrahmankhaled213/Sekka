import 'dart:math';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
class CapacityPredictionResult {

  final CrowdingLevel crowdingLevel;
  final int totalSeats;
  final int occupiedSeats;

  const CapacityPredictionResult({
    required this.crowdingLevel,
    required this.totalSeats,
    required this.occupiedSeats,
  });

  int get availableSeats => totalSeats - occupiedSeats;

 
  double get occupancyPercentage =>
      totalSeats == 0 ? 0 : (occupiedSeats / totalSeats) * 100;
}

class CapacityPredictionService {

 
Future<CapacityPredictionResult?> getPredictionForStation(int stationId) async {
  await Future.delayed(const Duration(milliseconds: 100));

  // seed بالـ stationId → نفس الـ station = نفس الرقم دايمًا
  final rng = Random(stationId);

  const totalSeats = 35;
  final occupiedSeats = 5 + rng.nextInt(totalSeats - 4);
  final ratio = occupiedSeats / totalSeats;

  final CrowdingLevel level;
  if (ratio < 0.5) {
    level = CrowdingLevel.low;
  } else if (ratio < 0.8) {
    level = CrowdingLevel.medium;
  } else {
    level = CrowdingLevel.high;
  }

  return CapacityPredictionResult(
    crowdingLevel: level,
    totalSeats:    totalSeats,
    occupiedSeats: occupiedSeats,
  );
}


}