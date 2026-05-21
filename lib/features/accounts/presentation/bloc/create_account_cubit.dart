import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/create_account_use_case.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit({
    required CreateAccountUseCase createAccountUseCase,
  })  : _createAccountUseCase = createAccountUseCase,
        super(const CreateAccountState());

  final CreateAccountUseCase _createAccountUseCase;

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
    emit(state.copyWith(status: CreateAccountStatus.loading, errorMessage: null));

    try {
      await _createAccountUseCase(
        name: state.name,
        type: state.selectedType,
        phone: state.phone,
        email: state.email,
        description: state.description,
        address: state.address,
      );

      emit(state.copyWith(status: CreateAccountStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: CreateAccountStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
