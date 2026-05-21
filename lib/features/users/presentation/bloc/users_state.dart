
import 'package:equatable/equatable.dart';
import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';

enum UsersStatus { initial, loading, success, failure}

class UsersState extends Equatable{
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.filteredUsers = const [],
    this.selectedUser,
    this.searchQuery = '',
    this.errorMessage,
    this.lastActionSuccess = false,
});

  final UsersStatus status;
  final List<UsersEntity> users;
  final List<UsersEntity> filteredUsers;
  final UsersEntity? selectedUser;
  final String searchQuery;
  final String? errorMessage;
  final bool lastActionSuccess;

  UsersState copyWith({
    UsersStatus? status,
    List<UsersEntity>? users,
    List<UsersEntity>? filteredUsers,
    UsersEntity? selectedUser,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
    bool? lastActionSuccess,
}) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      selectedUser: selectedUser ?? this.selectedUser,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastActionSuccess: lastActionSuccess ?? this.lastActionSuccess,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    filteredUsers,
    selectedUser,
    searchQuery,
    errorMessage,
    lastActionSuccess,
  ];
}