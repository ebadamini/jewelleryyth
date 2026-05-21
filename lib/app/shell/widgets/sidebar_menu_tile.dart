import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_theme.dart';
import '../../localization/app_localizations.dart';
import '../models/sidebar_menu_model.dart';
import '../shell_cubit.dart';

class SidebarMenuTile extends StatelessWidget {
  const SidebarMenuTile({
    super.key,
    required this.menu,
  });

  final SidebarMenuModel menu;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ShellCubit>();
    final state = context.watch<ShellCubit>().state;

    final isExpanded = state.expandedMenuKeys.contains(menu.key);
    final isParentSelected = menu.children.any((e) => e.key == state.selectedMenuKey);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth;
        final showExpandedLayout = !state.isSidebarCollapsed && tileWidth >= 170;
        final title = l10n.translate(menu.labelKey);

        return ClipRect(
          child: Column(
            children: [
              Tooltip(
                message: !showExpandedLayout ? title : '',
                waitDuration: const Duration(milliseconds: 300),
                child: InkWell(
                  onTap: () {
                    if (!showExpandedLayout) {
                      cubit.setSidebarCollapsed(false);
                      cubit.openMenu(menu.key);
                    } else {
                      cubit.toggleMenu(menu.key);
                    }
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: showExpandedLayout ? 14 : 0,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isParentSelected
                          ? AppTheme.primaryGold.withValues(alpha: 0.14)
                          : const Color(0xFFF8FAFC),
                      border: Border.all(
                        color: isParentSelected
                            ? AppTheme.primaryGold.withValues(alpha: 0.35)
                            : Colors.transparent,
                      ),
                    ),
                    child: showExpandedLayout
                        ? Row(
                      children: [
                        Icon(
                          menu.icon,
                          size: 20,
                          color: isParentSelected
                              ? AppTheme.primaryGoldDark
                              : const Color(0xFF111111),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Vazirmatn',
                              fontWeight: FontWeight.w700,
                              color: isParentSelected
                                  ? AppTheme.primaryGoldDark
                                  : const Color(0xFF111111),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: Icon(
                        menu.icon,
                        size: 20,
                        color: isParentSelected
                            ? AppTheme.primaryGoldDark
                            : const Color(0xFF111111),
                      ),
                    ),
                  ),
                ),
              ),
              if (showExpandedLayout)
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                    child: Column(
                      children: menu.children.map((submenu) {
                        return _SidebarSubmenuTile(
                          parentKey: menu.key,
                          submenu: submenu,
                        );
                      }).toList(),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SidebarSubmenuTile extends StatelessWidget {
  const _SidebarSubmenuTile({
    required this.parentKey,
    required this.submenu,
  });

  final String parentKey;
  final SidebarSubmenuModel submenu;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ShellCubit>();
    final state = context.watch<ShellCubit>().state;

    final isSelected = state.selectedMenuKey == submenu.key;

    return InkWell(
      onTap: () {
        cubit.selectMenu(
          parentKey: parentKey,
          menuKey: submenu.key,
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGold.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.35))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryGoldDark
                    : const Color(0xFF98A2B3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.translate(submenu.labelKey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Vazirmatn',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryGoldDark
                      : const Color(0xFF111111),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
