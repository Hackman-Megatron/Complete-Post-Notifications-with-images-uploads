import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/notification_provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).markAllAsRead();
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          final notifications = notificationProvider.notifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Text('Aucune notification pour le moment'),
            );
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notification.isRead ? Colors.transparent : Colors.blue,
                  ),
                ),
                title: Text(notification.message),
                subtitle: Text(_getTimeAgo(notification.createdAt)),
                onTap: () {
                  Provider.of<NotificationProvider>(context, listen: false).markAsRead(notification.id);
                },
              );
            },
          );
        },
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