import 'package:flutter/cupertino.dart';

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

    debugPrint('== REPOSITORY: Trying to save token: ${response.token} =======');
    await _tokenStorage.saveAccessToken(response.token);
    debugPrint('=== REPOSITORY: Token saved. Verify: ${response.token}');
    await _tokenStorage.saveTenantId(response.tenantId);
    debugPrint('=== REPOSITORY: Tenant ID saved. Verify: ${response.tenantId}');

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
    await _tokenStorage.saveTenantId(response.tenantId);

    return response.toEntity();
  }

  @override
  Future<void> logout() async {
    final token = await _tokenStorage.readAccessToken();

    if (token != null && token.isNotEmpty) {
      try{
        await _remoteDataSource.logout(accessToken: token);
      }catch (e){
        debugPrint('Logout API call failed. (Ignoring): $e');
      }

      await _tokenStorage.clearAll();
    }

    await _tokenStorage.clearAll();
  }
}
