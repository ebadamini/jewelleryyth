
import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
import 'package:jewelleryyth/features/users/domain/repositories/users_repository.dart';

class CreateUserUseCase {
  const CreateUserUseCase(this._repository);

  final UsersRepository _repository;

  Future<UsersEntity> call({
    required String email,
    required String password,
    required String fullName,
    required String role,
}){
    return _repository.createUser(
        email: email,
        password: password,
        fullName: fullName,
        role: role
    );
  }
}