import 'package:equatable/equatable.dart';

class MetalBalanceEntity extends Equatable {
  const MetalBalanceEntity({
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

  @override
  List<Object?> get props => [
    accountId,
    itemId,
    itemName,
    totalWeight,
    totalFineWeight,
  ];
}
