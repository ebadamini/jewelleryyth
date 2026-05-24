import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewelleryyth/app/localization/app_localizations.dart';
import '../../models/dropdown_item_model.dart';
import '../../models/form_field_config.dart';

class SearchableDropdownField extends StatefulWidget {
  final FormFieldConfig config;
  final List<DropdownItemModel>? initialItems; // برای staticList
  final dynamic initialValue; // DropdownItemModel یا List<<DropdownItemModel>
  final ValueChanged<dynamic>? onChanged;
  final FormFieldSetter<dynamic>? onSaved;

  const SearchableDropdownField({
    super.key,
    required this.config,
    this.initialItems,
    this.initialValue,
    this.onChanged,
    this.onSaved,
  });

  @override
  State<SearchableDropdownField> createState() =>
      _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
  
  late dynamic _currentValue;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // برای بستن با کلیک بیرون
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: _SearchableDropdownOverlay(
                  config: widget.config,
                  initialItems: widget.initialItems,
                  currentValue: _currentValue,
                  onSelect: (value) {
                    setState(() {
                      _currentValue = value;
                    });
                    widget.onChanged?.call(value);
                    widget.onSaved?.call(value);
                    _removeOverlay();
                  },
                  onMultiSelect: (values) {
                    setState(() {
                      _currentValue = values;
                    });
                    widget.onChanged?.call(values);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  String _getDisplayText() {
    final l10n = AppLocalizations.of(context);
    if (_currentValue == null) return widget.config.hint ?? l10n.translate("select""....");

    if (widget.config.isMultiSelect) {
      final items = _currentValue as List<DropdownItemModel>;
      if (items.isEmpty) return widget.config.hint ?? l10n.translate("select""....");
      if (items.length == 1) return items.first.name;
      return '${items.first.name} و ${items.length - 1}${l10n.translate("anOtherThing")}';
    }

    final item = _currentValue as DropdownItemModel;
    return item.getField(widget.config.displayFieldName) ?? item.name;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormField<dynamic>(
        initialValue: _currentValue,
        validator: (value) {
          if (!widget.config.isRequired) return null;
          if (value == null) return 'لطفاً یک گزینه انتخاب کنید';
          if (widget.config.isMultiSelect && (value is List && value.isEmpty)) {
            return 'حداقل یک گزینه باید انتخاب شود';
          }
          return null;
        },
        builder: (fieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _toggleOverlay,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: widget.config.labelKey,
                    hintText: widget.config.hint,
                    helperText: widget.config.helperText,
                    errorText: fieldState.errorText,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_currentValue != null &&
                            (!widget.config.isMultiSelect ||
                                (_currentValue is List &&
                                    (_currentValue as List).isNotEmpty)))
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _currentValue = widget.config.isMultiSelect
                                    ? <DropdownItemModel>[]
                                    : null;
                              });
                              fieldState.didChange(_currentValue);
                              widget.onChanged?.call(_currentValue);
                              widget.onSaved?.call(_currentValue);
                            },
                          ),
                        Icon(
                          _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    _getDisplayText(),
                    style: TextStyle(
                      color:
                          _currentValue == null ||
                              (widget.config.isMultiSelect &&
                                  _currentValue is List &&
                                  (_currentValue as List).isEmpty)
                          ? Theme.of(context).hintColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
              // نمایش Chips برای Multi-Select
              if (widget.config.isMultiSelect &&
                  _currentValue is List &&
                  (_currentValue as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_currentValue as List<DropdownItemModel>).map((
                      item,
                    ) {
                      return Chip(
                        label: Text(item.name),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          final updated = List<DropdownItemModel>.from(
                            _currentValue as List,
                          )..remove(item);
                          setState(() => _currentValue = updated);
                          fieldState.didChange(updated);
                          widget.onChanged?.call(updated);
                        },
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ==================== OVERLAY WIDGET ====================

class _SearchableDropdownOverlay extends StatefulWidget {
  final FormFieldConfig config;
  final List<DropdownItemModel>? initialItems;
  final dynamic currentValue;
  final ValueChanged<DropdownItemModel>? onSelect;
  final ValueChanged<List<DropdownItemModel>>? onMultiSelect;

  const _SearchableDropdownOverlay({
    required this.config,
    this.initialItems,
    this.currentValue,
    this.onSelect,
    this.onMultiSelect,
  });

  @override
  State<_SearchableDropdownOverlay> createState() =>
      _SearchableDropdownOverlayState();
}

class _SearchableDropdownOverlayState
    extends State<_SearchableDropdownOverlay> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<DropdownItemModel> _items = [];
  List<DropdownItemModel> _filteredItems = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _currentQuery = '';
  String _selectedSearchField = '';
  Timer? _debounceTimer;

  late List<DropdownItemModel> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedSearchField = widget.config.searchFields?.first ?? 'name';

    if (widget.config.isMultiSelect && widget.currentValue is List) {
      _selectedItems = List<DropdownItemModel>.from(
        widget.currentValue as List,
      );
    } else {
      _selectedItems = [];
    }

    // بارگذاری اولیه
    if (widget.config.dataSourceType == DropdownDataSourceType.staticList) {
      _items = widget.initialItems ?? [];
      _filteredItems = _items;
    } else {
      _fetchData('');
    }

    _scrollController.addListener(_onScroll);

    // فوکوس خودکار روی سرچ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.config.dataSourceType != DropdownDataSourceType.paginatedApi)
      return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_isLoading && _hasMore) {
        _fetchData(_currentQuery, page: _currentPage + 1);
      }
    }
  }

  Future<void> _fetchData(
    String query, {
    int page = 1,
    bool append = false,
  }) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (!append) {
        _currentPage = 1;
        _hasMore = true;
      }
    });

    try {
      List<DropdownItemModel> result = [];

      switch (widget.config.dataSourceType) {
        case DropdownDataSourceType.staticList:
          result = widget.initialItems ?? [];
          break;

        case DropdownDataSourceType.futureApi:
          if (widget.config.futureFetcher != null) {
            result = await widget.config.futureFetcher!(
              query,
              _selectedSearchField,
            );
          }
          break;

        case DropdownDataSourceType.paginatedApi:
          if (widget.config.paginatedFetcher != null) {
            result = await widget.config.paginatedFetcher!(
              query,
              _selectedSearchField,
              page,
            );
            if (result.length < widget.config.pageSize) {
              _hasMore = false;
            }
          }
          break;
      }

      setState(() {
        if (append) {
          _items.addAll(result);
          _currentPage = page;
        } else {
          _items = result;
          _filteredItems = result;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      Duration(milliseconds: widget.config.debounceMs),
      () {
        _currentQuery = value;

        if (widget.config.dataSourceType == DropdownDataSourceType.staticList) {
          // فیلتر محلی برای staticList
          setState(() {
            if (value.isEmpty) {
              _filteredItems = _items;
            } else {
              _filteredItems = _items.where((item) {
                final searchValue =
                    item.getField(_selectedSearchField)?.toLowerCase() ?? '';
                return searchValue.contains(value.toLowerCase());
              }).toList();
            }
          });
        } else {
          _fetchData(value);
        }
      },
    );
  }

  void _toggleSelection(DropdownItemModel item) {
    if (!widget.config.isMultiSelect) {
      widget.onSelect?.call(item);
      return;
    }

    setState(() {
      final exists = _selectedItems.any((s) => s.id == item.id);
      if (exists) {
        _selectedItems.removeWhere((s) => s.id == item.id);
      } else {
        _selectedItems.add(item);
      }
    });
    widget.onMultiSelect?.call(_selectedItems);
  }

  bool _isSelected(DropdownItemModel item) {
    if (!widget.config.isMultiSelect) {
      if (widget.currentValue is DropdownItemModel) {
        return (widget.currentValue as DropdownItemModel).id == item.id;
      }
      return false;
    }
    return _selectedItems.any((s) => s.id == item.id);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.of(context).pop();
          }
          if (event.logicalKey == LogicalKeyboardKey.enter &&
              !widget.config.isMultiSelect) {
            if (_filteredItems.isNotEmpty) {
              widget.onSelect?.call(_filteredItems.first);
            }
          }
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Search + Filter
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // فیلتر فیلد سرچ
                  if (widget.config.searchFields != null &&
                      widget.config.searchFields!.length > 1)
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.config.searchFields!.length,
                        itemBuilder: (ctx, i) {
                          final field = widget.config.searchFields![i];
                          final isActive = field == _selectedSearchField;
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ChoiceChip(
                              label: Text(
                                _translateField(field),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isActive
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null,
                                ),
                              ),
                              selected: isActive,
                              onSelected: (_) {
                                setState(() => _selectedSearchField = field);
                                _onSearchChanged(_searchController.text);
                              },
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  // سرچ اینپوت
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'جستجو...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                    textInputAction: TextInputAction.search,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // لیست آیتم‌ها
            Flexible(
              child: _isLoading && _items.isEmpty
                  ? _buildLoadingState()
                  : _filteredItems.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount:
                          _filteredItems.length +
                          (_isLoading && _hasMore ? 1 : 0),
                      itemBuilder: (ctx, i) {
                        if (i >= _filteredItems.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        final item =
                            widget.config.dataSourceType ==
                                DropdownDataSourceType.staticList
                            ? _filteredItems[i]
                            : _items[i];

                        final isSelected = _isSelected(item);

                        return _buildItemTile(item, isSelected);
                      },
                    ),
            ),

            // فوتر: Clear All + Done (برای Multi-Select)
            if (widget.config.isMultiSelect)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _selectedItems.clear());
                        widget.onMultiSelect?.call([]);
                      },
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('پاک کردن همه'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('تأیید'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(DropdownItemModel item, bool isSelected) {
    final subtitle = widget.config.searchFields
        ?.where((f) => f != widget.config.displayFieldName)
        .map((f) => item.getField(f))
        .where((v) => v != null && v.isNotEmpty)
        .join(' | ');

    return InkWell(
      onTap: () => _toggleSelection(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : null,
        child: Row(
          children: [
            if (widget.config.isMultiSelect)
              Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(item),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            else if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              )
            else
              const SizedBox(width: 20),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.getField(widget.config.displayFieldName) ?? item.name,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 150, color: Colors.grey[200]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              'موردی یافت نشد',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'عبارت دیگری امتحان کنید',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _translateField(String field) {
    const map = {
      'name': 'نام',
      'phone': 'موبایل',
      'mobile': 'موبایل',
      'code': 'کد ملی',
      'nationalCode': 'کد ملی',
      'id': 'شناسه',
    };
    return map[field] ?? field;
  }
}
