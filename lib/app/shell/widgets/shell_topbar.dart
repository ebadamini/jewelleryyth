import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewelleryyth/app/shell/widgets/topbar_notifications_button.dart';

import '../../../core/utils/responsive.dart';
import '../../localization/app_localizations.dart';
import '../../localization/locale_cubit.dart';
import '../../theme/theme_cubit.dart';
import '../shell_cubit.dart';

class ShellTopbar extends StatelessWidget {
  const ShellTopbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';

    return Container(
      height: isMobile ? 64 : 72,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAECEF))),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
                icon: const Icon(FontAwesomeIcons.bars, size: 16),
              );
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Vazirmatn',
              ),
              decoration: InputDecoration(
                hintText: l10n.translate('searchSomething'),
                hintStyle: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Vazirmatn',
                ),
                prefixIcon: const Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Wrap(
            spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const TopbarNotificationsButton(),
                const SizedBox(width:4),
                IconButton(
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  icon: const Icon(FontAwesomeIcons.moon, size: 16),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    context.read<LocaleCubit>().switchLocale(value);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'en',
                      child: Text(
                        l10n.translate('english'),
                        style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'fa',
                      child: Text(
                        l10n.translate('persian'),
                        style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
                      ),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(FontAwesomeIcons.globe, size: 16),
                  ),
                ),
              ],
          ),  // ← اضافه شد
        ],
      ),
    );
  }
}