import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'notifications_event.dart';


part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsLoaded>(_onLoaded);
    on<NotificationMarkedSeen>(_onMarkSeen);
    on<AllNotificationsMarkedSeen>(_onMarkAllSeen);
    on<NotificationDeleted>(_onDelete);
  }

  void _onLoaded(
      NotificationsLoaded event,
      Emitter<NotificationsState> emit,
      ) {
    emit(state.copyWith(status: NotificationsStatus.loading));

    // TODO: اینجا می‌تونی API call بذاری
    // فعلاً دیتای نمونه
    const mockItems = [
      NotificationItem(
        id: '1',
        title: 'سفارش جدید دریافت شد',
        body: 'سفارش شماره ۱۲۳۴ ثبت شد',
        seen: false,
        createdAt: null,
      ),
      NotificationItem(
        id: '2',
        title: 'مشتری با موفقیت بروزرسانی شد',
        seen: true,
        createdAt: null,
      ),
      NotificationItem(
        id: '3',
        title: 'موجودی در حال اتمام است',
        body: 'تنها ۵ عدد از محصول X باقی مانده',
        seen: false,
        createdAt: null,
      ),
    ];

    emit(state.copyWith(
      status: NotificationsStatus.success,
      items: mockItems,
    ));
  }

  void _onMarkSeen(
      NotificationMarkedSeen event,
      Emitter<NotificationsState> emit,
      ) {
    emit(state.copyWith(
      items: state.items
          .map((item) => item.id == event.id ? item.copyWith(seen: true) : item)
          .toList(),
    ));
  }

  void _onMarkAllSeen(
      AllNotificationsMarkedSeen event,
      Emitter<NotificationsState> emit,
      ) {
    emit(state.copyWith(
      items: state.items
          .map((item) => item.copyWith(seen: true))
          .toList(),
    ));
  }

  void _onDelete(
      NotificationDeleted event,
      Emitter<NotificationsState> emit,
      ) {
    emit(state.copyWith(
      items: state.items.where((item) => item.id != event.id).toList(),
    ));
  }
}