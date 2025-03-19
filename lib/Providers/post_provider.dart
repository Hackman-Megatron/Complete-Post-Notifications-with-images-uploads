
import 'package:flutter/material.dart';
import '../classes/comment.dart';
import '../classes/post.dart';


class PostProvider extends ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> get posts => _posts;

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void likePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].likes++;
      notifyListeners();
    }
  }

  void addComment(String postId, Comment comment) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].comments.add(comment);
      notifyListeners();
    }
  }

  void sharePost(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].shares++;
      notifyListeners();
    }
  }
}
