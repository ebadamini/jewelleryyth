part of 'app_searchable_dropdown_cubit.dart';

enum AppSearchableDropdownStatus {
  initial,
  loading,
  success,
  failure,
}

class AppSearchableDropdownState extends Equatable {
  const AppSearchableDropdownState({
    this.status = AppSearchableDropdownStatus.initial,
    this.items = const [],
  });

  final AppSearchableDropdownStatus status;
  final List<SearchableItem> items;

  AppSearchableDropdownState copyWith({
    AppSearchableDropdownStatus? status,
    List<SearchableItem>? items,
  }) {
    return AppSearchableDropdownState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [status, items];
}
