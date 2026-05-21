import 'package:flutter/material.dart';

import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/inputs/app_text_field.dart';

class AccountsFilterBar extends StatelessWidget {
  const AccountsFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onCreatePressed,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AppTextField(
            controller: searchController,
            labelText: 'Search Accounts',
            hintText: 'Search by name, phone, email, address',
            prefixIcon: const Icon(Icons.search),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: AppButton(
            label: 'Create Account',
            icon: const Icon(Icons.add),
            onPressed: onCreatePressed,
          ),
        ),
      ],
    );
  }
}
