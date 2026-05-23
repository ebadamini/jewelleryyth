import 'package:flutter/material.dart';
import 'package:jewelleryyth/app/theme/app_theme.dart';
import '../controllers/table_controller.dart';

class TablePagination<T> extends StatelessWidget {
  final TableController<T> controller;

  const TablePagination({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final total = controller.totalPages;
        final current = controller.currentPage;
        if (total <= 1) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration:  BoxDecoration(
            color: AppTheme.primaryGold.withValues(alpha: 0.8),  // ← اینجا هم
            border: Border(top: BorderSide(color: Color(0xFFEAECEF))),
          ),
          child: Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PageButton(
                icon: isRtl ? Icons.chevron_right : Icons.chevron_left,
                onPressed:
                current > 1 ? () => controller.goToPage(current - 1) : null,
              ),
              const SizedBox(width: 12),
              Text(
                isRtl ? 'صفحه $current از $total' : 'Page $current of $total',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              _PageButton(
                icon: isRtl ? Icons.chevron_left : Icons.chevron_right,
                onPressed: current < total
                    ? () => controller.goToPage(current + 1)
                    : null,
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 70,
                height: 25,
                child: DropdownButtonFormField<int>(
                  initialValue: controller.rowsPerPage,
                  isExpanded: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                    ),
                  ),
                  items: [5, 10, 20, 50, 100].map((e) {
                    return DropdownMenuItem(value: e, child: Text('$e', style: TextStyle(fontSize: 12),),);
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) controller.setRowsPerPage(v);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _PageButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null
          ? const Color(0xFFF2F4F7)
          : const Color(0xFFF2F4F7),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: onPressed != null
                ? const Color(0xFF344054)
                : const Color(0xFFD0D5DD),
          ),
        ),
      ),
    );
  }
}