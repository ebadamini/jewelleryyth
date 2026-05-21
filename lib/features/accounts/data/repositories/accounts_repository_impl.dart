import '../../domain/entities/account_entity.dart';
import '../../domain/entities/item_statement_entity.dart';
import '../../domain/entities/metal_balance_entity.dart';
import '../../domain/entities/money_statement_entity.dart';
import '../../domain/repositories/accounts_repository.dart';
import '../datasources/accounts_remote_data_source.dart';
import '../dtos/create_account_request_dto.dart';
import '../dtos/update_account_request_dto.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  const AccountsRepositoryImpl({
    required AccountsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AccountsRemoteDataSource _remoteDataSource;

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final response = await _remoteDataSource.getAccounts();
    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<AccountEntity> getAccountById(int id) async {
    final response = await _remoteDataSource.getAccountById(id);
    return response.toEntity();
  }

  @override
  Future<AccountEntity> createAccount({
    required String name,
    required AccountType type,
    required String phone,
    required String email,
    required String description,
    required String address,
  }) async {
    final response = await _remoteDataSource.createAccount(
      CreateAccountRequestDto(
        name: name,
        type: type,
        phone: phone,
        email: email,
        description: description,
        address: address,
      ),
    );
    return response.toEntity();
  }

  @override
  Future<AccountEntity> updateAccount({
    required int id,
    required String name,
    required AccountType type,
    required String phone,
    required String email,
    required String description,
    required String address,
  }) async {
    final response = await _remoteDataSource.updateAccount(
      UpdateAccountRequestDto(
        id: id,
        name: name,
        type: type,
        phone: phone,
        email: email,
        description: description,
        address: address,
      ),
    );
    return response.toEntity();
  }

  @override
  Future<AccountEntity> deleteAccount(int id) async {
    final response = await _remoteDataSource.deleteAccount(id);
    return response.toEntity();
  }

  @override
  Future<List<MoneyStatementEntity>> getMoneyStatements({
    required int accountId,
    required String currency,
  }) async {
    final response = await _remoteDataSource.getMoneyStatements(
      accountId: accountId,
      currency: currency,
    );
    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<MetalBalanceEntity>> getAccountMetals(int accountId) async {
    final response = await _remoteDataSource.getAccountMetals(accountId);
    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<ItemStatementEntity>> getItemStatements({
    required int accountId,
    required int itemId,
  }) async {
    final response = await _remoteDataSource.getItemStatements(
      accountId: accountId,
      itemId: itemId,
    );
    return response.map((e) => e.toEntity()).toList();
  }
}
