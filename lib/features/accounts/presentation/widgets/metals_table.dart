import 'package:flutter/material.dart';

import '../../../../shared/components/buttons/app_button.dart';
import '../../domain/entities/metal_balance_entity.dart';

class MetalsTable extends StatelessWidget {
  const MetalsTable({
    super.key,
    required this.items,
    required this.onViewStatements,
  });

  final List<MetalBalanceEntity> items;
  final ValueChanged<MetalBalanceEntity> onViewStatements;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Item')),
        DataColumn(label: Text('Weight')),
        DataColumn(label: Text('Fine Weight')),
        DataColumn(label: Text('Action')),
      ],
      rows: items
          .map(
            (e) => DataRow(
          cells: [
            DataCell(Text(e.itemName)),
            DataCell(Text(e.totalWeight.toStringAsFixed(2))),
            DataCell(Text(e.totalFineWeight.toStringAsFixed(2))),
            DataCell(
              SizedBox(
                width: 150,
                child: AppButton(
                  label: 'Item Statements',
                  onPressed: () => onViewStatements(e),
                ),
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}
