import 'package:flutter/material.dart';
import '../models/table_column.dart';

class TableController<T> extends ChangeNotifier {
  final List<ColumnConfig<T>> columns;
  final DateTime? Function(T)? dateGetter;

  List<T> _allItems;
  List<T> _filteredItems;

  String _searchQuery = '';
  DateTimeRange? _dateRange;
  String? _sortColumn;
  bool _sortAscending = true;
  int _currentPage = 1;
  int _rowsPerPage = 10;

  TableController({
    required this.columns,
    required List<T> items,
    this.dateGetter,
  })  : _allItems = items,
        _filteredItems = List.from(items);

  List<T> get items => _filteredItems;
  List<T> get paginatedItems {
    final start = (_currentPage - 1) * _rowsPerPage;
    if (start >= _filteredItems.length) return [];
    final end = (start + _rowsPerPage).clamp(start, _filteredItems.length);
    return _filteredItems.sublist(start, end);
  }

  int get totalPages => (_filteredItems.length / _rowsPerPage).ceil();
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;
  DateTimeRange? get currentDateRange => _dateRange;

  void search(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
    _currentPage = 1;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _dateRange = range;
    _applyFilters();
    _currentPage = 1;
    notifyListeners();
  }

  void clearDateRange() {
    _dateRange = null;
    _applyFilters();
    _currentPage = 1;
    notifyListeners();
  }

  void sort(String columnKey, bool ascending) {
    _sortColumn = columnKey;
    _sortAscending = ascending;
    _applyFilters();
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    _currentPage = page;
    notifyListeners();
  }

  void setRowsPerPage(int count) {
    _rowsPerPage = count;
    _currentPage = 1;
    notifyListeners();
  }

  void refresh(List<T> items) {
    _allItems = items;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredItems = _allItems.where((item) {
      if (_searchQuery.isNotEmpty) {
        final found = columns.any((col) {
          if (!col.searchable) return false;
          final val = col.valueGetter?.call(item)?.toString().toLowerCase() ??
              item.toString().toLowerCase();
          return val.contains(_searchQuery);
        });
        if (!found) return false;
      }

      if (_dateRange != null && dateGetter != null) {
        final date = dateGetter!(item);
        if (date != null) {
          final start = DateTime(
              _dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day);
          final end = DateTime(_dateRange!.end.year, _dateRange!.end.month,
              _dateRange!.end.day, 23, 59, 59);
          if (date.isBefore(start) || date.isAfter(end)) return false;
        }
      }

      return true;
    }).toList();

    if (_sortColumn != null) {
      final col = columns.firstWhere((c) => c.key == _sortColumn);
      _filteredItems.sort((a, b) {
        final va = col.valueGetter?.call(a);
        final vb = col.valueGetter?.call(b);
        int result;
        if (va == null && vb == null) {
          result = 0;
        } else if (va == null) {
          result = 1;
        } else if (vb == null) {
          result = -1;
        } else if (va is num && vb is num) {
          result = va.compareTo(vb);
        } else if (va is DateTime && vb is DateTime) {
          result = va.compareTo(vb);
        } else {
          result = va.toString().compareTo(vb.toString());
        }
        return _sortAscending ? result : -result;
      });
    }
  }
}