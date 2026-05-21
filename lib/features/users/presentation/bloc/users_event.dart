
import 'package:equatable/equatable.dart';
import 'package:jewelleryyth/features/users/presentation/bloc/users_state.dart';

sealed class UsersEvent extends Equatable{
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class UsersRequested extends UsersEvent{
  const UsersRequested();
}

class UsersSearchChanged  extends UsersEvent{
  const UsersSearchChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}


class UsersDetailsRequested extends UsersEvent{
  const UsersDetailsRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}


class UsersCreated extends UsersEvent{
  const UsersCreated({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
});

  final String email;
  final String password;
  final String fullName;
  final String role;

  @override
  List<Object?> get props => [email, password, fullName, role];
}

class UsersUpdated extends UsersEvent{
  const UsersUpdated({
    required this.id,
    required this.fullName,
    required this.active,
    required this.email,
    required this.password,
});

  final int id;
  final String fullName;
  final bool active;
  final String email;
  final String password;

  @override
  List<Object?> get props => [id, fullName, active, email, password];
}

class UserDeleted extends UsersEvent{
  const UserDeleted(this.id);

  final int id;
  @override
  List<Object?> get props => [id];
}

