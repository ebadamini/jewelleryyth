part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    this.body,
    required this.seen,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? body;
  final bool seen;
  final DateTime? createdAt;

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    bool? seen,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      seen: seen ?? this.seen,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, body, seen, createdAt];
}

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final NotificationsStatus status;
  final List<NotificationItem> items;
  final String? errorMessage;

  int get unreadCount => items.where((e) => !e.seen).length;
  bool get hasUnread => unreadCount > 0;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}