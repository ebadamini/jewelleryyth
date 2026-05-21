import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_theme.dart';
import '../../localization/app_localizations.dart';
import '../data/sidebar_menu_data.dart';
import '../shell_cubit.dart';
import 'sidebar_menu_tile.dart';
import 'sidebar_profile_card.dart';

class ShellSidebar extends StatelessWidget {
  const ShellSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ShellCubit>().state;
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final showExpandedLayout = !state.isSidebarCollapsed && width >= 190;

        return ClipRect(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                _SidebarHeader(
                  showExpandedLayout: showExpandedLayout,
                  title: l10n.translate('appTitle'),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: showExpandedLayout ? 16 : 10,
                      vertical: 16,
                    ),
                    itemCount: SidebarMenuData.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final menu = SidebarMenuData.items[index];
                      return SidebarMenuTile(menu: menu);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    showExpandedLayout ? 16 : 10,
                    0,
                    showExpandedLayout ? 16 : 10,
                    16,
                  ),
                  child: SidebarProfileCard(
                    showExpandedLayout: showExpandedLayout,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({
    required this.showExpandedLayout,
    required this.title,
  });

  final bool showExpandedLayout;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: EdgeInsets.symmetric(horizontal: showExpandedLayout ? 20 : 10),
      alignment: showExpandedLayout ? Alignment.centerLeft : Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEAECEF)),
        ),
      ),
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: showExpandedLayout
              ? Row(
            key: const ValueKey('expanded-header'),
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.diamond_outlined,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
            ],
          )
              : Container(
            key: const ValueKey('collapsed-header'),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryGold,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              color: Color(0xFF111111),
            ),
          ),
        ),
      ),
    );
  }
}
