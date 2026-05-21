import 'package:flutter/material.dart';

import '../../domain/entities/item_statement_entity.dart';

class ItemStatementsTable extends StatelessWidget {
  const ItemStatementsTable({
    super.key,
    required this.items,
  });

  final List<ItemStatementEntity> items;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Item')),
        DataColumn(label: Text('Direction')),
        DataColumn(label: Text('Counterparty')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Fine')),
        DataColumn(label: Text('Prev')),
        DataColumn(label: Text('Current')),
      ],
      rows: items
          .map(
            (e) => DataRow(
          cells: [
            DataCell(Text(e.createdAt.toIso8601String())),
            DataCell(Text(e.itemName)),
            DataCell(Text(e.direction)),
            DataCell(Text(e.counterparty)),
            DataCell(Text(e.amount.toStringAsFixed(2))),
            DataCell(Text(e.fineAmount.toStringAsFixed(2))),
            DataCell(Text(e.prevBalance.toStringAsFixed(2))),
            DataCell(Text(e.currentBalance.toStringAsFixed(2))),
          ],
        ),
      )
          .toList(),
    );
  }
}
