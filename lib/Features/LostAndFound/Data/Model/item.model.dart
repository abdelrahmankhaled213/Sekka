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
  final DateTime createdAt;
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

  
  factory ItemModel.fromJson(Map<String, dynamic> json) {
  
   final userData = json['users'] as Map<String, dynamic>?;

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
        ? DateTime.now() 
        : DateTime.parse(json['created_at']).toLocal(),
    isActive: json['is_active'] ?? true,
  commentCount: json['comments'][0]['count'] ?? 0
  );
}
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'category': category.name,
      'station_name': stationName,
      'is_active': isActive,
    };
  }
}