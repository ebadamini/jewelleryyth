import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router/app_router.dart';
import '../../domain/entities/account_entity.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/metals_table.dart';
import '../widgets/money_balances_card.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key, required this.accountId});

  final int accountId;

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  @override
  void initState() {
    super.initState();
    // دریافت اطلاعات حساب و فلزات
    context.read<AccountsBloc>().add(AccountDetailsRequested(widget.accountId));
    context.read<AccountsBloc>().add(AccountMetalsRequested(widget.accountId));
  }

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
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: () {
          //     // Add Delete Confirmation Dialog
          //     context.read<AccountsBloc>().add(AccountDeleted(widget.accountId));
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
      body: BlocBuilder<AccountsBloc, AccountsState>(
        builder: (context, state) {
          if (state.status == AccountsStatus.loading && state.selectedAccount == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final account = state.selectedAccount;
          if (account == null) return const Center(child: Text('Account not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                // موجودی پول
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

                // موجودی طلا/فلزات
                Text('Metal Stock', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                if (state.metals.isEmpty)
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
      ),
    );
  }
}