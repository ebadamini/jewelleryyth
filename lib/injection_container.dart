import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_customers_use_case.dart';
import 'package:jewelleryyth/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'core/network/auth_session.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_token_storage.dart';
import 'features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'features/accounts/data/repositories/accounts_repository_impl.dart';
import 'features/accounts/domain/repositories/accounts_repository.dart';
import 'features/accounts/domain/usecases/create_account_use_case.dart';
import 'features/accounts/domain/usecases/delete_account_use_case.dart';
import 'features/accounts/domain/usecases/get_account_by_id_use_case.dart';
import 'features/accounts/domain/usecases/get_account_metals_use_case.dart';
import 'features/accounts/domain/usecases/get_accounts_use_case.dart';
import 'features/accounts/domain/usecases/get_item_statements_use_case.dart';
import 'features/accounts/domain/usecases/get_money_statements_use_case.dart';
import 'features/accounts/domain/usecases/update_account_use_case.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_session_use_case.dart';
import 'features/auth/domain/usecases/login_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/signup_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => SecureTokenStorage());

  // Dio
  sl.registerLazySingleton(() {
    final dioClient = DioClient(tokenStorage: sl<SecureTokenStorage>());
    return dioClient.dio;
  });

  // Auth Session
  sl.registerLazySingleton(() => AuthSession(tokenStorage: sl()));

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AccountsRemoteDataSource>(
    () => AccountsRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );
  sl.registerLazySingleton<AccountsRepository>(
    () => AccountsRepositoryImpl(remoteDataSource: sl()),
  );

  // Notification
  sl.registerFactory(() => NotificationsBloc());

  // UseCases - Auth
  sl.registerLazySingleton(() => CheckAuthSessionUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // UseCases - Accounts
  sl.registerLazySingleton(() => GetAccountsUseCase(sl()));
  sl.registerLazySingleton(() => GetAccountByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateAccountUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAccountUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(() => GetMoneyStatementsUseCase(sl()));
  sl.registerLazySingleton(() => GetAccountMetalsUseCase(sl()));
  sl.registerLazySingleton(() => GetItemStatementsUseCase(sl()));
  sl.registerLazySingleton(() => GetCustomersUseCase(sl()));
}
