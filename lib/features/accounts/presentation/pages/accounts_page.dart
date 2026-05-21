import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/app/localization/app_localizations.dart';
import 'package:jewelleryyth/core/widgets/reusable_table/controllers/table_controller.dart';
import 'package:jewelleryyth/core/widgets/reusable_table/models/table_column.dart';
import 'package:jewelleryyth/core/widgets/reusable_table/widgets/reusable_data_table.dart';
import 'package:jewelleryyth/features/accounts/domain/entities/account_entity.dart';
import 'package:jewelleryyth/features/accounts/presentation/bloc/accounts_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';


class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
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
      // ⚠️ اگه AccountEntity createdAt داره، uncomment کن:
      // dateGetter: (item) => item.createdAt,
    );


    if (state.listStatus != AccountsListStatus.success ||
        state.accounts.isEmpty) {
      bloc.add(const AccountsRequested());
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        key: 'type',
        titleKey: 'accountType',
        width: 120,
        valueGetter: (d) => d.type,
        displayValue: (context, d){
          final l10n = AppLocalizations.of(context);
          switch(d.type){
            case AccountType.customer:
              return l10n.translate('customers');
            case AccountType.supplier:
              return l10n.translate("supplier");
            case AccountType.workshop:
              return l10n.translate("workshop");
            case AccountType.expense:
              return l10n.translate("expense");
            case AccountType.other:
              return l10n.translate("other");
          }
        },
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
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: isRtl ? Text('حذف حساب') : Text("Delete Account"),
        content: isRtl ? Text('آیا از حذف "${account.name}" مطمئن هستید؟')  : Text('"Are you sure want to delete ${account.name} Account?"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: isRtl ? Text('انصراف') : Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<AccountsBloc>().add(AccountDeleted(account.id));
              Navigator.pop(context);
            },
            child: isRtl ? Text('حذف', style: TextStyle(color: Colors.red)) : Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return VisibilityDetector(
      key: const Key('accounts-page'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !_hasLoaded) {
          _hasLoaded = true;
          final state = context.read<AccountsBloc>().state;
          if (state.accounts.isEmpty &&
              state.listStatus != AccountsListStatus.loading) {
            context.read<AccountsBloc>().add(const AccountsRequested());
          }
        }
      },
      child: Scaffold(
        body: BlocConsumer<AccountsBloc, AccountsState>(
          listener: (context, state) {
            if (state.listStatus == AccountsListStatus.success) {
              _controller.refresh(state.filteredAccounts);
            }
          },
          builder: (context, state) {
            // ✅ فقط وقتی واقعاً هیچ دیتایی نداریم و در حال لود هستیم
            final isInitialLoading =
                state.listStatus == AccountsListStatus.loading &&
                    state.accounts.isEmpty;

            final isError =
                state.listStatus == AccountsListStatus.failure &&
                    state.accounts.isEmpty;

            if (isInitialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (isError) {
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
                        const AccountsRequested(),
                      ),
                      child:  Text(l10n.translate("reTry")),
                    ),
                  ],
                ),
              );
            }

            return ReusableDataTable<AccountEntity>(
              controller: _controller,

              title: l10n.translate("accountsList"),
              exportFileName: 'accounts',
              showDateFilter: true,
              showPagination: true,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF111111),
          child: const Icon(Icons.add),
        ),
      ),
    );

  }
}
