import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../dialogs/app_confirmation_dialog.dart';
import '../states/app_empty_state.dart';

class AppTableColumn<T> {
  const AppTableColumn({
    required this.title,
    required this.cellBuilder,
  });

  final String title;
  final Widget Function(T item) cellBuilder;
}

class AppTable<T> extends StatelessWidget {
  const AppTable({
    super.key,
    this.items = const [],
    this.columns = const [],
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
    this.emptyTitle = 'No data is available',
    this.mobileTitleBuilder,
    this.mobileSubtitleBuilder,
    this.mobileTrailingBuilder,
  });

  final List<T> items;
  final List<AppTableColumn<T>> columns;
  final void Function(T item)? onEdit;
  final void Function(T item)? onDelete;
  final void Function(T item)? onToggleActive;
  final String emptyTitle;
  final String Function(T item)? mobileTitleBuilder;
  final String Function(T item)? mobileSubtitleBuilder;
  final Widget Function(T item)? mobileTrailingBuilder;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    if (items.isEmpty) {
      return AppEmptyState(title: emptyTitle);
    }

    return isMobile ? _buildMobile(context) : _buildDesktop(context);
  }

  Widget _buildDesktop(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ...columns.map(
                    (column) => Expanded(
                  child: Text(
                    column.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 120),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
              (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0F2F5)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                ...columns.map((column) => Expanded(child: column.cellBuilder(item))),
                _ActionsCell<T>(
                  item: item,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onToggleActive: onToggleActive,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF0F2F5)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mobileTitleBuilder != null)
                Text(
                  mobileTitleBuilder!(item),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              if (mobileSubtitleBuilder != null) ...[
                const SizedBox(height: 6),
                Text(
                  mobileSubtitleBuilder!(item),
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
              if (mobileTrailingBuilder != null) ...[
                const SizedBox(height: 10),
                mobileTrailingBuilder!(item),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onToggleActive != null)
                    IconButton(
                      onPressed: () => onToggleActive!(item),
                      icon: const Icon(Icons.toggle_on_outlined),
                    ),
                  if (onEdit != null)
                    IconButton(
                      onPressed: () => onEdit!(item),
                      icon: const Icon(FontAwesomeIcons.penToSquare, size: 16),
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: () {
                        AppConfirmationDialog.show(
                          context,
                          title: 'Delete',
                          message: 'Are you sure you want to delete this item?',
                          onConfirm: () => onDelete!(item),
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.trash, size: 16),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ActionsCell<T> extends StatelessWidget {
  const _ActionsCell({
    required this.item,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  final T item;
  final void Function(T item)? onEdit;
  final void Function(T item)? onDelete;
  final void Function(T item)? onToggleActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onToggleActive != null)
          IconButton(
            onPressed: () => onToggleActive!(item),
            icon: const Icon(Icons.toggle_on_outlined),
          ),
        if (onEdit != null)
          IconButton(
            onPressed: () => onEdit!(item),
            icon: const Icon(FontAwesomeIcons.penToSquare, size: 16),
          ),
        if (onDelete != null)
          IconButton(
            onPressed: () {
              AppConfirmationDialog.show(
                context,
                title: 'Delete',
                message: 'Are you sure you want to delete this item?',
                onConfirm: () => onDelete!(item),
              );
            },
            icon: const Icon(FontAwesomeIcons.trash, size: 16),
          ),
      ],
    );
  }
}
