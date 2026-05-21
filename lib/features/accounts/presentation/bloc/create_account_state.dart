import '../../domain/entities/account_entity.dart';

enum CreateAccountStatus {
  initial,
  loading,
  success,
  failure,
}

class CreateAccountState {
  const CreateAccountState({
    this.name = '',
    this.selectedType = AccountType.customer,
    this.phone = '',
    this.email = '',
    this.description = '',
    this.address = '',
    this.status = CreateAccountStatus.initial,
    this.errorMessage,
  });

  final String name;
  final AccountType selectedType;
  final String phone;
  final String email;
  final String description;
  final String address;
  final CreateAccountStatus status;
  final String? errorMessage;

  CreateAccountState copyWith({
    String? name,
    AccountType? selectedType,
    String? phone,
    String? email,
    String? description,
    String? address,
    CreateAccountStatus? status,
    String? errorMessage,
  }) {
    return CreateAccountState(
      name: name ?? this.name,
      selectedType: selectedType ?? this.selectedType,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      address: address ?? this.address,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
