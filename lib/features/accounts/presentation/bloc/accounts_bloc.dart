import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/item_statement_entity.dart';
import '../../domain/entities/metal_balance_entity.dart';
import '../../domain/entities/money_statement_entity.dart';
import '../../domain/usecases/create_account_use_case.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/get_account_by_id_use_case.dart';
import '../../domain/usecases/get_account_metals_use_case.dart';
import '../../domain/usecases/get_accounts_use_case.dart';
import '../../domain/usecases/get_item_statements_use_case.dart';
import '../../domain/usecases/get_money_statements_use_case.dart';
import '../../domain/usecases/update_account_use_case.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc({
    required GetAccountsUseCase getAccountsUseCase,
    required GetAccountByIdUseCase getAccountByIdUseCase,
    required CreateAccountUseCase createAccountUseCase,
    required UpdateAccountUseCase updateAccountUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required GetMoneyStatementsUseCase getMoneyStatementsUseCase,
    required GetAccountMetalsUseCase getAccountMetalsUseCase,
    required GetItemStatementsUseCase getItemStatementsUseCase,
  })  : _getAccountsUseCase = getAccountsUseCase,
        _getAccountByIdUseCase = getAccountByIdUseCase,
        _createAccountUseCase = createAccountUseCase,
        _updateAccountUseCase = updateAccountUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _getMoneyStatementsUseCase = getMoneyStatementsUseCase,
        _getAccountMetalsUseCase = getAccountMetalsUseCase,
        _getItemStatementsUseCase = getItemStatementsUseCase,
        super(const AccountsState()) {
    on<AccountsRequested>(_onAccountsRequested);
    on<AccountsSearchChanged>(_onAccountsSearchChanged);
    on<AccountDetailsRequested>(_onAccountDetailsRequested);
    on<AccountCreated>(_onAccountCreated);
    on<AccountUpdated>(_onAccountUpdated);
    on<AccountDeleted>(_onAccountDeleted);
    on<MoneyStatementsRequested>(_onMoneyStatementsRequested);
    on<AccountMetalsRequested>(_onAccountMetalsRequested);
    on<ItemStatementsRequested>(_onItemStatementsRequested);
  }

  final GetAccountsUseCase _getAccountsUseCase;
  final GetAccountByIdUseCase _getAccountByIdUseCase;
  final CreateAccountUseCase _createAccountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetMoneyStatementsUseCase _getMoneyStatementsUseCase;
  final GetAccountMetalsUseCase _getAccountMetalsUseCase;
  final GetItemStatementsUseCase _getItemStatementsUseCase;

  Future<void> _onAccountsRequested(
      AccountsRequested event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true, lastActionSuccess: false));
    try {
      final accounts = await _getAccountsUseCase();
      emit(state.copyWith(
        status: AccountsStatus.success,
        accounts: accounts,
        filteredAccounts: _applySearch(accounts, state.searchQuery),
      ));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onAccountsSearchChanged(
      AccountsSearchChanged event,
      Emitter<AccountsState> emit,
      ) {
    emit(state.copyWith(
      searchQuery: event.query,
      filteredAccounts: _applySearch(state.accounts, event.query),
    ));
  }

  Future<void> _onAccountDetailsRequested(
      AccountDetailsRequested event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true));
    try {
      final account = await _getAccountByIdUseCase(event.accountId);
      emit(state.copyWith(status: AccountsStatus.success, selectedAccount: account));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAccountCreated(
      AccountCreated event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true, lastActionSuccess: false));
    try {
      final account = await _createAccountUseCase(
        name: event.name,
        type: event.type,
        phone: event.phone,
        email: event.email,
        description: event.description,
        address: event.address,
      );
      emit(state.copyWith(
        status: AccountsStatus.success,
        selectedAccount: account,
        lastActionSuccess: true,
      ));
      add(const AccountsRequested());
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAccountUpdated(
      AccountUpdated event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true, lastActionSuccess: false));
    try {
      final account = await _updateAccountUseCase(
        id: event.id,
        name: event.name,
        type: event.type,
        phone: event.phone,
        email: event.email,
        description: event.description,
        address: event.address,
      );
      emit(state.copyWith(
        status: AccountsStatus.success,
        selectedAccount: account,
        lastActionSuccess: true,
      ));
      add(AccountDetailsRequested(account.id));
      add(AccountMetalsRequested(account.id));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAccountDeleted(
      AccountDeleted event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true, lastActionSuccess: false));
    try {
      await _deleteAccountUseCase(event.accountId);
      emit(state.copyWith(
        status: AccountsStatus.success,
        selectedAccount: null,
        moneyStatements: const [],
        metals: const [],
        itemStatements: const [],
        lastActionSuccess: true,
      ));
      add(const AccountsRequested());
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onMoneyStatementsRequested(
      MoneyStatementsRequested event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true, selectedCurrency: event.currency));
    try {
      final statements = await _getMoneyStatementsUseCase(
        accountId: event.accountId,
        currency: event.currency,
      );
      emit(state.copyWith(
        status: AccountsStatus.success,
        moneyStatements: statements,
        selectedCurrency: event.currency,
      ));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAccountMetalsRequested(
      AccountMetalsRequested event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true));
    try {
      final metals = await _getAccountMetalsUseCase(event.accountId);
      emit(state.copyWith(status: AccountsStatus.success, metals: metals));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onItemStatementsRequested(
      ItemStatementsRequested event,
      Emitter<AccountsState> emit,
      ) async {
    emit(state.copyWith(status: AccountsStatus.loading, clearError: true, selectedItemId: event.itemId));
    try {
      final statements = await _getItemStatementsUseCase(
        accountId: event.accountId,
        itemId: event.itemId,
      );
      emit(state.copyWith(
        status: AccountsStatus.success,
        itemStatements: statements,
        selectedItemId: event.itemId,
      ));
    } catch (e) {
      emit(state.copyWith(status: AccountsStatus.failure, errorMessage: e.toString()));
    }
  }

  List<AccountEntity> _applySearch(List<AccountEntity> accounts, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return accounts;

    return accounts.where((account) {
      return account.name.toLowerCase().contains(q) ||
          account.phone.toLowerCase().contains(q) ||
          account.email.toLowerCase().contains(q) ||
          account.address.toLowerCase().contains(q) ||
          account.description.toLowerCase().contains(q);
    }).toList();
  }
}
