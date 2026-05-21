import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../domain/entities/account_entity.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/account_form.dart';

class EditAccountPage extends StatelessWidget {
  const EditAccountPage({
    super.key,
    required this.account,
  });

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Account')),
      body: BlocListener<AccountsBloc, AccountsState>(
        listener: (context, state) {
          if (state.lastActionSuccess && state.selectedAccount != null) {
            Navigator.of(context).pushReplacementNamed(
              AppRouter.accountDetailsRoute,
              arguments: state.selectedAccount!.id,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<AccountsBloc, AccountsState>(
            builder: (context, state) {
              return AccountForm(
                initialName: account.name,
                initialType: account.type,
                initialPhone: account.phone,
                initialEmail: account.email,
                initialDescription: account.description,
                initialAddress: account.address,
                submitLabel: 'Save Changes',
                isLoading: state.listStatus == AccountsListStatus.loading,
                onSubmit: ({
                  required String name,
                  required type,
                  required String phone,
                  required String email,
                  required String description,
                  required String address,
                }) {
                  context.read<AccountsBloc>().add(
                    AccountUpdated(
                      id: account.id,
                      name: name,
                      type: type,
                      phone: phone,
                      email: email,
                      description: description,
                      address: address,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
