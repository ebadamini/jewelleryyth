import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/app/router/app_router.dart';
import 'package:jewelleryyth/features/accounts/presentation/pages/accounts_page.dart';
import 'package:jewelleryyth/features/accounts/presentation/pages/create_account_page.dart';
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
    return BlocProvider(
      create: (_) => ShellCubit(),
      child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state){
            if(state.status == AuthStatus.loggedOut){
              Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.authGateRoute, (router) => false,);
            }
          },
          child: const _ShellView(),
      ),
    );
  }
}

class _ShellView extends StatelessWidget {
  const _ShellView();

  static const double expandedSidebarWidth = 280;
  static const double collapsedSidebarWidth = 88;

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
            ? const Drawer(
          child: SafeArea(child: ShellSidebar()),
        )
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
                  child: const RepaintBoundary(
                    child: ShellSidebar(),
                  ),
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

class _ShellContent extends StatelessWidget {
  const _ShellContent();

  static const Map<String, int> indexMap = {
    'dashboard_home': 0,
    'dashboard_analytics': 1,
    'orders_list': 2,
    'orders_create': 3,
    'customers_list': 4,
    'customers_add': 5,
    'inventory_gold': 6,
    'inventory_waste': 7,
    'reports_financial': 8,
    'reports_customers': 9,
    'settings_general': 10,
    'settings_language': 11,
    'profile_page': 12,
    'accounts_list': 13,
    'accounts_create': 14
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final selectedKey = context.select((ShellCubit cubit) => cubit.state.selectedMenuKey);
    final index = indexMap[selectedKey] ?? 0;

    return Container(
      color: const Color(0xFFF6F7FB),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: IndexedStack(
        index: index,
        children: const [
          DashboardHomePage(),
          DashboardHomePage(),
          // OrdersPage(),
          Center(child: Text("Orders"),),
          // CreateOrderPage(),
          Center(child: Text("Create Order"),),
          // CustomersPage(),
          Center(child: Text("Customers"),),
          // CreateCustomerPage(),
          Center(child: Text("Create Customer"),),
          _PlaceholderPage(title: 'Gold Stock'),
          _PlaceholderPage(title: 'Waste & Recovery'),
          _PlaceholderPage(title: 'Financial Reports'),
          _PlaceholderPage(title: 'Customer Reports'),
          _PlaceholderPage(title: 'General Settings'),
          _PlaceholderPage(title: 'Language Settings'),
          ProfilePage(),
          AccountsPage(),
          CreateAccountPage(),
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
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
