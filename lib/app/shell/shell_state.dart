part of 'shell_cubit.dart';

class ShellState extends Equatable {
  const ShellState({
    this.isSidebarCollapsed = false,
    this.expandedMenuKeys = const ['dashboard'],
    this.selectedMenuKey = 'dashboard_home',
  });

  final bool isSidebarCollapsed;
  final List<String> expandedMenuKeys;
  final String selectedMenuKey;

  ShellState copyWith({
    bool? isSidebarCollapsed,
    List<String>? expandedMenuKeys,
    String? selectedMenuKey,
  }) {
    return ShellState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      expandedMenuKeys: expandedMenuKeys ?? this.expandedMenuKeys,
      selectedMenuKey: selectedMenuKey ?? this.selectedMenuKey,
    );
  }

  @override
  List<Object?> get props => [
    isSidebarCollapsed,
    expandedMenuKeys,
    selectedMenuKey,
  ];
}
