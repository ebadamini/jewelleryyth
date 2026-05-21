part of 'notifications_cubit.dart';

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.seen,
  });

  final String id;
  final String title;
  final bool seen;

  NotificationItem copyWith({
    String? id,
    String? title,
    bool? seen,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      seen: seen ?? this.seen,
    );
  }

  @override
  List<Object?> get props => [id, title, seen];
}

class NotificationsState extends Equatable {
  const NotificationsState({
    this.items = const [],
  });

  final List<NotificationItem> items;

  NotificationsState copyWith({
    List<NotificationItem>? items,
  }) {
    return NotificationsState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
