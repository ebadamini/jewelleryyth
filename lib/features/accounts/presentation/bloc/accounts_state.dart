part of 'accounts_bloc.dart';

enum AccountsListStatus { initial, loading, success, failure }
enum AccountDetailsStatus { initial, loading, success, failure }
enum MetalsStatus { initial, loading, success, failure }
enum MoneyStatementsStatus { initial, loading, success, failure }
enum ItemStatementsStatus { initial, loading, success, failure }

class AccountsState extends Equatable {
  const AccountsState({
    this.listStatus = AccountsListStatus.initial,
    this.detailsStatus = AccountDetailsStatus.initial,
    this.metalsStatus = MetalsStatus.initial,
    this.moneyStatementsStatus = MoneyStatementsStatus.initial,
    this.itemStatementsStatus = ItemStatementsStatus.initial,
    this.accounts = const [],
    this.filteredAccounts = const [],
    this.selectedAccount,
    this.moneyStatements = const [],
    this.metals = const [],
    this.itemStatements = const [],
    this.searchQuery = '',
    this.selectedCurrency,
    this.selectedItemId,
    this.errorMessage,
    this.lastActionSuccess = false,
  });

  final AccountsListStatus listStatus;
  final AccountDetailsStatus detailsStatus;
  final MetalsStatus metalsStatus;
  final MoneyStatementsStatus moneyStatementsStatus;
  final ItemStatementsStatus itemStatementsStatus;
  final List<AccountEntity> accounts;
  final List<AccountEntity> filteredAccounts;
  final AccountEntity? selectedAccount;
  final List<MoneyStatementEntity> moneyStatements;
  final List<MetalBalanceEntity> metals;
  final List<ItemStatementEntity> itemStatements;
  final String searchQuery;
  final String? selectedCurrency;
  final int? selectedItemId;
  final String? errorMessage;
  final bool lastActionSuccess;

  AccountsState copyWith({
    AccountsListStatus? listStatus,
    AccountDetailsStatus? detailsStatus,
    MetalsStatus? metalsStatus,
    MoneyStatementsStatus? moneyStatementsStatus,
    ItemStatementsStatus? itemStatementsStatus,
    List<AccountEntity>? accounts,
    List<AccountEntity>? filteredAccounts,
    AccountEntity? selectedAccount,
    List<MoneyStatementEntity>? moneyStatements,
    List<MetalBalanceEntity>? metals,
    List<ItemStatementEntity>? itemStatements,
    String? searchQuery,
    String? selectedCurrency,
    int? selectedItemId,
    String? errorMessage,
    bool clearError = false,
    bool? lastActionSuccess,
  }) {
    return AccountsState(
      listStatus: listStatus ?? this.listStatus,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      metalsStatus: metalsStatus ?? this.metalsStatus,
      moneyStatementsStatus: moneyStatementsStatus ?? this.moneyStatementsStatus,
      itemStatementsStatus: itemStatementsStatus ?? this.itemStatementsStatus,
      accounts: accounts ?? this.accounts,
      filteredAccounts: filteredAccounts ?? this.filteredAccounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      moneyStatements: moneyStatements ?? this.moneyStatements,
      metals: metals ?? this.metals,
      itemStatements: itemStatements ?? this.itemStatements,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      selectedItemId: selectedItemId ?? this.selectedItemId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastActionSuccess: lastActionSuccess ?? this.lastActionSuccess,
    );
  }

  @override
  List<Object?> get props => [
    listStatus,
    detailsStatus,
    metalsStatus,
    moneyStatementsStatus,
    itemStatementsStatus,
    accounts,
    filteredAccounts,
    selectedAccount,
    moneyStatements,
    metals,
    itemStatements,
    searchQuery,
    selectedCurrency,
    selectedItemId,
    errorMessage,
    lastActionSuccess,
  ];
}