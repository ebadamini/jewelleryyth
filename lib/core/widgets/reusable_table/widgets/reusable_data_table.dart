import 'package:flutter/material.dart';
import 'package:jewelleryyth/app/localization/app_localizations.dart';
import '../controllers/table_controller.dart';
import 'table_pagination.dart';
import 'table_toolbar.dart';

class ReusableDataTable<T> extends StatefulWidget {
  final TableController<T> controller;
  final String? title;
  final bool showSearch;
  final bool showDateFilter;
  final bool showExport;
  final bool showPagination;
  final String exportFileName;
  final double? maxHeight;


  const ReusableDataTable({
    super.key,
    required this.controller,
    this.title,
    this.showSearch = true,
    this.showDateFilter = true,
    this.showExport = true,
    this.showPagination = true,
    this.exportFileName = 'export',
    this.maxHeight,
  });

  @override
  State<ReusableDataTable<T>> createState() => _ReusableDataTableState<T>();
}

class _ReusableDataTableState<T> extends State<ReusableDataTable<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant ReusableDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refresh);
      widget.controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';


    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFEAECEF)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (widget.showSearch || widget.showDateFilter || widget.showExport)
              TableToolbar<T>(
                controller: widget.controller,
                showSearch: widget.showSearch,
                showDateFilter: widget.showDateFilter,
                showExport: widget.showExport,
                fileName: widget.title ?? "export",
              ),
            Flexible(
                child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: widget.maxHeight ?? double.infinity,
                  minHeight: 200,
                ),
                child: _buildTable(l10n, isRtl)
                ),
            ),
            if (widget.showPagination)
              TablePagination<T>(controller: widget.controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(AppLocalizations l10n, bool isRtl) {
    final items = widget.controller.paginatedItems;
    final columns = widget.controller.columns;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFFD0D5DD)),
            const SizedBox(height: 12),
            Text(
              l10n.translate('noDataFound'),
              style: const TextStyle(color: Color(0xFF667085), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowHeight: 44,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 56,
              horizontalMargin: 16,
              columnSpacing: 24,
              headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => const Color(0xFFF9FAFB),
              ),
              border: TableBorder(
                horizontalInside: const BorderSide(color: Color(0xFFEAECEF)),
              ),
              columns: columns.map((col) {
                return DataColumn(
                  label: SizedBox(
                    width: col.width,
                    child: Text(
                      col.resolveTitle(l10n),
                      textAlign: col.textAlign,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ),
                  onSort: col.sortable
                      ? (idx, asc) => widget.controller.sort(col.key, asc)
                      : null,
                );
              }).toList(),
              rows: List.generate(items.length, (index) {
                final item = items[index];
                return DataRow(
                  color: WidgetStateProperty.resolveWith((states) {
                    return index.isEven ? Colors.white : const Color(0xFFFAFBFC);
                  }),
                  cells: columns.map((col) {
                    return DataCell(
                      col.cellBuilder != null
                          ? col.cellBuilder!(context, item, index, isRtl)
                          : Text(
                        col.displayValue?.call(context, item)
                            ?? col.valueGetter?.call(item)?.toString()
                            ?? '',
                        textAlign: col.textAlign,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF111111),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
