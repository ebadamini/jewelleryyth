import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/table_column.dart';

class TableExportService {
  static Future<void> exportExcel<T>({
    required BuildContext context,
    required String fileName,
    required List<String> headers,           // ← ترجمه‌شده پاس داده می‌شه
    required List<ColumnConfig<T>> columns,
    required List<T> items,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheetName = excel.getDefaultSheet()!;
      final sheet = excel[sheetName];

      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
        );
      }

      for (var r = 0; r < items.length; r++) {
        final item = items[r];
        for (var c = 0; c < columns.length; c++) {
          final col = columns[c];
          final val = col.valueGetter?.call(item)?.toString() ?? '';
          sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1),
          ).value = TextCellValue(val);
        }
      }

      final bytes = excel.encode();
      if (bytes == null) {
        _showSnackBar(context, 'خطا در ساخت فایل Excel');
        return;
      }
      await _saveAndShare(bytes, '$fileName.xlsx', context);
    } catch (e) {
      debugPrint('Excel export error: $e');
      _showSnackBar(context, 'خطا در خروجی Excel');
    }
  }

  static Future<void> exportPdf<T>({
    required BuildContext context,
    required String fileName,
    required List<String> headers,           // ← ترجمه‌شده پاس داده می‌شه
    required List<ColumnConfig<T>> columns,
    required List<T> items,
  }) async {
    try {
      final pdf = pw.Document();

      pw.Font? font;
      try {
        final fontData = await rootBundle.load('assets/fonts/Vazirmatn-Regular.ttf');
        font = pw.Font.ttf(fontData);
      } catch (_) {
        debugPrint('⚠️ فونت Vazirmantt یافت نشد');
      }

      final textStyle = pw.TextStyle(
        font: font,
        fontSize: 10,
        fontFallback: font != null ? [font] : [],
      );
      final headerStyle = pw.TextStyle(
        font: font,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        fontFallback: font != null ? [font] : [],
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context context) {
            return pw.TableHelper.fromTextArray(
              headers: headers,  // ← استفاده از headers ترجمه‌شده
              data: items.map((item) {
                return columns.map((c) {
                  return c.valueGetter?.call(item)?.toString() ?? '';
                }).toList();
              }).toList(),
              border: pw.TableBorder.all(
                width: 0.5,
                color: PdfColors.grey400,
              ),
              headerStyle: headerStyle,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellStyle: textStyle,
              cellHeight: 28,
              cellAlignments: {
                for (var i = 0; i < columns.length; i++)
                  i: pw.Alignment.centerLeft,
              },
            );
          },
        ),
      );

      final bytes = await pdf.save();
      await _saveAndShare(bytes, '$fileName.pdf', context);
    } catch (e) {
      debugPrint('PDF export error: $e');
      _showSnackBar(context, 'خطا در خروجی PDF');
    }
  }

  static Future<void> _saveAndShare(
      List<int> bytes,
      String fileName,
      BuildContext context,
      ) async {
    try {
      if (kIsWeb) {
        _showSnackBar(context, 'خروجی در نسخه وب پشتیبانی نمی‌شود');
        return;
      }
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(path)], text: fileName);
    } catch (e) {
      debugPrint('Share error: $e');
      _showSnackBar(context, 'خطا در اشتراک‌گذاری فایل');
    }
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}