import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../features/notifications/presentation/bloc/notifications_cubit.dart';

class TopbarNotificationsButton extends StatelessWidget {
  const TopbarNotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationsCubit>().state;
    final unreadCount = state.items.where((e) => !e.seen).length;

    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      itemBuilder: (context) {
        return state.items.map((item) {
          return PopupMenuItem<String>(
            value: item.id,
            child: Container(
              color: item.seen ? null : Colors.amber.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                item.title,
                style: TextStyle(
                  fontWeight: item.seen ? FontWeight.w500 : FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList();
      },
      onSelected: (id) {
        context.read<NotificationsCubit>().markSeen(id);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(FontAwesomeIcons.bell, size: 18),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFB91C1C),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
