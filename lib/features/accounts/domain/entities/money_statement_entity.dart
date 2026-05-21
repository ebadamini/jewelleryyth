import 'package:equatable/equatable.dart';

class MoneyStatementEntity extends Equatable {
  const MoneyStatementEntity({
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

  @override
  List<Object?> get props => [
    transactionId,
    createdAt,
    currency,
    direction,
    counterparty,
    amount,
    prevBalance,
    currentBalance,
  ];
}
