import '../../domain/entities/item_statement_entity.dart';

class ItemStatementDto {
  const ItemStatementDto({
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

  factory ItemStatementDto.fromJson(Map<String, dynamic> json) {
    return ItemStatementDto(
      transactionId: (json['transactionId'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      itemName: json['itemName']?.toString() ?? '',
      direction: json['direction']?.toString() ?? '',
      counterparty: json['counterparty']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      fineAmount: (json['fineAmount'] as num?)?.toDouble() ?? 0,
      prevBalance: (json['prevBalance'] as num?)?.toDouble() ?? 0,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0,
    );
  }

  ItemStatementEntity toEntity() {
    return ItemStatementEntity(
      transactionId: transactionId,
      createdAt: createdAt,
      itemName: itemName,
      direction: direction,
      counterparty: counterparty,
      amount: amount,
      fineAmount: fineAmount,
      prevBalance: prevBalance,
      currentBalance: currentBalance,
    );
  }
}
