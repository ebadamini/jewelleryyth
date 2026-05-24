import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/core/widgets/reusable_table/controllers/table_controller.dart';
import 'package:jewelleryyth/core/widgets/reusable_table/widgets/reusable_data_table.dart';
import 'package:jewelleryyth/features/accounts/domain/entities/account_entity.dart';
import 'package:jewelleryyth/features/accounts/presentation/bloc/accounts_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/widgets/reusable_table/models/table_column.dart';


class CustomersListPage extends StatefulWidget {
  const CustomersListPage({super.key});

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  late final TableController<AccountEntity> _controller;
  bool _hasLoaded = false;


  @override
  void initState() {
    super.initState();

    final bloc = context.read<AccountsBloc>();
    final state = bloc.state;

    // اگه از قبل دیتا داریم، بریز توی controller
    // اگه نداریم، request بفرست
    final initialItems = state.listStatus == AccountsListStatus.success
        ? state.filteredAccounts
        : const <AccountEntity>[];

    _controller = TableController<AccountEntity>(
        columns: _buildColumns(),
        items: initialItems,

    );

    if (state.listStatus != AccountsListStatus.success || state.accounts.isEmpty) {
      bloc.add(const CustomersRequested());
    }
  }


  List<ColumnConfig<AccountEntity>> _buildColumns() {

    return [
      ColumnConfig(
        key: 'name',
        titleKey: "customerName",
        valueGetter: (d) => d.name,
        width: 160,
      ),
      ColumnConfig(
        key: 'phone',
        titleKey: "phoneNumber",
        valueGetter: (d) => d.phone,
        width: 130,
      ),
      ColumnConfig(
        key: 'email',
        titleKey: "email",
        valueGetter: (d) => d.email,
        width: 130,
      ),
      ColumnConfig(
        key: 'metalBalance',
        titleKey: 'metalBalance',
        width: 120,
        valueGetter: (d) => d.metalBalance,
      ),
      ColumnConfig(
        key: 'actions',
        titleKey: "actions",
        width: 100,
        sortable: false,
        searchable: false,
        cellBuilder: (context, data, index, isRtl) {
          final l10n = AppLocalizations.of(context);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: l10n.translate("edit"),
                onPressed: () => _onEdit(data),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Color(0xFFD92D20),
                ),
                tooltip: l10n.translate("delete"),
                onPressed: () => _onDelete(data),
              ),
            ],
          );
        },
      ),
    ];
  }


  void _onEdit(AccountEntity account) {
    // مثال: context.go('/accounts/edit/${account.id}');
    // یا Navigator.pushNamed(context, AppRouter.accountEditRoute, arguments: account.id);
  }

  void _onDelete(AccountEntity account) {
    // final isRtl = Localizations.localeOf(context).languageCode == 'fa';
    // final l10n = AppLocalizations.of(context);

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title:  Text(l10n.translate("deleteAccount")),
    //     content: Text('"${l10n.translate("areYouSure")} "'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: isRtl ? Text('انصراف') : Text("Cancel"),
    //       ),
    //       TextButton(
    //         onPressed: () {
    //           context.read<AccountsBloc>().add(AccountDeleted(account.id));
    //           Navigator.pop(context);
    //         },
    //         child: isRtl ? Text('حذف', style: TextStyle(color: Colors.red)) : Text('Delete', style: TextStyle(color: Colors.red)),
    //       ),
    //     ],
    //   ),
    // );
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);


    return VisibilityDetector(
        key: const Key('customers-page'),
        onVisibilityChanged: (info){
          if(info.visibleFraction > 0 && !_hasLoaded){
            _hasLoaded = true;
            final state = context.read<AccountsBloc>().state;
            if(state.accounts.isEmpty && state.listStatus != AccountsListStatus.loading){
              context.read<AccountsBloc>().add(CustomersRequested());
            }
          }
        },
      child: Scaffold(
        body: BlocConsumer<AccountsBloc, AccountsState>(
            listener: (context, state){
              if(state.listStatus == AccountsListStatus.success){
                _controller.refresh(state.filteredAccounts);
              }
            },
          builder: (context, state){
              final isInitialLoading =
                  state.listStatus == AccountsListStatus.loading &&
            state.accounts.isEmpty;
              final isError =
                  state.listStatus == AccountsListStatus.failure &&
            state.accounts.isEmpty;

              if(isInitialLoading){
                return const Center(child: CircularProgressIndicator(),);
              }

              if(isError){
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Color(0xFFD92D20),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage ?? l10n.translate("errorDataNotFound"),
                        style: const TextStyle(color: Color(0xFF667085)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<AccountsBloc>().add(
                          const CustomersRequested(),
                        ),
                        child:  Text(l10n.translate("reTry")),
                      ),
                    ],
                  ),
                );
              }

              return ReusableDataTable(
                  controller: _controller,
                title: l10n.translate("customersList"),
                exportFileName: "customers",
                showDateFilter: false,
                showPagination: true,
              );
          },
        ),
      ),
    );
  }
}
