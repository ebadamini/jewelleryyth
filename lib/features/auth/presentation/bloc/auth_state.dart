part of 'auth_bloc.dart';

enum AuthMode { login, signup }
enum AuthStatus { initial, submitting, success, failure, loggedOut }

class AuthState extends Equatable {
  const AuthState({
    this.mode = AuthMode.login,
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthMode mode;
  final AuthStatus status;
  final AuthUserEntity? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthMode? mode,
    AuthStatus? status,
    AuthUserEntity? user,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [mode, status, user, errorMessage];
}
