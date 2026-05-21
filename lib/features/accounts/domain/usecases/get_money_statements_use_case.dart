import '../entities/money_statement_entity.dart';
import '../repositories/accounts_repository.dart';

class GetMoneyStatementsUseCase {
  const GetMoneyStatementsUseCase(this._repository);

  final AccountsRepository _repository;

  Future<List<MoneyStatementEntity>> call({
    required int accountId,
    required String currency,
  }) {
    return _repository.getMoneyStatements(
      accountId: accountId,
      currency: currency,
    );
  }
}
