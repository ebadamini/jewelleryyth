part of 'accounts_bloc.dart';

enum AccountsStatus { initial, loading, success, failure }

class AccountsState extends Equatable {
  const AccountsState({
    this.status = AccountsStatus.initial,
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

  final AccountsStatus status;
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
    AccountsStatus? status,
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
      status: status ?? this.status,
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
    status,
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
