class AppNotification {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
}