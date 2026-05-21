import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

class CreateAccountUseCase {
  const CreateAccountUseCase(this._repository);

  final AccountsRepository _repository;

  Future<AccountEntity> call({
    required String name,
    required AccountType type,
    required String phone,
    required String email,
    required String description,
    required String address,
  }) {
    return _repository.createAccount(
      name: name,
      type: type,
      phone: phone,
      email: email,
      description: description,
      address: address,
    );
  }
}
