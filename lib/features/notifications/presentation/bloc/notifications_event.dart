import 'package:equatable/equatable.dart';


sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// لود اولیه اعلان‌ها
class NotificationsLoaded extends NotificationsEvent {
  const NotificationsLoaded();
}

/// علامت‌گذاری یه اعلان به عنوان خوانده‌شده
class NotificationMarkedSeen extends NotificationsEvent {
  const NotificationMarkedSeen(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// علامت‌گذاری همه اعلان‌ها به عنوان خوانده‌شده
class AllNotificationsMarkedSeen extends NotificationsEvent {
  const AllNotificationsMarkedSeen();
}

/// حذف یه اعلان
class NotificationDeleted extends NotificationsEvent {
  const NotificationDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}