import 'package:flutter/material.dart';
import 'package:jewelleryyth/app/shell/app_shell.dart';
import 'package:jewelleryyth/features/auth/presentation/pages/auth_gate_page.dart';
import 'package:jewelleryyth/features/dashboard/presentation/pages/dashboard_home_page.dart';

import '../../features/accounts/domain/entities/account_entity.dart';
import '../../features/accounts/domain/entities/metal_balance_entity.dart';
import '../../features/accounts/presentation/pages/account_details_page.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/accounts/presentation/pages/create_account_page.dart';
import '../../features/accounts/presentation/pages/edit_account_page.dart';
import '../../features/accounts/presentation/pages/item_statements_page.dart';
import '../../features/accounts/presentation/pages/money_satements_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';

class AppRouter {
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String authGateRoute = '/auth-gate';
  static const String accountsRoute = '/accounts';
  static const String accountDetailsRoute = '/accounts/details';
  static const String accountCreateRoute = '/accounts/create';
  static const String accountEditRoute = '/accounts/edit';
  static const String moneyStatementsRoute = '/accounts/money-statements';
  static const String itemStatementsRoute = '/accounts/item-statements';
  static const String dashboardRoute = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGateRoute:
        return MaterialPageRoute(builder: (_) => const AuthGatePage());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const AppShell());
      case accountsRoute:
        return MaterialPageRoute(builder: (_) => const AccountsPage());
      case accountCreateRoute:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case accountDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => AccountDetailsPage(accountId: settings.arguments as int),
        );
      case accountEditRoute:
        return MaterialPageRoute(
          builder: (_) => EditAccountPage(account: settings.arguments as AccountEntity),
        );
      case moneyStatementsRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MoneyStatementsPage(
            accountId: args['accountId'] as int,
            accountName: args['accountName'] as String,
            currency: args['currency'] as String,
          ),
        );
      case itemStatementsRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ItemStatementsPage(
            accountId: args['accountId'] as int,
            accountName: args['accountName'] as String,
            itemId: args['itemId'] as int,
            itemName: args['itemName'] as String,
            availableItems: args['availableItems'] as List<MetalBalanceEntity>,
          ),
        );
      case loginRoute:
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
