
import 'package:flutter/cupertino.dart';
import 'package:jewelleryyth/core/network/api_client.dart';
import 'package:jewelleryyth/core/network/endpoints.dart';
import 'package:jewelleryyth/features/users/data/dtos/user_response_dto.dart';

class UsersRemoteDataSource {
  const UsersRemoteDataSource({
    required ApiClient apiClient,
}) : _apiClient = apiClient;


  final ApiClient _apiClient;

  Future<List<UserResponseDto>> getUsers() async{
    final response = await _apiClient.getList(endpoint: Endpoints.users);
    debugPrint('Users Endpoint =>  '+ Endpoints.users.toString());

    return response.map((e) => UserResponseDto.fromJson(e as Map<String, dynamic>)).toList();
  }


}