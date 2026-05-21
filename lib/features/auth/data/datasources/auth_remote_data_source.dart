import 'package:dio/dio.dart';
import '../../../../core/network/endpoints.dart';
import '../dtos/auth_response_dto.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/signup_request_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> login(LoginRequestDto request);
  Future<AuthResponseDto> signup(SignupRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  Future<AuthResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post(
      Endpoints.login,
      data: request.toJson(),
    );

    return AuthResponseDto.fromJson(response.data);
  }

  @override
  Future<AuthResponseDto> signup(SignupRequestDto request) async {
    final response = await _dio.post(
      Endpoints.signup,
      data: request.toJson(),
    );

    return AuthResponseDto.fromJson(response.data);
  }
}