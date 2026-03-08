class FolderModel {
  final String id;
  final String userId;
  final String name;
  final int colorIndex;
  final String? iconName;
  final DateTime createdAt;

  FolderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.colorIndex,
    this.iconName,
    required this.createdAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'].toString(),
      userId: json['user_id'],
      name: json['name'],
      colorIndex: json['color_index'] ?? 0,
      iconName: json['icon_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'color_index': colorIndex,
      'icon_name': iconName,
    };
  }
}
