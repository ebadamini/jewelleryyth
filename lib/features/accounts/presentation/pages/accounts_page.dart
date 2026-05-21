import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/features/accounts/presentation/widgets/accounts_table_section.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/components/indicators/app_loading_indicator.dart';
import '../../../../shared/components/layout/responsive_container.dart';
import '../bloc/accounts_bloc.dart';
import '../widgets/account_summary_card.dart';
import '../widgets/accounts_filter_bar.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AccountsBloc>().add(const AccountsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveContainer(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AccountsTableSection(
            showTitle: false,
            onCreatePressed: (){
              Navigator.of(context).pushNamed(AppRouter.accountCreateRoute);
            },
          ),
        ),
      ),
    );
  }
}
