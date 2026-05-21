import 'package:flutter/material.dart';

import '../../domain/entities/money_statement_entity.dart';

class MoneyStatementsTable extends StatelessWidget {
  const MoneyStatementsTable({
    super.key,
    required this.items,
  });

  final List<MoneyStatementEntity> items;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Currency')),
        DataColumn(label: Text('Direction')),
        DataColumn(label: Text('Counterparty')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Prev')),
        DataColumn(label: Text('Current')),
      ],
      rows: items
          .map(
            (e) => DataRow(
          cells: [
            DataCell(Text(e.createdAt.toIso8601String())),
            DataCell(Text(e.currency)),
            DataCell(Text(e.direction)),
            DataCell(Text(e.counterparty)),
            DataCell(Text(e.amount.toStringAsFixed(2))),
            DataCell(Text(e.prevBalance.toStringAsFixed(2))),
            DataCell(Text(e.currentBalance.toStringAsFixed(2))),
          ],
        ),
      )
          .toList(),
    );
  }
}
