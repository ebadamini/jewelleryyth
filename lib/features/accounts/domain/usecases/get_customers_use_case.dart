
import 'package:dartz/dartz.dart';
import 'package:jewelleryyth/core/errors/failures.dart';
import 'package:jewelleryyth/features/accounts/domain/entities/account_entity.dart';
import 'package:jewelleryyth/features/accounts/domain/repositories/accounts_repository.dart';

class GetCustomersUseCase{
  const GetCustomersUseCase(this._repository);
  final AccountsRepository _repository;


  Future<List<AccountEntity>> call() => _repository.getCustomers(type: AccountType.CUSTOMER);
}