import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_customers_use_case.dart';
import '../../../../app/router/app_router.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/create_account_use_case.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/get_account_by_id_use_case.dart';
import '../../domain/usecases/get_account_metals_use_case.dart';
import '../../domain/usecases/get_accounts_use_case.dart';
import '../../domain/usecases/get_item_statements_use_case.dart';
import '../../domain/usecases/get_money_statements_use_case.dart';
import '../../domain/usecases/update_account_use_case.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/metals_table.dart';
import '../widgets/money_balances_card.dart';

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({super.key, required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final state = context.read<AccountsBloc>().state;
              if (state.selectedAccount != null) {
                Navigator.of(context).pushNamed(
                  AppRouter.accountEditRoute,
                  arguments: state.selectedAccount,
                );
              }
            },
          ),
        ],
      ),
      body: _AccountDetailsView(accountId: accountId),
    );
  }
}

class _AccountDetailsView extends StatefulWidget {
  const _AccountDetailsView({required this.accountId});

  final int accountId;

  @override
  State<_AccountDetailsView> createState() => _AccountDetailsViewState();
}

class _AccountDetailsViewState extends State<_AccountDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<AccountsBloc>().add(AccountDetailsLoaded(widget.accountId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        if (state.detailsStatus == AccountDetailsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.detailsStatus == AccountDetailsStatus.failure) {
          return Center(child: Text(state.errorMessage ?? 'Error loading account'));
        }

        final account = state.selectedAccount;
        if (account == null) return const Center(child: Text('Account not found'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Money Balances', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              MoneyBalancesCard(
                balances: account.moneyBalances,
                onViewStatements: (currency) {
                  Navigator.of(context).pushNamed(
                    AppRouter.moneyStatementsRoute,
                    arguments: {
                      'accountId': widget.accountId,
                      'accountName': account.name,
                      'currency': currency,
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text('Metal Stock', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              if (state.metalsStatus == MetalsStatus.loading)
                const Center(child: CircularProgressIndicator())
              else if (state.metalsStatus == MetalsStatus.failure)
                Card(child: ListTile(title: Text('Error: ${state.errorMessage}')))
              else if (state.metals.isEmpty)
                  const Card(child: ListTile(title: Text('No metal stock found')))
                else
                  MetalsTable(
                    items: state.metals,
                    onViewStatements: (metal) {
                      Navigator.of(context).pushNamed(
                        AppRouter.itemStatementsRoute,
                        arguments: {
                          'accountId': widget.accountId,
                          'accountName': account.name,
                          'itemId': metal.itemId,
                          'itemName': metal.itemName,
                          'availableItems': state.metals,
                        },
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}