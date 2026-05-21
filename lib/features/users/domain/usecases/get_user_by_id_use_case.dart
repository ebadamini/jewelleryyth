

import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
import 'package:jewelleryyth/features/users/domain/repositories/users_repository.dart';

class GetUserByIdUseCase {
  const GetUserByIdUseCase(this._repository);

  final UsersRepository _repository;

  Future<List<UsersEntity>> call(int id) => _repository.getUserById(id);
}