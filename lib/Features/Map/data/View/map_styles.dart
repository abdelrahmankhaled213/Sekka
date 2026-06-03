
class MapStyles {
  static const String light = '''[
    {"featureType":"all","elementType":"geometry.fill","stylers":[{"color":"#f5f4fb"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#bfdbfe"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
    {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#e5e7eb"}]},
    {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#e0f2fe"}]},
    {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#ede9fe"}]},
    {"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dbeafe"}]},
    {"featureType":"all","elementType":"labels.text.fill","stylers":[{"color":"#374151"}]},
    {"featureType":"all","elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"},{"weight":2}]}
  ]''';

  static const String dark = '''[
    {"featureType":"all","elementType":"geometry","stylers":[{"color":"#1e1b4b"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#1e3a5f"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#312e81"}]},
    {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#4338ca"}]},
    {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#2d2b69"}]},
    {"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#1e3a8a"}]},
    {"featureType":"all","elementType":"labels.text.fill","stylers":[{"color":"#c7d2fe"}]},
    {"featureType":"all","elementType":"labels.text.stroke","stylers":[{"color":"#1e1b4b"},{"weight":2}]}
  ]''';
}
