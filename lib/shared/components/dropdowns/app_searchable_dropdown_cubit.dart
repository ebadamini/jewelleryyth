import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_searchable_dropdown_state.dart';

class SearchableItem extends Equatable {
  const SearchableItem({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

class AppSearchableDropdownCubit extends Cubit<AppSearchableDropdownState> {
  AppSearchableDropdownCubit({
    required this.fetcher,
  }) : super(const AppSearchableDropdownState());

  final Future<List<SearchableItem>> Function(String query) fetcher;

  Future<void> search(String query) async {
    emit(state.copyWith(status: AppSearchableDropdownStatus.loading));

    try {
      final items = await fetcher(query);
      emit(
        state.copyWith(
          status: AppSearchableDropdownStatus.success,
          items: items,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AppSearchableDropdownStatus.failure,
          items: const [],
        ),
      );
    }
  }
}
