import '../../../../core/storage/secure_token_storage.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/signup_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureTokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureTokenStorage _tokenStorage;

  @override
  Future<AuthUserEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      LoginRequestDto(email: email, password: password),
    );

    await _tokenStorage.saveAccessToken(response.token);
    if (response.tenantId != null) {
      await _tokenStorage.saveTenantId(response.tenantId!);
    }

    return response.toEntity();
  }

  @override
  Future<AuthUserEntity> signup({
    required String tenantName,
    required String tenantCode,
    required String adminEmail,
    required String adminPassword,
    required String adminFullName,
  }) async {
    final response = await _remoteDataSource.signup(
      SignupRequestDto(
        tenantName: tenantName,
        tenantCode: tenantCode,
        adminEmail: adminEmail,
        adminPassword: adminPassword,
        adminFullName: adminFullName,
      ),
    );

    await _tokenStorage.saveAccessToken(response.token);
    if (response.tenantId != null) {
      await _tokenStorage.saveTenantId(response.tenantId!);
    }

    return response.toEntity();
  }

  @override
  Future<void> logout() async {
    // No API call - just clear local tokens
    await _tokenStorage.clearAll();
  }

  @override
  Future<bool> checkAuthSession() async {
    return await _tokenStorage.hasSession();
  }
}