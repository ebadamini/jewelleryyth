import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewelleryyth/features/notifications/presentation/bloc/notifications_event.dart';

import '../../../features/notifications/presentation/bloc/notifications_bloc.dart';


class TopbarNotificationsButton extends StatelessWidget {
  const TopbarNotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    // سعی می‌کنیم NotificationsCubit رو پیدا کنیم
    try {
      final state = context.watch<NotificationsBloc>().state;
      final unreadCount = state.items.where((e) => !e.seen).length;

      return PopupMenuButton<String>(
        offset: const Offset(0, 40),
        constraints: const BoxConstraints(minWidth: 320, maxWidth: 360),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) {
          if (state.items.isEmpty) {
            return [
              const PopupMenuItem<String>(
                enabled: false,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'اعلانی وجود ندارد',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 13,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          }

          return state.items.map((item) {
            final isUnread = !item.seen;
            return PopupMenuItem<String>(
              value: item.id,
              height: 48,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: isUnread ? const Color(0xFFFFF7ED) : Colors.transparent,
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFFF3F4F6)),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUnread
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFFD1D5DB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 13,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                          color: const Color(0xFF111111),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
        },
        onSelected: (id) {
          context.read<NotificationsBloc>().add(NotificationMarkedSeen(id));
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(FontAwesomeIcons.bell, size: 16),
            ),
            if (unreadCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB91C1C),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    } catch (_) {
      // Fallback: NotificationsCubit پیدا نشد
      return IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifications service not available'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(FontAwesomeIcons.bell, size: 16),
      );
    }
  }
}