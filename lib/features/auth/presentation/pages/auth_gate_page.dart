import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../bloc/auth_guard_cubit.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthGuardCubit>().checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthGuardCubit, AuthGuardState>(
      listener: (context, state) {
        if (state.status == AuthGuardStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(AppRouter.dashboardRoute);
        }

        if (state.status == AuthGuardStatus.unauthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
