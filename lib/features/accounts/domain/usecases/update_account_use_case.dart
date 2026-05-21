import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

class UpdateAccountUseCase {
  const UpdateAccountUseCase(this._repository);

  final AccountsRepository _repository;

  Future<AccountEntity> call({
    required int id,
    required String name,
    required AccountType type,
    required String phone,
    required String email,
    required String description,
    required String address,
  }) {
    return _repository.updateAccount(
      id: id,
      name: name,
      type: type,
      phone: phone,
      email: email,
      description: description,
      address: address,
    );
  }
}
