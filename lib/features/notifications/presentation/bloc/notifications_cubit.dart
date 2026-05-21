import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit()
      : super(
    const NotificationsState(
      items: [
        NotificationItem(
          id: '1',
          title: 'New order received',
          seen: false,
        ),
        NotificationItem(
          id: '2',
          title: 'Customer updated successfully',
          seen: true,
        ),
        NotificationItem(
          id: '3',
          title: 'Inventory is getting low',
          seen: false,
        ),
      ],
    ),
  );

  void markSeen(String id) {
    emit(
      state.copyWith(
        items: state.items
            .map((item) => item.id == id ? item.copyWith(seen: true) : item)
            .toList(),
      ),
    );
  }
}
