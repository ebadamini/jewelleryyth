import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/inputs/app_text_field.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = context.select((AuthBloc bloc) => bloc.state.status == AuthStatus.submitting);

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: widget.compact,
        physics: widget.compact ? const NeverScrollableScrollPhysics() : null,
        children: [
          AppTextField(
            controller: _emailController,
            labelText: l10n.translate('email'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.translate('validationRequired');
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!emailRegex.hasMatch(value.trim())) {
                return l10n.translate('validationInvalidEmail');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            labelText: l10n.translate('password'),
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.translate('validationRequired');
              }
              if (value.trim().length < 4) {
                return l10n.translate('validationPasswordLength');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Checkbox(value: true, onChanged: null),
              Text(l10n.translate('rememberMe')),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(l10n.translate('forgotPassword')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.translate('login'),
            isLoading: isLoading,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.read<AuthBloc>().add(
                  LoginSubmitted(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
