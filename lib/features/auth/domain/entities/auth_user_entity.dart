import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  const AuthUserEntity({
    required this.token,
    required this.tenantId,
  });

  final String token;
  final int tenantId;

  @override
  List<Object?> get props => [token, tenantId];
}
