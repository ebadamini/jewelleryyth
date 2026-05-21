import '../entities/metal_balance_entity.dart';
import '../repositories/accounts_repository.dart';

class GetAccountMetalsUseCase {
  const GetAccountMetalsUseCase(this._repository);

  final AccountsRepository _repository;

  Future<List<MetalBalanceEntity>> call(int accountId) {
    return _repository.getAccountMetals(accountId);
  }
}
