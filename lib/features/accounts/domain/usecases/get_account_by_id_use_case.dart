import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

class GetAccountByIdUseCase {
  const GetAccountByIdUseCase(this._repository);

  final AccountsRepository _repository;

  Future<AccountEntity> call(int id) => _repository.getAccountById(id);
}
