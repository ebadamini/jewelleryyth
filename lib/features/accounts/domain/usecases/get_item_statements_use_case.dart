import '../entities/item_statement_entity.dart';
import '../repositories/accounts_repository.dart';

class GetItemStatementsUseCase {
  const GetItemStatementsUseCase(this._repository);

  final AccountsRepository _repository;

  Future<List<ItemStatementEntity>> call({
    required int accountId,
    required int itemId,
  }) {
    return _repository.getItemStatements(
      accountId: accountId,
      itemId: itemId,
    );
  }
}
