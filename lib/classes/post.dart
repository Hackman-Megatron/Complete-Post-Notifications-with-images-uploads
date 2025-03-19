import 'comment.dart';

class Post {
  final String id;
  final String description;
  final String? imagePath;
  final DateTime createdAt;
  int likes;
  List<Comment> comments;
  int shares;

  Post({
    required this.id,
    required this.description,
    this.imagePath,
    required this.createdAt,
    this.likes = 0,
    List<Comment>? comments,
    this.shares = 0,
  }) : comments = comments ?? [];
}
