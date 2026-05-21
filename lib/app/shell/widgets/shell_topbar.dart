import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/responsive.dart';
import '../../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../localization/app_localizations.dart';
import '../../localization/locale_cubit.dart';
import '../../theme/theme_cubit.dart';
import '../shell_cubit.dart';
import 'topbar_notifications_button.dart';

class ShellTopbar extends StatelessWidget {
  const ShellTopbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      height: isMobile ? 76 : 84,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAECEF))),
      ),
      child: Row(
        children: [
          Builder(
            builder: (innerContext) {
              return IconButton(
                onPressed: () {
                  if (isMobile) {
                    Scaffold.of(innerContext).openDrawer();
                  } else {
                    context.read<ShellCubit>().toggleSidebar();
                  }
                },
                icon: const Icon(FontAwesomeIcons.bars, size: 18),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.translate('searchSomething'),
                  prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // const TopbarNotificationsButton(),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: const Icon(FontAwesomeIcons.moon, size: 18),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<LocaleCubit>().switchLocale(value);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'en',
                child: Text(l10n.translate('english')),
              ),
              PopupMenuItem(
                value: 'fa',
                child: Text(l10n.translate('persian')),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(FontAwesomeIcons.globe, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
