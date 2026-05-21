import '../../domain/entities/account_entity.dart';
import '../../domain/entities/money_balance_entity.dart';
import 'money_balance_dto.dart';

class AccountResponseDto {
  const AccountResponseDto({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
    required this.metalBalance,
    required this.moneyBalances,
    required this.createdAt,
  });

  final int id;
  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;
  final double metalBalance;
  final List<MoneyBalanceDto> moneyBalances;
  final String createdAt;

  factory AccountResponseDto.fromJson(Map<String, dynamic> json) {
    final balances = (json['moneyBalances'] as List<dynamic>? ?? [])
        .map((e) => MoneyBalanceDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return AccountResponseDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      type: accountTypeFromString(json['type']?.toString() ?? ''),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      metalBalance: (json['metalBalance'] as num?)?.toDouble() ?? 0,
      moneyBalances: balances,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      name: name,
      type: type,
      phone: phone,
      email: email,
      description: description,
      address: address,
      metalBalance: metalBalance,
      moneyBalances: moneyBalances.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}
