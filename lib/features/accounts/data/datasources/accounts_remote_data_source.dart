import 'package:dio/dio.dart';
import '../../../../core/network/endpoints.dart';
import '../dtos/account_response_dto.dart';
import '../dtos/create_account_request_dto.dart';
import '../dtos/item_statement_dto.dart';
import '../dtos/metal_balance_dto.dart';
import '../dtos/money_statement_dto.dart';
import '../dtos/update_account_request_dto.dart';

abstract class AccountsRemoteDataSource {
  Future<List<AccountResponseDto>> getAccounts();
  Future<AccountResponseDto> getAccountById(int id);
  Future<AccountResponseDto> createAccount(CreateAccountRequestDto request);
  Future<AccountResponseDto> updateAccount(UpdateAccountRequestDto request);
  Future<AccountResponseDto> deleteAccount(int id);
  Future<List<MoneyStatementDto>> getMoneyStatements({
    required int accountId,
    required String currency,
  });
  Future<List<MetalBalanceDto>> getAccountMetals(int accountId);
  Future<List<ItemStatementDto>> getItemStatements({
    required int accountId,
    required int itemId,
  });
}

class AccountsRemoteDataSourceImpl implements AccountsRemoteDataSource {
  const AccountsRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<AccountResponseDto>> getAccounts() async {
    final response = await _dio.get(Endpoints.accounts);

    return (response.data as List)
        .map((e) => AccountResponseDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AccountResponseDto> getAccountById(int id) async {
    final response = await _dio.get(Endpoints.accountById(id));
    return AccountResponseDto.fromJson(response.data);
  }

  @override
  Future<AccountResponseDto> createAccount(CreateAccountRequestDto request) async {
    final response = await _dio.post(
      Endpoints.accounts,
      data: request.toJson(),
    );
    return AccountResponseDto.fromJson(response.data);
  }

  @override
  Future<AccountResponseDto> updateAccount(UpdateAccountRequestDto request) async {
    final response = await _dio.put(
      Endpoints.accounts,
      data: request.toJson(),
    );
    return AccountResponseDto.fromJson(response.data);
  }

  @override
  Future<AccountResponseDto> deleteAccount(int id) async {
    final response = await _dio.delete(Endpoints.accountById(id));
    return AccountResponseDto.fromJson(response.data);
  }

  @override
  Future<List<MoneyStatementDto>> getMoneyStatements({
    required int accountId,
    required String currency,
  }) async {
    final response = await _dio.get(
      Endpoints.accountsMoneyStatements,
      queryParameters: {
        'accountId': accountId,
        'currency': currency,
      },
    );

    return (response.data as List)
        .map((e) => MoneyStatementDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MetalBalanceDto>> getAccountMetals(int accountId) async {
    final response = await _dio.get(Endpoints.accountMetals(accountId));

    return (response.data as List)
        .map((e) => MetalBalanceDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ItemStatementDto>> getItemStatements({
    required int accountId,
    required int itemId,
  }) async {
    final response = await _dio.get(
      Endpoints.accountsItemStatements,
      queryParameters: {
        'accountId': accountId,
        'itemId': itemId,
      },
    );

    return (response.data as List)
        .map((e) => ItemStatementDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}