import '../../../../core/network/auth_session.dart';

class CheckAuthSessionUseCase {
  const CheckAuthSessionUseCase(this._authSession);

  final AuthSession _authSession;

  Future<bool> call() {
    return _authSession.hasSession();
  }
}
