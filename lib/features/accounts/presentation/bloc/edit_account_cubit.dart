import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/update_account_use_case.dart';
import 'edit_account_state.dart';

class EditAccountCubit extends Cubit<EditAccountState> {
  EditAccountCubit({
    required UpdateAccountUseCase updateAccountUseCase,
    required AccountEntity account,
  })  : _updateAccountUseCase = updateAccountUseCase,
        super(EditAccountState.fromAccount(account));

  final UpdateAccountUseCase _updateAccountUseCase;

  void onNameChanged(String value) {
    emit(state.copyWith(name: value));
  }

  void onTypeChanged(AccountType value) {
    emit(state.copyWith(selectedType: value));
  }

  void onPhoneChanged(String value) {
    emit(state.copyWith(phone: value));
  }

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void onAddressChanged(String value) {
    emit(state.copyWith(address: value));
  }

  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true, isSuccess: false, errorMessage: null));

    try {
      await _updateAccountUseCase(
        id: state.id,
        name: state.name,
        type: state.selectedType,
        phone: state.phone,
        email: state.email,
        description: state.description,
        address: state.address,
      );

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
