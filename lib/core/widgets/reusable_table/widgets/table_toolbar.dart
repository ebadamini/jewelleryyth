import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations.dart';
import '../controllers/table_controller.dart';
import '../services/table_export_service.dart';

class TableToolbar<T> extends StatelessWidget {
  final TableController<T> controller;
  final bool showSearch;
  final bool showDateFilter;
  final bool showExport;
  final String fileName;

  const TableToolbar({
    super.key,
    required this.controller,
    this.showSearch = true,
    this.showDateFilter = true,
    this.showExport = true,
    this.fileName = 'export',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    if (showSearch)
                      SizedBox(
                        width: 260,
                        height: 40,
                        child: TextField(
                          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                          onChanged: controller.search,
                          decoration: InputDecoration(
                            hintText: l10n.translate('tableSearchHint'),
                            hintTextDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                            prefixIcon: const Icon(Icons.search, size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    if (showDateFilter)
                      OutlinedButton.icon(
                        onPressed: () => _pickDateRange(context, isRtl, l10n),
                        icon: const Icon(Icons.date_range, size: 18),
                        label: Text(
                          controller.currentDateRange == null
                              ? l10n.translate('dateFilter')
                              : '${_fmt(controller.currentDateRange!.start)} - ${_fmt(controller.currentDateRange!.end)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF344054),
                          side: const BorderSide(color: Color(0xFFD0D5DD)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    if (controller.currentDateRange != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Color(0xFF667085)),
                        onPressed: controller.clearDateRange,
                        tooltip: l10n.translate('clearDateFilter'),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (showExport)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    _ExportButton(
                      icon: Icons.file_download_outlined,
                      label: 'Excel',
                      onPressed: () {
                        final headers = controller.columns
                        .map((c) => c.resolveTitle(l10n)).toList();

                        TableExportService.exportExcel<T>(
                          context: context,
                          fileName: fileName,
                          headers: headers,
                          columns: controller.columns,
                          items: controller.items,
                        );
                      }
                    ),
                    _ExportButton(
                      icon: Icons.picture_as_pdf_outlined,
                      label: 'PDF',
                      onPressed: () {
                        final headers = controller.columns
                        .map((c) => c.resolveTitle(l10n)).toList();

                        TableExportService.exportPdf<T>(
                          context: context,
                          fileName: fileName,
                          headers: headers,
                          columns: controller.columns,
                          items: controller.items,
                        );
                      }
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDateRange(BuildContext context, bool isRtl, AppLocalizations l10n) async {
    DateTime? startDate = controller.currentDateRange?.start;
    DateTime? endDate = controller.currentDateRange?.end;

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context){
          return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: StatefulBuilder(
                  builder: (context, setModalState){
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.translate('selectDateRange'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Start Date
                          _DatePickerTile(
                            label: l10n.translate('startDate'),
                            date: startDate,
                            onCleared: () => setModalState(() => startDate = null),
                            onPicked: (date) => setModalState(() => startDate = date),
                          ),
                          const Divider(height: 1),
                          // End Date
                          _DatePickerTile(
                            label: l10n.translate('endDate'),
                            date: endDate,
                            onCleared: () => setModalState(() => endDate = null),
                            onPicked: (date) => setModalState(() => endDate = date),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(l10n.translate('cancel')),
                                ),
                              ),
                              const SizedBox(width: 12,),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (startDate != null && endDate != null)
                                      ? () {
                                    controller.setDateRange(
                                      DateTimeRange(
                                          start: startDate!, end: endDate!),
                                    );
                                    Navigator.pop(context);
                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF111111),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(l10n.translate('apply')),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
              ),
          );
      }
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback? onCleared;
  final ValueChanged<DateTime> onPicked;

  const _DatePickerTile({
    required this.label,
    this.date,
    this.onCleared,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today, size: 20),
      title: Text(
        date != null
            ? '${date!.year}/${date!.month.toString().padLeft(2, '0')}/${date!.day.toString().padLeft(2, '0')}'
            : label,
        style: TextStyle(
          color: date != null ? const Color(0xFF111111) : Colors.grey,
          fontWeight: date != null ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: date != null
          ? IconButton(
        icon: const Icon(Icons.clear, size: 18),
        onPressed: onCleared,
      )
          : const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF111111),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
    );
  }
}


class _ExportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ExportButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF344054)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF344054),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}