import 'package:flutter/material.dart';

import '../classes/app_notification.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final notificationIndex = _notifications.indexWhere((n) => n.id == notificationId);
    if (notificationIndex != -1) {
      final updatedNotification = AppNotification(
        id: _notifications[notificationIndex].id,
        message: _notifications[notificationIndex].message,
        createdAt: _notifications[notificationIndex].createdAt,
        isRead: true,
      );
      _notifications[notificationIndex] = updatedNotification;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      final notification = _notifications[i];
      _notifications[i] = AppNotification(
        id: notification.id,
        message: notification.message,
        createdAt: notification.createdAt,
        isRead: true,
      );
    }
    notifyListeners();
  }
}
