import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Providers/notification_provider.dart';
import '../Providers/post_provider.dart';
import '../classes/app_notification.dart';
import '../classes/comment.dart';
import '../classes/post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final timeAgo = _getTimeAgo(post.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Utilisateur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (post.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(post.description),
            ),
          if (post.imagePath != null)
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              width: double.infinity,
              child: Image.file(
                File(post.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text('Erreur de chargement de l\'image'),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${post.likes} J\'aime'),
                Text('${post.comments.length} Commentaires'),
                Text('${post.shares} Partages'),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  Provider.of<PostProvider>(context, listen: false).likePost(post.id);
                  Provider.of<NotificationProvider>(context, listen: false).addNotification(
                    AppNotification(
                      id: const Uuid().v4(),
                      message: 'Quelqu\'un a aimé votre publication',
                      createdAt: DateTime.now(),
                    ),
                  );
                },
                icon: const Icon(Icons.thumb_up_outlined),
                label: const Text('J\'aime'),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
                icon: const Icon(Icons.comment_outlined),
                label: const Text('Commenter'),
              ),
              TextButton.icon(
                onPressed: () {
                  Provider.of<PostProvider>(context, listen: false).sharePost(post.id);
                  Provider.of<NotificationProvider>(context, listen: false).addNotification(
                    AppNotification(
                      id: const Uuid().v4(),
                      message: 'Quelqu\'un a partagé votre publication',
                      createdAt: DateTime.now(),
                    ),
                  );
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Partager'),
              ),
            ],
          ),
          if (_showComments) ...[
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: post.comments.length,
              itemBuilder: (context, index) {
                final comment = post.comments[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person, size: 18),
                  ),
                  title: Text(
                    comment.text,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    _getTimeAgo(comment.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Écrivez un commentaire...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.trim().isNotEmpty) {
                        final comment = Comment(
                          id: const Uuid().v4(),
                          text: _commentController.text.trim(),
                          createdAt: DateTime.now(),
                        );
                        Provider.of<PostProvider>(context, listen: false).addComment(post.id, comment);
                        Provider.of<NotificationProvider>(context, listen: false).addNotification(
                          AppNotification(
                            id: const Uuid().v4(),
                            message: 'Quelqu\'un a commenté votre publication',
                            createdAt: DateTime.now(),
                          ),
                        );
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'il y a ${difference.inDays} jours';
    } else if (difference.inHours > 0) {
      return 'il y a ${difference.inHours} heures';
    } else if (difference.inMinutes > 0) {
      return 'il y a ${difference.inMinutes} minutes';
    } else {
      return 'à l\'instant';
    }
  }
}
