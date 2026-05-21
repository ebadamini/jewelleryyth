import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../shared/components/cards/app_section_card.dart';

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.translate('performance'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF98A2B3)),
            ],
          ),
          const SizedBox(height: 24),
          const _PerformanceItem(
            icon: Icons.inventory_2_outlined,
            title: 'Product Sales',
            subtitle: 'Sales target achieved!',
            progress: 0.82,
            progressColor: Color(0xFF22C55E),
            trailing: '\$367K',
          ),
          const SizedBox(height: 22),
          const _PerformanceItem(
            icon: Icons.groups_outlined,
            title: 'Team KPI',
            subtitle: 'KPI target achieved!',
            progress: 0.64,
            progressColor: Color(0xFFD946EF),
            trailing: '64%',
          ),
          const SizedBox(height: 22),
          const _PerformanceItem(
            icon: Icons.thumb_up_alt_outlined,
            title: 'Customer Satisfaction',
            subtitle: 'Customers are very satisfied!',
            progress: 0.89,
            progressColor: Color(0xFF38BDF8),
            trailing: '89%',
          ),
        ],
      ),
    );
  }
}

class _PerformanceItem extends StatelessWidget {
  const _PerformanceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressColor,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final Color progressColor;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF111111)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              trailing,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: progress,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
        ),
      ],
    );
  }
}
