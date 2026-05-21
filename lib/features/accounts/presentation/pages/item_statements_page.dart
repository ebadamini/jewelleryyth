import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/components/dropdowns/app_dropdown.dart';
import '../../../../shared/components/dropdowns/searchable_dropdown.dart';
import '../../../../shared/components/indicators/app_loading_indicator.dart';
import '../../domain/entities/metal_balance_entity.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/item_statements_table.dart';

class ItemStatementsPage extends StatefulWidget {
  const ItemStatementsPage({
    super.key,
    required this.accountId,
    required this.accountName,
    required this.itemId,
    required this.itemName,
    required this.availableItems,
  });

  final int accountId;
  final String accountName;
  final int itemId;
  final String itemName;
  final List<MetalBalanceEntity> availableItems;

  @override
  State<ItemStatementsPage> createState() => _ItemStatementsPageState();
}

class _ItemStatementsPageState extends State<ItemStatementsPage> {
  late int _selectedItemId;

  @override
  void initState() {
    super.initState();
    _selectedItemId = widget.itemId;
    context.read<AccountsBloc>().add(
      ItemStatementsRequested(
        accountId: widget.accountId,
        itemId: _selectedItemId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = widget.availableItems
        .map((e) => AppDropdownItem<int>(value: e.itemId, label: e.itemName))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Item Statements - ${widget.accountName}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppSearchableDropdown<int>(
              label: 'Item',
              value: _selectedItemId,
              items: dropdownItems,
              prefixIcon: const Icon(Icons.inventory_2_outlined),
              onChanged: (value) {
                setState(() => _selectedItemId = value);
                context.read<AccountsBloc>().add(
                  ItemStatementsRequested(
                    accountId: widget.accountId,
                    itemId: value,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AccountsBloc, AccountsState>(
                builder: (context, state) {
                  if (state.status == AccountsStatus.loading) {
                    return const Center(child: AppLoadingIndicator(size: 28));
                  }
                  if (state.itemStatements.isEmpty) {
                    return const Center(child: Text('No item statements found'));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ItemStatementsTable(items: state.itemStatements),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
