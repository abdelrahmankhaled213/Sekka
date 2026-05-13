import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sekka/Features/NearestStation/Data/Model/capacity_prediction_model.dart';

class CapacityPredictionService {
  static const _baseUrl =
      'https://sekkacapacityprediction-production.up.railway.app';

  Future<CapacityPredictionModel?> getPredictionForStation(int stationId) async {
    try {
      final uri = Uri.parse('$_baseUrl/predict/$stationId');
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;
      final data = json.decode(response.body) as Map<String, dynamic>;
      return CapacityPredictionModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
