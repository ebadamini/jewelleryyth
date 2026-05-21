import 'package:equatable/equatable.dart';

import 'money_balance_entity.dart';

enum AccountType { customer, supplier, other }

extension AccountTypeX on AccountType {
  String get apiValue {
    switch (this) {
      case AccountType.customer:
        return 'CUSTOMER';
      case AccountType.supplier:
        return 'SUPPLIER';
      case AccountType.other:
        return 'OTHER';
    }
  }

  String get label {
    switch (this) {
      case AccountType.customer:
        return 'Customer';
      case AccountType.supplier:
        return 'Supplier';
      case AccountType.other:
        return 'Other';
    }
  }
}

AccountType accountTypeFromString(String value) {
  switch (value.toUpperCase()) {
    case 'CUSTOMER':
      return AccountType.customer;
    case 'SUPPLIER':
      return AccountType.supplier;
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
  ];
}
