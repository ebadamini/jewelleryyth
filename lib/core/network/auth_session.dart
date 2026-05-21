import '../storage/secure_token_storage.dart';

class AuthSession {
  AuthSession({
    required SecureTokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage;

  final SecureTokenStorage _tokenStorage;

  Future<String?> getAccessToken() {
    return _tokenStorage.readAccessToken();
  }

  Future<int?> getTenantId() {
    return _tokenStorage.readTenantId();
  }

  Future<bool> hasSession() {
    return _tokenStorage.hasSession();
  }

  Future<void> clear() {
    return _tokenStorage.clearAll();
  }
}
