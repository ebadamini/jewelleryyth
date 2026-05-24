import 'package:equatable/equatable.dart';

import '../../../photo/domain/photo_entities.dart';
import 'money_balance_entity.dart';


enum AccountType {CUSTOMER ,customer, supplier, workshop, expense ,other }

extension AccountTypeX on AccountType {
  String get apiValue {
    switch (this) {
      case AccountType.CUSTOMER:
        return 'CUSTOMER';
      case AccountType.customer:
        return 'CUSTOMER';
      case AccountType.supplier:
        return 'SUPPLIER';
      case AccountType.workshop:
        return 'WORKSHOP';
      case AccountType.expense:
        return 'EXPENSE';
      case AccountType.other:
        return 'OTHER';
    }
  }

  String get label {
    switch (this) {
      case AccountType.CUSTOMER:
        return 'CUSTOMER';
      case AccountType.customer:
        return 'CUSTOMER';
      case AccountType.supplier:
        return 'SUPPLIER';
      case AccountType.workshop:
        return 'WORKSHOP';
      case AccountType.expense:
        return 'EXPENSE';
      case AccountType.other:
        return 'OTHER';
    }
  }
}

AccountType accountTypeFromString(String value) {
  switch (value.toUpperCase()) {
    case 'CUSTOMER':
      return AccountType.customer;
    case 'SUPPLIER':
      return AccountType.supplier;
    case 'WORKSHOP':
      return AccountType.workshop;
    case 'EXPENSE':
      return AccountType.expense;
    default:
      return AccountType.other;
  }
}

class AccountEntity extends Equatable {
  const AccountEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
    required this.metalBalance,
    required this.moneyBalances,
    required this.sequenceNumber,
    required this.photo,
  });

  final int id;
  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;
  final double metalBalance;
  final List<MoneyBalanceEntity> moneyBalances;
  final String sequenceNumber;
  final List<PhotoEntity> photo;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    phone,
    email,
    description,
    address,
    metalBalance,
    moneyBalances,
    sequenceNumber,
    photo,
  ];
}
