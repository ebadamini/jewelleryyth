import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);

  final AccountsRepository _repository;

  Future<AccountEntity> call(int id) => _repository.deleteAccount(id);
}
