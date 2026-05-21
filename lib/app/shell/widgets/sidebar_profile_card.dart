import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_theme.dart';
import '../shell_cubit.dart';

class SidebarProfileCard extends StatelessWidget {
  const SidebarProfileCard({
    super.key,
    required this.showExpandedLayout,
  });

  final bool showExpandedLayout;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ShellCubit>().selectMenu(
          parentKey: 'settings',
          menuKey: 'profile_page',
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(showExpandedLayout ? 10 : 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: showExpandedLayout
              ? const _ExpandedProfile(key: ValueKey('expanded-profile'))
              : const _CollapsedProfile(key: ValueKey('collapsed-profile')),
        ),
      ),
    );
  }
}

class _CollapsedProfile extends StatelessWidget {
  const _CollapsedProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Tooltip(
        message: 'Admin User',
        child: CircleAvatar(
          radius: 18,           // ← از 22 به 18
          backgroundColor: AppTheme.primaryGold,
          child: Icon(
            Icons.person_outline,
            color: Color(0xFF111111),
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ExpandedProfile extends StatelessWidget {
  const _ExpandedProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppTheme.primaryGold,
          child: Icon(
            Icons.person_outline,
            color: Color(0xFF111111),
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin User',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 13,         // ← از default به 13
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Vazirmatn',
                  color: Color(0xFF111111),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'admin@example.com',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Vazirmatn',
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,               // ← از 14 به 12
          color: Color(0xFF6B7280),
        ),
      ],
    );
  }
}