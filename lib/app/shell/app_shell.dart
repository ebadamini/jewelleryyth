import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/app/router/app_router.dart';
import 'package:jewelleryyth/features/accounts/presentation/pages/accounts_page.dart';
import 'package:jewelleryyth/features/auth/presentation/bloc/auth_bloc.dart';
import '../../core/utils/responsive.dart';
import '../../features/dashboard/presentation/pages/dashboard_home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'shell_cubit.dart';
import 'widgets/shell_sidebar.dart';
import 'widgets/shell_topbar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != AuthStatus.loggedOut &&
          current.status == AuthStatus.loggedOut,
      listener: (context, state) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRouter.authGateRoute, (router) => false);
      },
      child: const _ShellView(),
    );
  }
}

class _ShellView extends StatelessWidget {
  const _ShellView();

  static const double expandedSidebarWidth = 230;
  static const double collapsedSidebarWidth = 72  ;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ShellCubit>().state;
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'fa'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        drawer: isMobile
            ? const Drawer(child: SafeArea(child: ShellSidebar()))
            : null,
        body: SafeArea(
          child: Row(
            children: [
              if (!isMobile)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  width: state.isSidebarCollapsed
                      ? collapsedSidebarWidth
                      : expandedSidebarWidth,
                  child: const RepaintBoundary(child: ShellSidebar()),
                ),
              const Expanded(
                child: Column(
                  children: [
                    ShellTopbar(),
                    Expanded(child: _ShellContent()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// فقط صفحات اصلی که توی IndexedStack هستن
enum ShellPage {
  dashboard_home,
  dashboard_analytics,
  accounts_list,
  orders_list,
  customers_list,
  inventory_gold,
  inventory_waste,
  reports_financial,
  reports_customers,
  settings_general,
  settings_language,
  profile_page,

}

extension ShellPageIndex on ShellPage {
  int get index => ShellPage.values.indexOf(this);
}

extension ShellPageKey on ShellPage {
  String get key => name;
}

class _ShellContent extends StatelessWidget {
  const _ShellContent();

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final selectedKey = context.select(
      (ShellCubit cubit) => cubit.state.selectedMenuKey,
    );

    final shellPage = ShellPage.values
        .where((p) => p.key == selectedKey)
        .firstOrNull;

    if (shellPage == null) {
      debugPrint('Warning: Unknown menu key: $selectedKey');
      return const _PlaceholderPage(title: 'Page Not Found');
    }

    return Container(
      color: const Color(0xFFF6F7FB),
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      child: IndexedStack(
        index: shellPage.index,
        children: [
          const DashboardHomePage(), // dashboardHome (0)
          const _PlaceholderPage(title: 'Analytics'), // dashboardAnalytics (1)
          const AccountsPage(),
          const _PlaceholderPage(title: 'Orders'),
          const _PlaceholderPage(title: 'Customers'),
          const _PlaceholderPage(title: 'Gold Stock'),
          const _PlaceholderPage(title: 'Waste'),
          const _PlaceholderPage(title: 'Financial'),
          const _PlaceholderPage(title: 'Customers'),
          const _PlaceholderPage(title: 'Settings'),
          const _PlaceholderPage(title: 'Language'),
          const ProfilePage(),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
