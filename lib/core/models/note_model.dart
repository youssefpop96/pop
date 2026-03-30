class NoteModel {
  final String id;
  final String userId;
  final String folderId;
  final String title;
  final dynamic content; 
  final List<String> tags;
  final List<String> images;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.folderId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.images = const [],
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'].toString(),
      userId: json['user_id'],
      folderId: json['folder_id'].toString(),
      title: json['title'],
      content: json['content'], 
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'folder_id': folderId,
      'title': title,
      'content': content, 
      'tags': tags,
      'images': images,
    };
  }

  NoteModel copyWith({
    String? id,
    String? userId,
    String? folderId,
    String? title,
    dynamic content,
    List<String>? tags,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
