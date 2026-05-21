import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jewelleryyth/core/network/auth_session.dart';
import 'package:jewelleryyth/features/auth/domain/usecases/check_auth_session_use_case.dart';
import 'package:jewelleryyth/features/auth/domain/usecases/logout_use_case.dart';
import 'package:jewelleryyth/features/auth/presentation/bloc/auth_guard_cubit.dart';

import '../core/network/api_client.dart';
import '../core/storage/secure_token_storage.dart';
import '../features/accounts/data/datasources/accounts_remote_data_source.dart';
import '../features/accounts/data/repositories/accounts_repository_impl.dart';
import '../features/accounts/domain/usecases/create_account_use_case.dart';
import '../features/accounts/domain/usecases/delete_account_use_case.dart';
import '../features/accounts/domain/usecases/get_account_by_id_use_case.dart';
import '../features/accounts/domain/usecases/get_account_metals_use_case.dart';
import '../features/accounts/domain/usecases/get_accounts_use_case.dart';
import '../features/accounts/domain/usecases/get_item_statements_use_case.dart';
import '../features/accounts/domain/usecases/get_money_statements_use_case.dart';
import '../features/accounts/domain/usecases/update_account_use_case.dart';
import '../features/accounts/presentation/bloc/accounts_bloc.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/login_use_case.dart';
import '../features/auth/domain/usecases/signup_use_case.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import 'localization/app_localizations.dart';
import 'localization/locale_cubit.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class GoldWorkshopAdminApp extends StatelessWidget {
  const GoldWorkshopAdminApp({super.key});

  @override
  Widget build(BuildContext context) {



    final tokenStorage = SecureTokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);

    // Check Authentication
    final authSession = AuthSession(tokenStorage: tokenStorage);
    final checkAuthSessionUseCase = CheckAuthSessionUseCase(authSession);


    final authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSource(apiClient: apiClient),
      tokenStorage: tokenStorage,
    );

    final accountsRepository = AccountsRepositoryImpl(
      remoteDataSource: AccountsRemoteDataSource(apiClient: apiClient),
    );


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(
            create: (_) => AuthGuardCubit(
                checkAuthSessionUseCase: checkAuthSessionUseCase,
            ),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            signupUseCase: SignupUseCase(authRepository), 
            logoutUseCase: LogoutUseCase(authRepository),
          ),
        ),
        BlocProvider(
          create: (_) => AccountsBloc(
            getAccountsUseCase: GetAccountsUseCase(accountsRepository),
            getAccountByIdUseCase: GetAccountByIdUseCase(accountsRepository),
            createAccountUseCase: CreateAccountUseCase(accountsRepository),
            updateAccountUseCase: UpdateAccountUseCase(accountsRepository),
            deleteAccountUseCase: DeleteAccountUseCase(accountsRepository),
            getMoneyStatementsUseCase: GetMoneyStatementsUseCase(accountsRepository),
            getAccountMetalsUseCase: GetAccountMetalsUseCase(accountsRepository),
            getItemStatementsUseCase: GetItemStatementsUseCase(accountsRepository),
          ),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Gold Workshop Admin',
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.authGateRoute,
            theme: AppTheme.light(),
          );
        },
      ),
    );
  }
}
