/// ============================================================================
/// DROPDOWN CHIP WIDGET
/// ============================================================================
///
/// A small removable "chip" (tag) that displays a selected item.
/// 
/// VISUAL:
///   ┌─────────────────┐
///   │  Ali Ahmadi  ✕  │
///   └─────────────────┘
/// 
/// USED BY:
///   - SearchableDropdownField (when isMultiSelect = true)
///   - Shows selected items below the dropdown field
/// 
/// FEATURES:
///   - Displays the item's display value (e.g., customer name)
///   - Has a delete button (✕) to remove the item
///   - Compact design - chips wrap in a Row using Wrap widget
///   - Follows Material Design chip styling
///
/// EXAMPLE USAGE:
/// ```dart
/// DropdownChip(
///   label: 'Ali Ahmadi',
///   onDelete: () {
///     setState(() => selectedItems.remove(item));
///   },
/// )
/// ```
/// ============================================================================

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// WIDGET: DropdownChip
/// ---------------------------------------------------------------------------
/// A compact chip widget for displaying selected dropdown items.
/// 
/// This widget is simple but important for multi-select UX:
///   - Users can see WHAT they've selected at a glance
///   - Users can remove individual items without reopening the dropdown
///   - Multiple chips wrap automatically (using Wrap in parent)
/// 
/// DESIGN PATTERN: This is a "dumb" presentational widget - it only
/// displays data and forwards user actions. No state management here.
/// ---------------------------------------------------------------------------
class DropdownChip extends StatelessWidget {
  /// -------------------------------------------------------------------------
  /// LABEL TEXT
  /// -------------------------------------------------------------------------
  /// The text displayed inside the chip.
  /// 
  /// Usually the item's display field value:
  ///   - Customer name: "Ali Ahmadi"
  ///   - Product name: "iPhone 15"
  /// 
  /// If the label is too long, it will be truncated with "..." (ellipsis).
  /// -------------------------------------------------------------------------
  final String label;

  /// -------------------------------------------------------------------------
  /// DELETE CALLBACK
  /// -------------------------------------------------------------------------
  /// Called when the user taps the X (delete) button on the chip.
  /// 
  /// USAGE: Remove the item from the selected items list in parent.
  /// ```dart
  /// onDelete: () {
  ///   setState(() {
  ///     selectedItems.removeWhere((item) => item['id'] == id);
  ///   });
  /// }
  /// ```
  /// 
  /// NOTE: This widget does NOT delete itself - the parent must rebuild
  /// without this chip. This follows Flutter's declarative pattern.
  /// -------------------------------------------------------------------------
  final VoidCallback onDelete;

  /// -------------------------------------------------------------------------
  /// BACKGROUND COLOR
  /// -------------------------------------------------------------------------
  /// Optional custom background color for the chip.
  /// 
  /// Defaults to the theme's primary color with 10% opacity.
  /// Override this if you want different colors for different item types.
  /// 
  /// Example: Give customers blue chips and products green chips.
  /// -------------------------------------------------------------------------
  final Color? backgroundColor;

  /// -------------------------------------------------------------------------
  /// CONSTRUCTOR
  /// -------------------------------------------------------------------------
  const DropdownChip({
    Key? key,
    required this.label,
    required this.onDelete,
    this.backgroundColor,
  }) : super(key: key);

  /// =========================================================================
  /// BUILD METHOD
  /// =========================================================================
  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------
    // Get theme colors for consistent styling
    // ------------------------------------------------------------------
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    // ------------------------------------------------------------------
    // Chip Widget
    // ------------------------------------------------------------------
    // Material Design Chip with:
    //   - Label: The item name (truncated if too long)
    //   - Delete icon: Small X button on the right
    //   - Background: Light tint of primary color
    //   - Padding: Comfortable spacing around text
    // ------------------------------------------------------------------
    return Chip(
      // ------------------------------------------------------------
      // Label (text inside the chip)
      // ------------------------------------------------------------
      label: Text(
        label,
        // Prevent overflow by truncating with "..."
        overflow: TextOverflow.ellipsis,
        // Make text slightly smaller for compact look
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ------------------------------------------------------------
      // Background Color
      // ------------------------------------------------------------
      // Uses custom color if provided, otherwise creates a light
      // version of the primary color (10% opacity).
      backgroundColor: backgroundColor ?? primaryColor.withOpacity(0.1),

      // ------------------------------------------------------------
      // Delete Icon
      // ------------------------------------------------------------
      // The X button that allows removing this chip.
      // onDeleted being non-null automatically shows the delete icon.
      deleteIcon: Icon(
        Icons.close,
        size: 16,
        // Slightly darker than background for visibility
        color: primaryColor.withOpacity(0.7),
      ),

      // ------------------------------------------------------------
      // Delete Callback
      // ------------------------------------------------------------
      // Called when user taps the X icon.
      // We forward this to the parent's onDelete callback.
      onDeleted: onDelete,

      // ------------------------------------------------------------
      // PADDING
      // ------------------------------------------------------------
      // Tight padding for compact appearance.
      // visualDensity makes the chip smaller overall.
      // ------------------------------------------------------------
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 0,
      ),
    );
  }
}
