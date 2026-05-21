import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/components/dropdowns/app_dropdown.dart';
import '../../../../shared/components/indicators/app_loading_indicator.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/money_statements_table.dart';

class MoneyStatementsPage extends StatefulWidget {
  const MoneyStatementsPage({
    super.key,
    required this.accountId,
    required this.accountName,
    required this.currency,
  });

  final int accountId;
  final String accountName;
  final String currency;

  @override
  State<MoneyStatementsPage> createState() => _MoneyStatementsPageState();
}

class _MoneyStatementsPageState extends State<MoneyStatementsPage> {
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currency;
    context.read<AccountsBloc>().add(
      MoneyStatementsRequested(
        accountId: widget.accountId,
        currency: _selectedCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = context.select((AccountsBloc bloc) => bloc.state.selectedAccount);
    final currencies = account?.moneyBalances.map((e) => e.currency).toSet().toList() ?? [widget.currency];

    return Scaffold(
      appBar: AppBar(title: Text('Money Statements - ${widget.accountName}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppDropdown<String>(
              label: 'Currency',
              value: _selectedCurrency,
              prefixIcon: const Icon(Icons.currency_exchange),
              items: currencies.map((e) => AppDropdownItem(value: e, label: e)).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCurrency = value);
                context.read<AccountsBloc>().add(
                  MoneyStatementsRequested(
                    accountId: widget.accountId,
                    currency: value,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AccountsBloc, AccountsState>(
                builder: (context, state) {
                  if (state.listStatus == AccountsListStatus.loading) {
                    return const Center(child: AppLoadingIndicator(size: 28));
                  }
                  if (state.moneyStatements.isEmpty) {
                    return const Center(child: Text('No money statements found'));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: MoneyStatementsTable(items: state.moneyStatements),
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
