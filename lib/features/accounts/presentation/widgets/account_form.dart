import 'package:flutter/material.dart';

import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/dropdowns/app_dropdown.dart';
import '../../../../shared/components/inputs/app_text_field.dart';
import '../../domain/entities/account_entity.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    super.key,
    this.initialName = '',
    this.initialType = AccountType.customer,
    this.initialPhone = '',
    this.initialEmail = '',
    this.initialDescription = '',
    this.initialAddress = '',
    required this.submitLabel,
    required this.onSubmit,
    this.isLoading = false,
  });

  final String initialName;
  final AccountType initialType;
  final String initialPhone;
  final String initialEmail;
  final String initialDescription;
  final String initialAddress;
  final String submitLabel;
  final bool isLoading;
  final void Function({
  required String name,
  required AccountType type,
  required String phone,
  required String email,
  required String description,
  required String address,
  }) onSubmit;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late AccountType _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _emailController = TextEditingController(text: widget.initialEmail);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _addressController = TextEditingController(text: widget.initialAddress);
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _nameController,
            labelText: 'Account Name',
            prefixIcon: const Icon(Icons.person_outline),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          AppDropdown<AccountType>(
            label: 'Account Type',
            value: _selectedType,
            prefixIcon: const Icon(Icons.category_outlined),
            items: AccountType.values
                .map((e) => AppDropdownItem(value: e, label: e.label))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _phoneController,
            labelText: 'Phone',
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _emailController,
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (_requiredValidator(value) != null) return 'Required';
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!emailRegex.hasMatch(value!.trim())) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _addressController,
            labelText: 'Address',
            prefixIcon: const Icon(Icons.location_on_outlined),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _descriptionController,
            labelText: 'Description',
            prefixIcon: const Icon(Icons.notes_outlined),
            maxLines: 3,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: widget.submitLabel,
            isLoading: widget.isLoading,
            onPressed: () {
              if (!(_formKey.currentState?.validate() ?? false)) return;
              widget.onSubmit(
                name: _nameController.text.trim(),
                type: _selectedType,
                phone: _phoneController.text.trim(),
                email: _emailController.text.trim(),
                description: _descriptionController.text.trim(),
                address: _addressController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }
}
