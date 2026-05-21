import '../../domain/entities/money_statement_entity.dart';

class MoneyStatementDto {
  const MoneyStatementDto({
    required this.transactionId,
    required this.createdAt,
    required this.currency,
    required this.direction,
    required this.counterparty,
    required this.amount,
    required this.prevBalance,
    required this.currentBalance,
  });

  final int transactionId;
  final DateTime createdAt;
  final String currency;
  final String direction;
  final String counterparty;
  final double amount;
  final double prevBalance;
  final double currentBalance;

  factory MoneyStatementDto.fromJson(Map<String, dynamic> json) {
    return MoneyStatementDto(
      transactionId: (json['transactionId'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      currency: json['currency']?.toString() ?? '',
      direction: json['direction']?.toString() ?? '',
      counterparty: json['counterparty']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      prevBalance: (json['prevBalance'] as num?)?.toDouble() ?? 0,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0,
    );
  }

  MoneyStatementEntity toEntity() {
    return MoneyStatementEntity(
      transactionId: transactionId,
      createdAt: createdAt,
      currency: currency,
      direction: direction,
      counterparty: counterparty,
      amount: amount,
      prevBalance: prevBalance,
      currentBalance: currentBalance,
    );
  }
}
