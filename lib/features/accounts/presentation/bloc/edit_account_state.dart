import '../../domain/entities/account_entity.dart';

class EditAccountState {
  const EditAccountState({
    required this.id,
    this.name = '',
    this.selectedType = AccountType.customer,
    this.phone = '',
    this.email = '',
    this.description = '',
    this.address = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final int id;
  final String name;
  final AccountType selectedType;
  final String phone;
  final String email;
  final String description;
  final String address;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  EditAccountState copyWith({
    int? id,
    String? name,
    AccountType? selectedType,
    String? phone,
    String? email,
    String? description,
    String? address,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return EditAccountState(
      id: id ?? this.id,
      name: name ?? this.name,
      selectedType: selectedType ?? this.selectedType,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      address: address ?? this.address,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory EditAccountState.fromAccount(AccountEntity account) {
    return EditAccountState(
      id: account.id,
      name: account.name,
      selectedType: account.type,
      phone: account.phone,
      email: account.email,
      description: account.description,
      address: account.address,
    );
  }
}
