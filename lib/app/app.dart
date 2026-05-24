import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jewelleryyth/app/shell/shell_cubit.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_customers_use_case.dart';
import 'package:jewelleryyth/features/auth/domain/usecases/check_auth_session_use_case.dart';
import 'package:jewelleryyth/features/auth/domain/usecases/logout_use_case.dart';
import 'package:jewelleryyth/features/auth/presentation/bloc/auth_guard_cubit.dart';
import 'package:jewelleryyth/features/auth/domain/usecases/login_use_case.dart';
import 'package:jewelleryyth/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jewelleryyth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jewelleryyth/features/accounts/presentation/bloc/accounts_bloc.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_accounts_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_account_by_id_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/create_account_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/update_account_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/delete_account_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_money_statements_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_account_metals_use_case.dart';
import 'package:jewelleryyth/features/accounts/domain/usecases/get_item_statements_use_case.dart';
import 'package:jewelleryyth/features/notifications/presentation/bloc/notifications_event.dart';
import '../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../injection_container.dart';
import 'localization/app_localizations.dart';
import 'localization/locale_cubit.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class GoldWorkshopAdminApp extends StatelessWidget {
  const GoldWorkshopAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => ShellCubit()),
        BlocProvider(
          create: (_) => AuthGuardCubit(
            checkAuthSessionUseCase: sl<CheckAuthSessionUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: sl<LoginUseCase>(),
            signupUseCase: sl<SignupUseCase>(),
            logoutUseCase: sl<LogoutUseCase>(),
          ),
        ),
        BlocProvider(
          lazy: true,  // ← فقط وقتی استفاده بشه ساخته می‌شه
          create: (_) => AccountsBloc(
            getAccountsUseCase: sl<GetAccountsUseCase>(),
            getAccountByIdUseCase: sl<GetAccountByIdUseCase>(),
            createAccountUseCase: sl<CreateAccountUseCase>(),
            updateAccountUseCase: sl<UpdateAccountUseCase>(),
            deleteAccountUseCase: sl<DeleteAccountUseCase>(),
            getMoneyStatementsUseCase: sl<GetMoneyStatementsUseCase>(),
            getAccountMetalsUseCase: sl<GetAccountMetalsUseCase>(),
            getItemStatementsUseCase: sl<GetItemStatementsUseCase>(),
            getCustomersUseCase: sl<GetCustomersUseCase>(),

          ),
        ),
        BlocProvider<NotificationsBloc>(create: (_) => sl<NotificationsBloc>()..add(const NotificationsLoaded())),
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