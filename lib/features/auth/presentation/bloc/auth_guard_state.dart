part of 'auth_guard_cubit.dart';

enum AuthGuardStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthGuardState extends Equatable {
  const AuthGuardState._({
    required this.status,
  });

  const AuthGuardState.loading() : this._(status: AuthGuardStatus.loading);

  const AuthGuardState.authenticated()
      : this._(status: AuthGuardStatus.authenticated);

  const AuthGuardState.unauthenticated()
      : this._(status: AuthGuardStatus.unauthenticated);

  final AuthGuardStatus status;

  @override
  List<Object?> get props => [status];
}
