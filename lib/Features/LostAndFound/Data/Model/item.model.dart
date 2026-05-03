import 'package:sekka/Core/Helper/date_time_helper.dart';

enum ItemType { lost, found }
enum Category { phone, wallet, bag, keys, other }

class ItemModel {

  final int? id;
  final String userId;
  final String? userName;
  final String ?userImage;
  final String title;
  final String description;
  final ItemType type;
  final Category category;
  final String stationName;
  final String createdAt;
  final bool isActive;
  final int? commentCount;
  ItemModel({
    this.id,
    required this.userId,
     this.userName,
     this.userImage,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.stationName,
    required this.createdAt,
    this.isActive = true,
    this.commentCount
  });

ItemModel copyWith({
 int? id,
  String? userId,
  String? userName,
  String? userImage,
  String? title,
  String? description,
  ItemType? type,
  Category? category,
  String? stationName,
  String? createdAt,
  bool? isActive,
  int? commentCount 
}){
  return ItemModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userImage: userImage ?? this.userImage,
    title: title ?? this.title,
    description: description ?? this.description,
    type: type ?? this.type,
    category: category ?? this.category,
    stationName: stationName ?? this.stationName,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
    commentCount: commentCount ?? this.commentCount
  );}

 factory ItemModel.fromJson(Map<String, dynamic> json) {
  final userData = json['users'] as Map<String, dynamic>?;

  int count = 0;
  if (json['comments'] != null && 
      json['comments'] is List && 
      (json['comments'] as List).isNotEmpty) {
    
    count = json['comments'][0]['count'] ?? 0;
  }

  return ItemModel(
    id: json['id'],
    userId: json['user_id'] ?? '', 
    userName: userData != null ? userData['name'] : 'Sekka Member',
    userImage: userData != null ? userData['image'] : null,
    title: json['title'] ?? 'No Title',
    description: json['description'] ?? '',
    type: json['type'] == 'lost' ? ItemType.lost : ItemType.found,
    category: Category.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => Category.other,
    ),
    stationName: json['station_name'] ?? '',
    createdAt: json['created_at'] == null 
        ? ''
        : DateTimeHelper.formatTimestamp(json['created_at']),
    isActive: json['is_active'] ?? true,
    commentCount: count, 
  );
}

 
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'created_at': createdAt,
      'category': category.name,
      'station_name': stationName,
      'is_active': isActive,
    };
  }
}