import 'package:flutter/material.dart';

class SidebarMenuModel {
  const SidebarMenuModel({
    required this.key,
    required this.labelKey,
    required this.icon,
    required this.children,
  });

  final String key;
  final String labelKey;
  final IconData icon;
  final List<SidebarSubmenuModel> children;
}

class SidebarSubmenuModel {
  const SidebarSubmenuModel({
    required this.key,
    required this.labelKey,
    required this.isNavigable,
  });

  final String key;
  final String labelKey;
  final bool isNavigable;
}
