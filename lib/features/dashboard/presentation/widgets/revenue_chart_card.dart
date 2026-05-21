import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../shared/components/cards/app_section_card.dart';

class RevenueChartCard extends StatelessWidget {
  const RevenueChartCard({super.key});

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
                l10n.translate('revenueExpenses'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF98A2B3)),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              _MiniStat(
                color: Color(0xFFD946EF),
                title: 'Revenue',
                value: '\$3,342',
                trend: '+3.4%',
              ),
              SizedBox(width: 16),
              _MiniStat(
                color: Color(0xFF38BDF8),
                title: 'Expenses',
                value: '\$3,029',
                trend: '+1.2%',
              ),
              Spacer(),
              _MonthSelector(),
            ],
          ),
          const SizedBox(height: 24),
          const Expanded(
            child: _FakeBarChart(),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.color,
    required this.title,
    required this.value,
    required this.trend,
  });

  final Color color;
  final String title;
  final String value;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                trend,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month_outlined, size: 18),
          SizedBox(width: 8),
          Text(
            'This Month',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded),
        ],
      ),
    );
  }
}

class _FakeBarChart extends StatelessWidget {
  const _FakeBarChart();

  @override
  Widget build(BuildContext context) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    const heights = [44.0, 36.0, 42.0, 58.0, 76.0, 68.0, 49.0, 61.0, 56.0, 82.0, 74.0, 63.0];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(months.length, (index) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 18,
                    height: heights[index],
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: index == 9
                          ? const LinearGradient(
                        colors: [Color(0xFFD946EF), Color(0xFF60A5FA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                          : const LinearGradient(
                        colors: [Color(0xFFF3E8FF), Color(0xFFFCE7F3)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                months[index],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
