import 'dropdown_item_model.dart';

enum FieldType {
  text,
  number,
  email,
  password,
  simpleDropdown,
  searchableDropdown,
  date,
  checkbox,
}

enum DropdownDataSourceType {
  staticList,      // List<<DropdownItemModel> مستقیم
  futureApi,       // Future<List<<DropdownItemModel>>
  paginatedApi,    // lazy load با صفحه‌بندی
}

class FormFieldConfig {
  final String key;
  final String labelKey;
  final FieldType type;
  final bool isRequired;
  final String? hint;
  final String? helperText;
  final List<String>? searchFields;      // برای searchableDropdown
  final String? displayField;            // فیلدی که نمایش داده می‌شود (پیش‌فرض: name)
  final bool isMultiSelect;              // فقط برای dropdown ها
  final DropdownDataSourceType dataSourceType;
  final List<DropdownItemModel>? staticItems;  // برای staticList
  final Future<List<DropdownItemModel>> Function(String query, String searchField)? futureFetcher; // برای futureApi
  final Future<List<DropdownItemModel>> Function(String query, String searchField, int page)? paginatedFetcher; // برای paginatedApi
  final int debounceMs;                  // پیش‌فرض 300ms
  final int pageSize;                    // برای paginatedApi (پیش‌فرض 20)

  final DropdownItemModel? placeholderItem;

  const FormFieldConfig({
    required this.key,
    required this.labelKey,
    required this.type,
    this.isRequired = false,
    this.hint,
    this.helperText,
    this.searchFields,
    this.displayField = 'name',
    this.isMultiSelect = false,
    this.dataSourceType = DropdownDataSourceType.staticList,
    this.staticItems,
    this.futureFetcher,
    this.paginatedFetcher,
    this.debounceMs = 300,
    this.pageSize = 20,
    this.placeholderItem,
  }) : assert(
  type == FieldType.searchableDropdown || (searchFields == null && futureFetcher == null && paginatedFetcher == null),
  'Search-related fields only apply to searchableDropdown',
  ),
        assert(
        !isMultiSelect || type == FieldType.simpleDropdown || type == FieldType.searchableDropdown,
        'MultiSelect only applies to dropdown fields',
        );

  String get displayFieldName => displayField ?? 'name';
}