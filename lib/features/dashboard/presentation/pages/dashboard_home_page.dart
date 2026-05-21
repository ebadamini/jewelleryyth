import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/dashboard_header_actions.dart';
import '../widgets/deals_table_section.dart';
import '../widgets/metric_card.dart';
import '../widgets/performance_card.dart';
import '../widgets/revenue_chart_card.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final metrics = [
      MetricCard(
        title: l10n.translate('totalRevenue'),
        value: '\$127,928',
        subtitle: l10n.translate('thanLastWeek'),
        trend: '+2.8%',
        isPositive: true,
      ),
      MetricCard(
        title: l10n.translate('totalProductSold'),
        value: '3,722',
        subtitle: l10n.translate('thanLastWeek'),
        trend: '+2.4%',
        isPositive: true,
      ),
      MetricCard(
        title: l10n.translate('totalSales'),
        value: '\$217,027',
        subtitle: l10n.translate('thanLastWeek'),
        trend: '-2.9%',
        isPositive: false,
      ),
      MetricCard(
        title: l10n.translate('totalCustomers'),
        value: '7,273',
        subtitle: l10n.translate('thanLastWeek'),
        trend: '+2.1%',
        isPositive: true,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('dashboard'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 18),
          !isMobile ?  const DashboardHeaderActions() : const SizedBox(),
          const SizedBox(height: 22),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 2.2 : 1.45,
            ),
            itemBuilder: (_, index) => metrics[index],
          ),
          const SizedBox(height: 20),
          if (isMobile)
            const Column(
              children: [
                SizedBox(height: 360, child: RevenueChartCard()),
                SizedBox(height: 16),
                PerformanceCard(),
              ],
            )
          else
            const SizedBox(
              height: 380,
              child: Row(
                children: [
                  Expanded(flex: 7, child: RevenueChartCard()),
                  SizedBox(width: 16),
                  Expanded(flex: 4, child: PerformanceCard()),
                ],
              ),
            ),
          const SizedBox(height: 20),
          const DealsTableSection(),
        ],
      ),
    );
  }
}
