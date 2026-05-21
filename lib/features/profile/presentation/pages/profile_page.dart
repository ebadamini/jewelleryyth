import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelleryyth/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/components/avatar/app_avatar.dart';
import '../../../../shared/components/buttons/app_primary_action_button.dart';
import '../../../../shared/components/cards/app_card.dart';
import '../../../../shared/components/dialogs/app_confirmation_dialog.dart';
import '../../../../shared/components/dialogs/app_message_box.dart';
import '../../../../shared/components/inputs/app_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController(text: 'Admin User');
  final _emailController = TextEditingController(text: 'admin@example.com');
  final _photoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  void _logout() {
    AppConfirmationDialog.show(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmLabel: 'Logout',
      onConfirm: () {
        context.read<AuthBloc>().add(const LogoutRequested());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              children: [
                AppAvatar(
                  imageUrl: _photoController.text.isEmpty ? null : _photoController.text,
                  initials: 'AU',
                  radius: 34,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _photoController,
                  labelText: 'Photo URL',
                ),
                const SizedBox(height: 16),
                AppPrimaryActionButton(
                  label: 'Save Profile',
                  onPressed: () {
                    setState(() {});
                    AppMessageBox.show(
                      context,
                      message: 'Profile updated successfully.',
                      type: AppMessageType.success,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppPrimaryActionButton(
                  label: 'Logout',
                  onPressed: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
