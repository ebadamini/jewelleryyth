import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shell_state.dart';

class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

  void toggleSidebar() {
    emit(state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed));
  }

  void setSidebarCollapsed(bool value) {
    emit(state.copyWith(isSidebarCollapsed: value));
  }

  void toggleMenu(String menuKey) {
    final current = List<String>.from(state.expandedMenuKeys);

    if (current.contains(menuKey)) {
      current.remove(menuKey);
    } else {
      current.add(menuKey);
    }

    emit(state.copyWith(expandedMenuKeys: current));
  }

  void openMenu(String menuKey) {
    final current = List<String>.from(state.expandedMenuKeys);

    if (!current.contains(menuKey)) {
      current.add(menuKey);
      emit(state.copyWith(expandedMenuKeys: current));
    }
  }

  void selectMenu({
    required String parentKey,
    required String menuKey,
  }) {
    final current = List<String>.from(state.expandedMenuKeys);

    if (!current.contains(parentKey)) {
      current.add(parentKey);
    }

    emit(
      state.copyWith(
        selectedMenuKey: menuKey,
        expandedMenuKeys: current,
      ),
    );
  }
}
