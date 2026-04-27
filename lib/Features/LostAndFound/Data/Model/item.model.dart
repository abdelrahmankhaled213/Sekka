enum ItemType { lost, found }
enum Category { phone, wallet, bag, keys, other }

class ItemModel {

  final String? id;
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
  });

  
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      userImage: json['user_image'],
      title: json['title'],
      description: json['description'],
      type: json['type'] == 'lost' ? ItemType.lost : ItemType.found,
      category: Category.values.firstWhere((e) => e.name == json['category']),
      stationName: json['station_name'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.name,
      'station_name': stationName,
      'is_active': isActive,
    };
  }
}