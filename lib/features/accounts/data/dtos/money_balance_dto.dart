import '../../domain/entities/money_balance_entity.dart';

class MoneyBalanceDto {
  const MoneyBalanceDto({
    required this.accountId,
    required this.currency,
    required this.balance,
  });

  final int accountId;
  final String currency;
  final double balance;

  factory MoneyBalanceDto.fromJson(Map<String, dynamic> json) {
    return MoneyBalanceDto(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
    );
  }

  MoneyBalanceEntity toEntity() {
    return MoneyBalanceEntity(
      accountId: accountId,
      currency: currency,
      balance: balance,
    );
  }
}
