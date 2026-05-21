import 'package:equatable/equatable.dart';

class ItemStatementEntity extends Equatable {
  const ItemStatementEntity({
    required this.transactionId,
    required this.createdAt,
    required this.itemName,
    required this.direction,
    required this.counterparty,
    required this.amount,
    required this.fineAmount,
    required this.prevBalance,
    required this.currentBalance,
  });

  final int transactionId;
  final DateTime createdAt;
  final String itemName;
  final String direction;
  final String counterparty;
  final double amount;
  final double fineAmount;
  final double prevBalance;
  final double currentBalance;

  @override
  List<Object?> get props => [
    transactionId,
    createdAt,
    itemName,
    direction,
    counterparty,
    amount,
    fineAmount,
    prevBalance,
    currentBalance,
  ];
}
