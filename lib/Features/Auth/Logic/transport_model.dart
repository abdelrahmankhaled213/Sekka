import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
part 'transport_model.g.dart';
class TransportModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final TransportType type;
  final bool isSelected;

  const TransportModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
    this.isSelected = false,
  });

  TransportModel copyWith({bool? isSelected}) {
    return TransportModel(
      title: title,
      subtitle: subtitle,
      icon: icon,
      type: type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

@HiveType(typeId: 1)
enum TransportType {
  @HiveField(0)
  metro,
  @HiveField(1)
  bus,
  @HiveField(2)
  monorail,
  @HiveField(3)
  microbus,

  transfer

}