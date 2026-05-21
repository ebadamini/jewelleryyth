
import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
import 'package:jewelleryyth/features/users/domain/repositories/users_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);

  final UsersRepository _repository;

  Future<List<UsersEntity>> call() => _repository.getUsers();
}