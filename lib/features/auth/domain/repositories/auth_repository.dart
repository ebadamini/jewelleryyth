import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthUserEntity> login({
    required String email,
    required String password,
  });

  Future<AuthUserEntity> signup({
    required String tenantName,
    required String tenantCode,
    required String adminEmail,
    required String adminPassword,
    required String adminFullName,
  });

  Future<void> logout();
}
