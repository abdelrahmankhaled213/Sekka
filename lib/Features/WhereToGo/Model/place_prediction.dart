class PlacePrediction {
  final String placeId;
  final String mainText;
  final String secondaryText;
  final String fullText;

  const PlacePrediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.fullText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structured = json['structured_formatting'] as Map<String, dynamic>?;
    return PlacePrediction(
      placeId:       json['place_id'] as String,
      mainText:      structured?['main_text'] as String? ?? '',
      secondaryText: structured?['secondary_text'] as String? ?? '',
      fullText:      json['description'] as String? ?? '',
    );
  }
}