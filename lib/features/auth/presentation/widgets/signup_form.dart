import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/inputs/app_text_field.dart';
import '../bloc/auth_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _tenantNameController = TextEditingController();
  final _tenantCodeController = TextEditingController();
  final _adminFullNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _tenantNameController.dispose();
    _tenantCodeController.dispose();
    _adminFullNameController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = context.select(
          (AuthBloc bloc) => bloc.state.status == AuthStatus.submitting,
    );

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: widget.compact,
        physics: widget.compact ? const NeverScrollableScrollPhysics() : null,
        children: [
          AppTextField(
            controller: _tenantNameController,
            labelText: l10n.translate('tenantName'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _tenantCodeController,
            labelText: l10n.translate('tenantCode'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _adminFullNameController,
            labelText: l10n.translate('adminFullName'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _adminEmailController,
            labelText: l10n.translate('adminEmail'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (_requiredValidator(value) != null) {
                return l10n.translate('validationRequired');
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!emailRegex.hasMatch(value!.trim())) {
                return l10n.translate('validationInvalidEmail');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _adminPasswordController,
            labelText: l10n.translate('adminPassword'),
            obscureText: true,
            validator: (value) {
              if (_requiredValidator(value) != null) {
                return l10n.translate('validationRequired');
              }
              if (value!.trim().length < 8) {
                return l10n.translate('validationPasswordLength');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _confirmPasswordController,
            labelText: l10n.translate('confirmPassword'),
            obscureText: true,
            validator: (value) {
              if (_requiredValidator(value) != null) {
                return l10n.translate('validationRequired');
              }
              if (value!.trim() != _adminPasswordController.text.trim()) {
                return l10n.translate('validationPasswordsNotMatch');
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppButton(
            label: l10n.translate('signup'),
            isLoading: isLoading,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.read<AuthBloc>().add(
                  SignupSubmitted(
                    tenantName: _tenantNameController.text.trim(),
                    tenantCode: _tenantCodeController.text.trim(),
                    adminEmail: _adminEmailController.text.trim(),
                    adminPassword: _adminPasswordController.text.trim(),
                    adminFullName: _adminFullNameController.text.trim(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return l10n.translate('validationRequired');
    }
    return null;
  }
}
