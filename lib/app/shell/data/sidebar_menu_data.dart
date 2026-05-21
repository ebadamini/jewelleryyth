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
          contentKey: '/dashboard',
        ),
        SidebarSubmenuModel(
          key: 'dashboard_analytics',
          labelKey: 'analytics',
          contentKey: '/dashboard',
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
              contentKey: 'accounts_list',
          ),
          SidebarSubmenuModel(
            key: 'accounts_create',
            labelKey: 'createAccount',
            contentKey: 'accounts_create',
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
          contentKey: '/dashboard',
        ),
        SidebarSubmenuModel(
          key: 'customers_add',
          labelKey: 'addCustomer',
          contentKey: '/dashboard',
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
          contentKey: '/dashboard',
        ),
        SidebarSubmenuModel(
          key: 'orders_create',
          labelKey: 'newOrder',
          contentKey: '/dashboard',
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
          contentKey: '/dashboard',
        ),
        SidebarSubmenuModel(
          key: 'inventory_waste',
          labelKey: 'wasteRecovery',
          contentKey: '/dashboard',
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
          contentKey: '/dashboard',
        ),
        SidebarSubmenuModel(
          key: 'reports_customers',
          labelKey: 'customerReports',
          contentKey: '/dashboard',
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
          contentKey: '/dashboard',
        ),
        SidebarSubmenuModel(
          key: 'settings_language',
          labelKey: 'languageSettings',
          contentKey: '/dashboard',
        ),
      ],
    ),
  ];
}
