import 'package:equatable/equatable.dart';

class MoneyBalanceEntity extends Equatable {
  const MoneyBalanceEntity({
    required this.accountId,
    required this.currency,
    required this.balance,
  });

  final int accountId;
  final String currency;
  final double balance;

  @override
  List<Object?> get props => [accountId, currency, balance];
}
