import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

class GetAccountsUseCase {
  const GetAccountsUseCase(this._repository);

  final AccountsRepository _repository;

  Future<List<AccountEntity>> call() => _repository.getAccounts();
}
