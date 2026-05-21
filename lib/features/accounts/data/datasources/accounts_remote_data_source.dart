import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../dtos/account_response_dto.dart';
import '../dtos/create_account_request_dto.dart';
import '../dtos/item_statement_dto.dart';
import '../dtos/metal_balance_dto.dart';
import '../dtos/money_statement_dto.dart';
import '../dtos/update_account_request_dto.dart';

class AccountsRemoteDataSource {
  const AccountsRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<AccountResponseDto>> getAccounts() async {
    final response = await _apiClient.getList(endpoint: Endpoints.accounts);

    debugPrint('=== API Base URL should be: ${Endpoints.accounts}');

    return response
        .map((e) => AccountResponseDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AccountResponseDto> getAccountById(int id) async {
    final response = await _apiClient.get(endpoint: Endpoints.accountById(id));
    return AccountResponseDto.fromJson(response);
  }

  Future<AccountResponseDto> createAccount(CreateAccountRequestDto request) async {
    final response = await _apiClient.post(
      endpoint: Endpoints.accounts,
      body: request.toJson(),
    );
    return AccountResponseDto.fromJson(response);
  }

  Future<AccountResponseDto> updateAccount(UpdateAccountRequestDto request) async {
    final response = await _apiClient.put(
      endpoint: Endpoints.accounts,
      body: request.toJson(),
    );
    return AccountResponseDto.fromJson(response);
  }

  Future<AccountResponseDto> deleteAccount(int id) async {
    final response = await _apiClient.delete(endpoint: Endpoints.accountById(id));
    return AccountResponseDto.fromJson(response);
  }

  Future<List<MoneyStatementDto>> getMoneyStatements({
    required int accountId,
    required String currency,
  }) async {
    final response = await _apiClient.getList(
      endpoint: Endpoints.accountsMoneyStatements,
      queryParameters: {
        'accountId': accountId,
        'currency': currency,
      },
    );

    return response
        .map((e) => MoneyStatementDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MetalBalanceDto>> getAccountMetals(int accountId) async {
    final response = await _apiClient.getList(
      endpoint: Endpoints.accountMetals(accountId),
    );

    return response
        .map((e) => MetalBalanceDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ItemStatementDto>> getItemStatements({
    required int accountId,
    required int itemId,
  }) async {
    final response = await _apiClient.getList(
      endpoint: Endpoints.accountsItemStatements,
      queryParameters: {
        'accountId': accountId,
        'itemId': itemId,
      },
    );

    return response
        .map((e) => ItemStatementDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
