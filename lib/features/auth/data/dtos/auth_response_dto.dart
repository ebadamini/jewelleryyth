import '../../domain/entities/auth_user_entity.dart';

class AuthResponseDto {
  const AuthResponseDto({
    required this.token,
    required this.tenantId,
  });

  final String token;
  final int tenantId;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token']?.toString() ?? '',
      tenantId: (json['tenantId'] as num?)?.toInt() ?? 0,
    );
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      token: token,
      tenantId: tenantId,
    );
  }
}
