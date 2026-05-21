import '../../domain/entities/metal_balance_entity.dart';

class MetalBalanceDto {
  const MetalBalanceDto({
    required this.accountId,
    required this.itemId,
    required this.itemName,
    required this.totalWeight,
    required this.totalFineWeight,
  });

  final int accountId;
  final int itemId;
  final String itemName;
  final double totalWeight;
  final double totalFineWeight;

  factory MetalBalanceDto.fromJson(Map<String, dynamic> json) {
    return MetalBalanceDto(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      itemId: (json['itemId'] as num?)?.toInt() ?? 0,
      itemName: json['itemName']?.toString() ?? '',
      totalWeight: (json['totalWeight'] as num?)?.toDouble() ?? 0,
      totalFineWeight: (json['totalFineWeight'] as num?)?.toDouble() ?? 0,
    );
  }

  MetalBalanceEntity toEntity() {
    return MetalBalanceEntity(
      accountId: accountId,
      itemId: itemId,
      itemName: itemName,
      totalWeight: totalWeight,
      totalFineWeight: totalFineWeight,
    );
  }
}
