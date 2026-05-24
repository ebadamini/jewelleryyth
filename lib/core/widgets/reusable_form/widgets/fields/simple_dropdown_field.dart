import 'package:flutter/material.dart';
import 'package:jewelleryyth/app/localization/app_localizations.dart';
import '../../models/dropdown_item_model.dart';
import '../../models/form_field_config.dart';

class SimpleDropdownField extends StatelessWidget {
  final FormFieldConfig config;
  final List<DropdownItemModel> items;
  final dynamic initialValue; // DropdownItemModel یا List<<DropdownItemModel>
  final ValueChanged<dynamic>? onChanged;
  final FormFieldSetter<dynamic>? onSaved;
  final FormFieldValidator<dynamic>? validator;

  const SimpleDropdownField({
    super.key,
    required this.config,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (config.isMultiSelect) {
      return _buildMultiSelect(context);
    }
    final allItems = <DropdownItemModel>[
      if (config.placeholderItem != null) config.placeholderItem!,
      ...items,
    ];

    final effectiveValue = initialValue ?? config.placeholderItem;

    return DropdownButtonFormField<DropdownItemModel>(
      initialValue: _findMatchingItem(effectiveValue, allItems),
      decoration: InputDecoration(
        labelText: config.labelKey,
        hintText: config.hint,
        helperText: config.helperText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      selectedItemBuilder: (context) {
        return allItems.map((item) {
          final isPlaceholder =
              config.placeholderItem != null &&
              item.id == config.placeholderItem!.id;
          return Text(
            item.name,
            style: TextStyle(
              color: isPlaceholder ? Theme.of(context).hintColor : null,
              fontStyle: isPlaceholder ? FontStyle.italic : null,
            ),
          );
        }).toList();
      },
      items: items.map((item) {
        final isPlaceholder =
            config.placeholderItem != null &&
            item.id == config.placeholderItem!.id;

        return DropdownMenuItem<DropdownItemModel>(
          value: item,
          enabled: !isPlaceholder,
          child: Text(
            item.name,
            style: TextStyle(
              color: isPlaceholder ? Theme.of(context).hintColor : null,
              fontStyle: isPlaceholder ? FontStyle.italic : null,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null &&
            config.placeholderItem != null &&
            value.id == config.placeholderItem!.id) {
          return;
        }
        onChanged?.call(value);
      },
      onSaved: onSaved,
      validator: validator ?? _defaultValidator,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  DropdownItemModel? _findMatchingItem(
    dynamic value,
    List<DropdownItemModel> searchList,
  ) {
    if (value == null) return null;
    if (value is DropdownItemModel) {
      return searchList.firstWhere(
        (i) => i.id == value.id,
        orElse: () => value,
      );
    }
    return null;
  }

  String? _defaultValidator(dynamic value) {
    if (!config.isRequired) return null;

    // اگر placeholder انتخاب شده باشد (یا null باشد)، خطا بده
    if (value == null) return 'لطفاً یک گزینه انتخاب کنید';
    if (value is DropdownItemModel && config.placeholderItem != null) {
      if (value.id == config.placeholderItem!.id)
        return 'لطفاً یک گزینه انتخاب کنید';
    }
    return null;
  }

  Widget _buildMultiSelect(BuildContext context) {
    return FormField<List<DropdownItemModel>>(
      initialValue: (initialValue as List<DropdownItemModel>?) ?? [],
      validator: (value) {
        if (config.isRequired && (value == null || value.isEmpty)) {
          return 'حداقل یک گزینه باید انتخاب شود';
        }
        return null;
      },
      builder: (fieldState) {
        final selected = fieldState.value ?? [];
        return InputDecorator(
          decoration: InputDecoration(
            labelText: config.labelKey,
            errorText: fieldState.errorText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...selected.map(
                (item) => Chip(
                  label: Text(item.name),
                  onDeleted: () {
                    final updated = List<DropdownItemModel>.from(selected)
                      ..remove(item);
                    fieldState.didChange(updated);
                    onChanged?.call(updated);
                  },
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('افزودن'),
                onPressed: () async {
                  final result = await showDialog<List<DropdownItemModel>>(
                    context: context,
                    builder: (ctx) => _SimpleMultiSelectDialog(
                      items: items,
                      selected: selected,
                    ),
                  );
                  if (result != null) {
                    fieldState.didChange(result);
                    onChanged?.call(result);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Multi-Select Dialog (بدون تغییر) ───
class _SimpleMultiSelectDialog extends StatefulWidget {
  final List<DropdownItemModel> items;
  final List<DropdownItemModel> selected;

  const _SimpleMultiSelectDialog({required this.items, required this.selected});

  @override
  State<_SimpleMultiSelectDialog> createState() =>
      _SimpleMultiSelectDialogState();
}

class _SimpleMultiSelectDialogState extends State<_SimpleMultiSelectDialog> {
  late List<DropdownItemModel> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('انتخاب کنید'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (ctx, i) {
            final item = widget.items[i];
            final isSelected = _selected.any((s) => s.id == item.id);
            return CheckboxListTile(
              value: isSelected,
              title: Text(item.name),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selected.add(item);
                  } else {
                    _selected.removeWhere((s) => s.id == item.id);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selected),
          child: const Text('تأیید'),
        ),
      ],
    );
  }
}
