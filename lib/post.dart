import 'dart:convert';

class Post {
  final String id;
  final String title;
  final String content;
  final String? author;
  final String? userId;
  final int likes;
  final int views;
  final int numOfComments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.author,
    this.userId,
    required this.likes,
    required this.views,
    required this.numOfComments,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      userId: json['userId'],
      likes: json['likes'],
      views: json['views'],
      numOfComments: json['numOfComments'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
