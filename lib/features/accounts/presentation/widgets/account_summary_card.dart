import 'package:flutter/material.dart';

import '../../domain/entities/account_entity.dart';

class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({
    super.key,
    required this.account,
    required this.onTap,
  });

  final AccountEntity account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(account.name.isNotEmpty ? account.name[0] : 'A'),
        ),
        title: Text(account.name),
        subtitle: Text('${account.phone} • ${account.email}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(account.type.label),
            Text(account.metalBalance.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}
