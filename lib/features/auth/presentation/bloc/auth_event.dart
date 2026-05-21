part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthModeChanged extends AuthEvent {
  const AuthModeChanged(this.mode);

  final AuthMode mode;

  @override
  List<Object?> get props => [mode];
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignupSubmitted extends AuthEvent {
  const SignupSubmitted({
    required this.tenantName,
    required this.tenantCode,
    required this.adminEmail,
    required this.adminPassword,
    required this.adminFullName,
  });

  final String tenantName;
  final String tenantCode;
  final String adminEmail;
  final String adminPassword;
  final String adminFullName;

  @override
  List<Object?> get props => [
    tenantName,
    tenantCode,
    adminEmail,
    adminPassword,
    adminFullName,
  ];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
