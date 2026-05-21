

import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
import 'package:jewelleryyth/features/users/domain/repositories/users_repository.dart';

class DeleteUserUseCase {
  const DeleteUserUseCase(this._repository);

  final UsersRepository _repository;

  Future<UsersEntity> call(int id) => _repository.deleteUser(id);
}