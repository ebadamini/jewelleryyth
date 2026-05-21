

import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
import 'package:jewelleryyth/features/users/domain/repositories/users_repository.dart';

class UpdateUserUseCase {
  const UpdateUserUseCase(this._repository);
  final UsersRepository _repository;

  Future<UsersEntity> call({
    required int id,
    required String fullName,
    required bool active,
    required String email,
    required String password,
}){
    return _repository.updateUser(
        id: id,
        fullName: fullName,
        active: active,
        email: email,
        password: password,
    );
  }
}