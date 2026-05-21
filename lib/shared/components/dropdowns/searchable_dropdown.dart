import 'package:flutter/material.dart';

import 'app_dropdown.dart';

class AppSearchableDropdown<T> extends StatefulWidget {
  const AppSearchableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.prefixIcon,
  });

  final String label;
  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final Widget? prefixIcon;

  @override
  State<AppSearchableDropdown<T>> createState() => _AppSearchableDropdownState<T>();
}

class _AppSearchableDropdownState<T> extends State<AppSearchableDropdown<T>> {
  Future<void> _openPicker() async {
    final searchController = TextEditingController();
    var filtered = List<AppDropdownItem<T>>.from(widget.items);

    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setSheetState(() {
                          final query = value.trim().toLowerCase();
                          filtered = widget.items.where((item) {
                            return item.label.toLowerCase().contains(query);
                          }).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            title: Text(item.label),
                            onTap: () => Navigator.of(context).pop(item.value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.cast<AppDropdownItem<T>?>().firstWhere(
          (item) => item?.value == widget.value,
      orElse: () => null,
    );

    return InkWell(
      onTap: _openPicker,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.prefixIcon,
        ),
        child: Text(selectedItem?.label ?? ''),
      ),
    );
  }
}
