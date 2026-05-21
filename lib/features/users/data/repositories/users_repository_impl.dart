

import 'package:jewelleryyth/features/users/data/datasources/user_remote_data_source.dart';
import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
import 'package:jewelleryyth/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository{

  const UsersRepositoryImpl({
    required UsersRemoteDataSource remoteDataSource,
}) : _remoteDataSource = remoteDataSource;

  final UsersRemoteDataSource _remoteDataSource;


  @override
  Future<UsersEntity> createUser({required String email, required String password, required String fullName, required String role}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<List<UsersEntity>> getUsers()async {

    final response = await _remoteDataSource.getUsers();
    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<UsersEntity>> getUserById(int id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<UsersEntity> updateUser({required int id, required String fullName, required bool active, required String email, required String password}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<UsersEntity> deleteUser(int id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

}