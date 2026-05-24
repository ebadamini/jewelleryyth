import 'package:flutter/material.dart';
import '../models/form_field_config.dart';
import 'fields/simple_dropdown_field.dart';
import 'fields/searchable_dropdown_field.dart';

class FormFieldBuilderForm extends StatelessWidget {
  final FormFieldConfig config;
  final dynamic initialValue;
  final ValueChanged<dynamic>? onChanged;
  final FormFieldSetter<dynamic>? onSaved;

  const FormFieldBuilderForm({
    super.key,
    required this.config,
    this.initialValue,
    this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    switch (config.type) {
      case FieldType.simpleDropdown:
        return SimpleDropdownField(
          config: config,
          items: config.staticItems ?? [],
          initialValue: initialValue,
          onChanged: onChanged,
          onSaved: onSaved,
        );

      case FieldType.searchableDropdown:
        return SearchableDropdownField(
          config: config,
          initialItems: config.staticItems,
          initialValue: initialValue,
          onChanged: onChanged,
          onSaved: onSaved,
        );

      case FieldType.text:
        return TextFormField(
          initialValue: initialValue?.toString(),
          onChanged: onChanged,
          onSaved: onSaved,
          decoration: InputDecoration(
            labelText: config.labelKey,
            hintText: config.hint,
            border: const OutlineInputBorder(),
          ),
          validator: config.isRequired
              ? (v) => v == null || v.isEmpty ? 'این فیلد الزامی است' : null
              : null,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}