class CsvExporter {
  static String build({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(headers.join(','));

    for (final row in rows) {
      buffer.writeln(
        row.map(_escape).join(','),
      );
    }

    return buffer.toString();
  }

  static String _escape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
