
import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';

abstract class UsersRepository {
  Future<List<UsersEntity>> getUsers();

  Future<UsersEntity> createUser({
    required String email,
    required String password,
    required String fullName,
    required String role,
});


  Future<UsersEntity> updateUser({
    required int id,
    required String fullName,
    required bool active,
    required String email,
    required String password,
});


  Future<List<UsersEntity>> getUserById(int id);

  Future<UsersEntity> deleteUser(int id);
}