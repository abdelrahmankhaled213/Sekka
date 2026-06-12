// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:sekka/Features/NearestStation/Data/Model/capacity_prediction_model.dart';

// class CapacityPredictionService {
//   static const _baseUrl =
//       'https://sekkacapacityprediction-production.up.railway.app';

//   Future<CapacityPredictionModel?> getPredictionForStation(int stationId) async {
//     try {
//       final uri = Uri.parse('$_baseUrl/predict/$stationId');
//       final response = await http.get(uri);
//       if (response.statusCode != 200) return null;
//       final data = json.decode(response.body) as Map<String, dynamic>;
//       debugPrint('Prediction data for station $stationId: $data');
//       return CapacityPredictionModel.fromJson(data);
//     } catch (_) {
//       return null;
//     }
//   }
// }

import 'dart:math';
import 'package:sekka/Core/Helper/transport_type_helper.dart';

/// Fake capacity prediction — بترجع random crowding level
/// لما تجيب الـ real model حطه هنا بدل الـ Random
class CapacityPredictionResult {
  final CrowdingLevel crowdingLevel;
  const CapacityPredictionResult({required this.crowdingLevel});
}

class CapacityPredictionService {
  
  final _random = Random();

  Future<CapacityPredictionResult?> getPredictionForStation(int stationId) async {
 
    await Future.delayed(const Duration(milliseconds: 100));

     final roll = _random.nextDouble();
    final CrowdingLevel level;
    if (roll < 0.5) {
      level = CrowdingLevel.low;
    } else if (roll < 0.8) {
      level = CrowdingLevel.medium;
    } else {
      level = CrowdingLevel.high;
    }

    return CapacityPredictionResult(crowdingLevel: level);
  }
}