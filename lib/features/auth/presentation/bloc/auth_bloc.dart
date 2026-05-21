import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthState()) {
    on<AuthModeChanged>(_onAuthModeChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;

  void _onAuthModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        mode: event.mode,
        status: AuthStatus.initial,
        errorMessage: null,
        clearUser: true,
      ),
    );
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));

    try {
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
      );

      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Login failed.'));
    }
  }

  Future<void> _onSignupSubmitted(SignupSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));

    try {
      final user = await _signupUseCase(
        tenantName: event.tenantName,
        tenantCode: event.tenantCode,
        adminEmail: event.adminEmail,
        adminPassword: event.adminPassword,
        adminFullName: event.adminFullName,
      );

      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Signup failed.'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));

    try {
      await _logoutUseCase();
      emit(
        state.copyWith(
          status: AuthStatus.loggedOut,
          clearUser: true,
          errorMessage: null,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Logout failed.'));
    }
  }
}