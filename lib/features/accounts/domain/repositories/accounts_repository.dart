import '../entities/account_entity.dart';
import '../entities/item_statement_entity.dart';
import '../entities/metal_balance_entity.dart';
import '../entities/money_statement_entity.dart';

abstract class AccountsRepository {
  Future<List<AccountEntity>> getAccounts();

  Future<AccountEntity> getAccountById(int id);

  Future<AccountEntity> createAccount({
    required String name,
    required AccountType type,
    required String phone,
    required String email,
    required String description,
    required String address,
  });

  Future<AccountEntity> updateAccount({
    required int id,
    required String name,
    required AccountType type,
    required String phone,
    required String email,
    required String description,
    required String address,
  });

  Future<AccountEntity> deleteAccount(int id);

  Future<List<MoneyStatementEntity>> getMoneyStatements({
    required int accountId,
    required String currency,
  });

  Future<List<MetalBalanceEntity>> getAccountMetals(int accountId);

  Future<List<ItemStatementEntity>> getItemStatements({
    required int accountId,
    required int itemId,
  });
}
