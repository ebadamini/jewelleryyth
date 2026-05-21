import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../shared/components/buttons/app_icon_action_button.dart';

class DashboardHeaderActions extends StatelessWidget {
  const DashboardHeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppIconActionButton(
          label: l10n.translate('customizeWidget'),
          icon: Icons.widgets_outlined,
          onPressed: () {},
        ),
        const _LastUpdatedBadge(),
        AppIconActionButton(
          label: l10n.translate('imports'),
          icon: Icons.file_download_outlined,
          onPressed: () {},
        ),
        AppIconActionButton(
          label: l10n.translate('exports'),
          icon: Icons.file_upload_outlined,
          onPressed: () {},
          filled: true,
        ),
      ],
    );
  }
}

class _LastUpdatedBadge extends StatelessWidget {
  const _LastUpdatedBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.autorenew_rounded, size: 18, color: Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Text(
            l10n.translate('lastUpdated'),
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
