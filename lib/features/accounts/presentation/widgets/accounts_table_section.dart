import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/localization/app_localizations.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/utils/csv_exporter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/components/cards/app_section_card.dart';
import '../../domain/entities/account_entity.dart';
import '../bloc/accounts_bloc.dart';

class AccountsTableSection extends StatefulWidget {
  final bool showTitle;
  final VoidCallback? onCreatePressed;

  const AccountsTableSection({
    super.key,
    this.showTitle = true,
    this.onCreatePressed,
  });

  @override
  State<AccountsTableSection> createState() => _AccountsTableSectionState();
}

class _AccountsTableSectionState extends State<AccountsTableSection> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AccountsBloc>().state;
    if (state.accounts.isEmpty && state.status != AccountsStatus.loading) {
      context.read<AccountsBloc>().add(const AccountsRequested());
    }
    _searchController.text = state.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showExportDialog(BuildContext context, List<AccountEntity> accounts) {
    final csv = CsvExporter.build(
      headers: const ['ID', 'Name', 'Type', 'Phone', 'Email', 'Address'],
      rows: accounts
          .map((e) => [
        e.id.toString(),
        e.name,
        e.type.label,
        e.phone,
        e.email,
        e.address,
      ])
          .toList(),
    );

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('CSV Export'),
          content: SingleChildScrollView(child: SelectableText(csv)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        final accounts = state.filteredAccounts;

        return AppSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  if (widget.showTitle) ...[
                    Text(
                      l10n.translate('accounts'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_horiz_rounded, color: Color(0xFF98A2B3)),
                  ] else ...[
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: l10n.translate('searchAccounts'),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (value) {
                          context.read<AccountsBloc>().add(AccountsSearchChanged(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: widget.onCreatePressed,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Create Account'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showExportDialog(context, accounts),
                      icon: const Icon(Icons.download_rounded),
                      tooltip: 'Export CSV',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),

              // Body Section
              if (state.status == AccountsStatus.loading && accounts.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ))
              else if (state.status == AccountsStatus.failure)
                Center(child: Text(state.errorMessage ?? 'Error loading accounts'))
              else if (accounts.isEmpty)
                  Center(child: Text(l10n.translate('noAccountsFound')))
                else
                  isMobile
                      ? _AccountsMobileList(accounts: accounts)
                      : _AccountsTable(accounts: accounts),
            ],
          ),
        );
      },
    );
  }
}

// --- Desktop Table Widget ---
class _AccountsTable extends StatelessWidget {
  const _AccountsTable({required this.accounts});

  final List<AccountEntity> accounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _buildHeaderCell('ID', flex: 1),
              _buildHeaderCell('Name', flex: 2),
              _buildHeaderCell('Type', flex: 1),
              _buildHeaderCell('Phone', flex: 2),
              _buildHeaderCell('Email', flex: 3),
              _buildHeaderCell('Address', flex: 3),
              _buildHeaderCell('Actions', flex: 1, alignRight: true),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Table Rows
        ...accounts.map((acc) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0F2F5)),
            ),
            child: Row(
              children: [
                _buildDataCell(acc.id.toString(), flex: 1),
                _buildDataCell(acc.name, flex: 2),
                _buildDataCell(acc.type.label, flex: 1),
                _buildDataCell(acc.phone, flex: 2),
                _buildDataCell(acc.email, flex: 3),
                _buildDataCell(acc.address, flex: 3),

                // Actions Column
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.accountDetailsRoute,
                            arguments: acc.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1, bool alignRight = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
      ),
    );
  }
}

// --- Mobile List Widget ---
class _AccountsMobileList extends StatelessWidget {
  const _AccountsMobileList({required this.accounts});

  final List<AccountEntity> accounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: accounts.map((acc) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF0F2F5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      acc.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text('${l10n.translate('id')}: ${acc.id}'),
                    const SizedBox(height: 4),
                    Text('${l10n.translate('type')}: ${acc.type.label}'),
                    const SizedBox(height: 4),
                    Text(acc.phone),
                    const SizedBox(height: 4),
                    Text(acc.email),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.accountDetailsRoute,
                    arguments: acc.id,
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Helper to access localization inside static method easily (or pass l10n as param)
  // For simplicity here I'm using direct string or assuming l10n is accessible.
  // Ideally pass l10n from parent.
  // static AppLocalizations? l10n;
}