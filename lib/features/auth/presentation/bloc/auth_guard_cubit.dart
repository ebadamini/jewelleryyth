import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/check_auth_session_use_case.dart';

part 'auth_guard_state.dart';

class AuthGuardCubit extends Cubit<AuthGuardState> {
  AuthGuardCubit({
    required CheckAuthSessionUseCase checkAuthSessionUseCase,
  })  : _checkAuthSessionUseCase = checkAuthSessionUseCase,
        super(const AuthGuardState.loading());

  final CheckAuthSessionUseCase _checkAuthSessionUseCase;

  Future<void> checkSession() async {
    emit(const AuthGuardState.loading());

    try {
      final hasSession = await _checkAuthSessionUseCase();
      if (hasSession) {
        emit(const AuthGuardState.authenticated());
      } else {
        emit(const AuthGuardState.unauthenticated());
      }
    } catch (_) {
      emit(const AuthGuardState.unauthenticated());
    }
  }
}
