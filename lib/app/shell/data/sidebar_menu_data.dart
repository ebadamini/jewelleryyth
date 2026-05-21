import 'package:flutter/material.dart';

import '../models/sidebar_menu_model.dart';

class SidebarMenuData {
  static const List<SidebarMenuModel> items = [
    SidebarMenuModel(
      key: 'dashboard',
      labelKey: 'dashboard',
      icon: Icons.grid_view_rounded,
      children: [
        SidebarSubmenuModel(
          key: 'dashboard_home',
          labelKey: 'dashboardHome',
          isNavigable: true,  // ← توی IndexedStack
        ),
        SidebarSubmenuModel(
          key: 'dashboard_analytics',
          labelKey: 'analytics',
          isNavigable: true,
        ),
      ],
    ),
    SidebarMenuModel(
      key: 'accounts',
      labelKey: 'accounts',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        SidebarSubmenuModel(
          key: 'accounts_list',
          labelKey: 'accountsList',
          isNavigable: true,
        ),
        SidebarSubmenuModel(
          key: 'accounts_create',
          labelKey: 'createAccount',
          isNavigable: false,  // ← با Navigator.push
        ),
      ],
    ),
    SidebarMenuModel(
      key: 'customers',
      labelKey: 'customers',
      icon: Icons.people_outline_rounded,
      children: [
        SidebarSubmenuModel(
          key: 'customers_list',
          labelKey: 'customerList',
          isNavigable: false,

        ),
        SidebarSubmenuModel(
          key: 'customers_add',
          labelKey: 'addCustomer',
          isNavigable: false,
        ),
      ],
    ),
    SidebarMenuModel(
      key: 'orders',
      labelKey: 'orders',
      icon: Icons.receipt_long_outlined,
      children: [
        SidebarSubmenuModel(
          key: 'orders_list',
          labelKey: 'ordersList',
          isNavigable: false,
        ),
        SidebarSubmenuModel(
          key: 'orders_create',
          labelKey: 'newOrder',
          isNavigable: false,
        ),
      ],
    ),
    SidebarMenuModel(
      key: 'inventory',
      labelKey: 'inventory',
      icon: Icons.inventory_2_outlined,
      children: [
        SidebarSubmenuModel(
          key: 'inventory_gold',
          labelKey: 'goldStock',
          isNavigable: false,
        ),
        SidebarSubmenuModel(
          key: 'inventory_waste',
          labelKey: 'wasteRecovery',
          isNavigable: false,
        ),
      ],
    ),
    SidebarMenuModel(
      key: 'reports',
      labelKey: 'reports',
      icon: Icons.bar_chart_rounded,
      children: [
        SidebarSubmenuModel(
          key: 'reports_financial',
          labelKey: 'financialReports',
          isNavigable: false,
        ),
        SidebarSubmenuModel(
          key: 'reports_customers',
          labelKey: 'customerReports',
          isNavigable: false,
        ),
      ],
    ),
    SidebarMenuModel(
      key: 'settings',
      labelKey: 'settings',
      icon: Icons.settings_outlined,
      children: [
        SidebarSubmenuModel(
          key: 'settings_general',
          labelKey: 'generalSettings',
          isNavigable: false,
        ),
        SidebarSubmenuModel(
          key: 'settings_language',
          labelKey: 'languageSettings',
          isNavigable: false,
        ),
      ],
    ),
  ];
}
