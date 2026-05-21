import 'package:flutter/material.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/auth_screen.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(initialMode: AuthMode.signup);
  }
}
