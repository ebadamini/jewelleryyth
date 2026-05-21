import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../dtos/auth_response_dto.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/signup_request_dto.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthResponseDto> login(LoginRequestDto request) async {
    final response = await _apiClient.post(
      endpoint: Endpoints.login,
      body: request.toJson(),
    );

    return AuthResponseDto.fromJson(response);
  }

  Future<AuthResponseDto> signup(SignupRequestDto request) async {
    final response = await _apiClient.post(
      endpoint: Endpoints.signup,
      body: request.toJson(),
    );

    return AuthResponseDto.fromJson(response);
  }

  Future<void> logout({
    required String accessToken,
  }) async {
    await _apiClient.post(
      endpoint: Endpoints.logout,
      body: const {},
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
}
