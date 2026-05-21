import 'package:flutter/material.dart';

import '../../../../shared/components/buttons/app_button.dart';
import '../../domain/entities/money_balance_entity.dart';

class MoneyBalancesCard extends StatelessWidget {
  const MoneyBalancesCard({
    super.key,
    required this.balances,
    required this.onViewStatements,
  });

  final List<MoneyBalanceEntity> balances;
  final ValueChanged<String> onViewStatements;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: balances
              .map(
                (balance) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(balance.currency),
                      subtitle: Text('Balance: ${balance.balance.toStringAsFixed(2)}'),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: AppButton(
                      label: 'Money Statements',
                      onPressed: () => onViewStatements(balance.currency),
                    ),
                  ),
                ],
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
