//
//
// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:jewelleryyth/features/users/domain/entities/users_entity.dart';
// import 'package:jewelleryyth/features/users/domain/usecases/create_user_use_case.dart';
// import 'package:jewelleryyth/features/users/domain/usecases/delete_user_use_case.dart';
// import 'package:jewelleryyth/features/users/domain/usecases/get_user_by_id_use_case.dart';
// import 'package:jewelleryyth/features/users/domain/usecases/get_users_use_case.dart';
// import 'package:jewelleryyth/features/users/domain/usecases/update_user_use_case.dart';
// import 'package:jewelleryyth/features/users/presentation/bloc/users_event.dart';
// import 'package:jewelleryyth/features/users/presentation/bloc/users_state.dart';
//
// class UsersBloc extends Bloc<UsersEvent, UsersState>{
//   UsersBloc({
//       required GetUsersUseCase getUsersUseCase,
//     required GetUserByIdUseCase getUsersByIdUseCase,
//     required CreateUserUseCase createUserUseCase,
//     required UpdateUserUseCase updateUserUseCase,
//     required DeleteUserUseCase deleteUserUseCase,
// }) : _getUsersUseCase = getUsersUseCase,
//         _getUserByIdUseCase = getUsersByIdUseCase,
//   _createUserUseCase = createUserUseCase,
//   _updateUserUseCase = updateUserUseCase,
//   _deleteUserUseCase = deleteUserUseCase,
//   super(const UsersState()){
//     on<UsersRequested>(_onUsersRequested);
//     on<UsersSearchChanged>(_onUsersSearchChanged);
//     on<UsersDetailsRequested>(_onUsersDetailsRequested);
//     on<UsersCreated>(_onUsersCreated);
//     on<UsersUpdated>(_onUsersUpdated);
//     on<UserDeleted>(_onUserDeleted);
//   }
//
//   final GetUsersUseCase _getUsersUseCase;
//   final GetUserByIdUseCase _getUserByIdUseCase;
//   final CreateUserUseCase _createUserUseCase;
//   final UpdateUserUseCase _updateUserUseCase;
//   final DeleteUserUseCase _deleteUserUseCase;
//
//   Future<void> _onUsersRequested(
//       UsersRequested event,
//       Emitter<UsersState> emit) async {
//     emit(state.copyWith(status: UsersStatus.loading, clearError : false, lastActionSuccess : false));
//     try{
//       final users = await _getUsersUseCase();
//       emit(state.copyWith(
//         status: UsersStatus.success,
//         users: users,
//         filteredUsers: _applySearch(users, state.searchQuery),
//       ));
//     }catch(e){
//       emit(state.copyWith(status: UsersStatus.failure, errorMessage: e.toString()));
//     }
//   }
//
//   void _onUsersSearchChanged(
//       UsersSearchChanged event,
//       Emitter<UsersState> emit,
//       ){
//     emit(state.copyWith(
//       searchQuery: event.query,
//       filteredUsers: _applySearch(state.users, event.query),
//     ));
//   }
//
//
//   Future<void> _onUsersDetailsRequested(
//       UsersDetailsRequested event,
//       Emitter<UsersState> emit,
//       ) async{
//     emit(state.copyWith(
//       status:UsersStatus.loading, clearError: true
//     ));
//     try{
//       final user = await _getUserByIdUseCase(event.id);
//       emit(state.copyWith(status: UsersStatus.success, selectedUser: user));
//     }catch(e){
//       emit(state.copyWith(status: UsersStatus.failure, errorMessage: e.toString()));
//     }
//   }
//
//
//   Future<void> _onUsersCreated(
//       UsersCreated event,
//       Emitter<UsersState> emit,
//       )async{
//     emit(state.copyWith(status: UsersStatus.loading, clearError: true, lastActionSuccess: false));
//     try{
//       final user = await _createUserUseCase(
//         fullName: event.fullName,
//         email: event.email,
//         password: event.password,
//         role: event.role,
//       );
//       emit(state.copyWith(
//         status: UsersStatus.success,
//         selectedUser: user,
//         lastActionSuccess: true,
//       ));
//       add(const UsersRequested());
//     }catch(e){
//       emit(state.copyWith(status: UsersStatus.failure, errorMessage: e.toString()));
//     }
//   }
//
//
//
//   List<UsersEntity> _applySearch(List<UsersEntity> users, String query){
//     final q = query.trim().toLowerCase();
//     if(q.isEmpty) return users;
//     return users.where((user){
//       return user.fullName.toLowerCase().contains(q) ||
//       user.email.toLowerCase().contains(q);
//     }).toList();
//   }
// }