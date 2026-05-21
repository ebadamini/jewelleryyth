


import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';

class UserResponseDto {
  const UserResponseDto({
    required this.id,
    required this.email,
    required this.fullName,
    required this.active,
    required this.createdAt,
});


  final int id;
  final String email;
  final String fullName;
  final bool active;
  final String createdAt;


  factory UserResponseDto.fromJson(Map<String,dynamic> json){
    return UserResponseDto(
        id: (json['id'] as num?)?.toInt() ?? 0,
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        active: json['active'] as bool? ?? true,
        createdAt: json['createdAt'] ?? '',
    );
  }

  UsersEntity toEntity(){
    return UsersEntity(
        id: id,
        fullName: fullName,
        email: email,
        active: active,
        createdAt: createdAt,
    );
  }
}