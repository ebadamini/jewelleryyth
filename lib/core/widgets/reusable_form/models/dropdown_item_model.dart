// core/widgets/reusable_form/models/dropdown_item_model.dart

class DropdownItemModel {
  final String id;
  final String name;
  final Map<String, dynamic> metadata;
  final bool? isDisable;

  const DropdownItemModel({
    required this.id,
    required this.name,
    this.metadata = const {},
    this.isDisable = true,
  });

  String? getField(String field) {
    if (field == 'name') return name;
    if (field == 'id') return id;
    return metadata[field]?.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropdownItemModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DropdownItemModel(id: $id, name: $name)';
}