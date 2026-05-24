
import 'package:flutter/material.dart';
import '../models/form_field_config.dart';
import 'form_field_builder.dart';

class ReusableForm extends StatefulWidget {
  final List<FormFieldConfig> fields;
  final Map<String, dynamic>? initialData;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final VoidCallback? onSubmit;
  final GlobalKey<FormState>? formKey;

  const ReusableForm({
    super.key,
    required this.fields,
    this.initialData,
    this.onChanged,
    this.onSubmit,
    this.formKey,
  });

  @override
  State<ReusableForm> createState() => _ReusableFormState();
}

class _ReusableFormState extends State<ReusableForm> {
  late final Map<String, dynamic> _formData;
  final _internalKey = GlobalKey<FormState>();

  GlobalKey<FormState> get _effectiveKey => widget.formKey ?? _internalKey;

  @override
  void initState() {
    super.initState();
    _formData = Map.from(widget.initialData ?? {});
  }

  void _updateField(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
    widget.onChanged?.call(Map.from(_formData));
  }

  void _submit() {
    if (_effectiveKey.currentState?.validate() ?? false) {
      _effectiveKey.currentState?.save();
      widget.onSubmit?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _effectiveKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.fields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FormFieldBuilderForm(
                config: field,
                initialValue: _formData[field.key],
                onChanged: (value) => _updateField(field.key, value),
                onSaved: (value) => _formData[field.key] = value,
              ),
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('ذخیره'),
            ),
          ),
        ],
      ),
    );
  }
}
