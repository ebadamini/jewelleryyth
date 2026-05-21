

import 'package:equatable/equatable.dart';

class UsersEntity  extends Equatable{


  final int id;
  final String fullName;
  final String email;
  final bool active;
  final String createdAt;


  const UsersEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.active,
    required this.createdAt,
});

  @override
  List<Object?> get props => [id, fullName, email, active, createdAt];
}