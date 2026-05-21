import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUserEntity> call({
    required String tenantName,
    required String tenantCode,
    required String adminEmail,
    required String adminPassword,
    required String adminFullName,
  }) {
    return _repository.signup(
      tenantName: tenantName,
      tenantCode: tenantCode,
      adminEmail: adminEmail,
      adminPassword: adminPassword,
      adminFullName: adminFullName,
    );
  }
}
