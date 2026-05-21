part of 'accounts_bloc.dart';

sealed class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class AccountsRequested extends AccountsEvent {
  const AccountsRequested();
}

class AccountsSearchChanged extends AccountsEvent {
  const AccountsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class AccountDetailsRequested extends AccountsEvent {
  const AccountDetailsRequested(this.accountId);

  final int accountId;

  @override
  List<Object?> get props => [accountId];
}

class AccountCreated extends AccountsEvent {
  const AccountCreated({
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
  });

  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;

  @override
  List<Object?> get props => [name, type, phone, email, description, address];
}

class AccountUpdated extends AccountsEvent {
  const AccountUpdated({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
  });

  final int id;
  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;

  @override
  List<Object?> get props => [id, name, type, phone, email, description, address];
}

class AccountDeleted extends AccountsEvent {
  const AccountDeleted(this.accountId);

  final int accountId;

  @override
  List<Object?> get props => [accountId];
}

class MoneyStatementsRequested extends AccountsEvent {
  const MoneyStatementsRequested({
    required this.accountId,
    required this.currency,
  });

  final int accountId;
  final String currency;

  @override
  List<Object?> get props => [accountId, currency];
}

class AccountMetalsRequested extends AccountsEvent {
  const AccountMetalsRequested(this.accountId);

  final int accountId;

  @override
  List<Object?> get props => [accountId];
}

class ItemStatementsRequested extends AccountsEvent {
  const ItemStatementsRequested({
    required this.accountId,
    required this.itemId,
  });

  final int accountId;
  final int itemId;

  @override
  List<Object?> get props => [accountId, itemId];
}
