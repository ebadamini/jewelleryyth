import 'package:flutter/material.dart';
import 'package:jewelleryyth/app/localization/app_localizations.dart';

class ColumnConfig<T> {
  final String key;
  final String? titleKey;
  final String? title;
  final double? width;
  final bool sortable;
  final bool searchable;
  final Widget Function(BuildContext context, T data, int rowIndex, bool isRtl)? cellBuilder;
  final dynamic Function(T data)? valueGetter;
  final String? Function(BuildContext context, T data)? displayValue;
  final TextAlign textAlign;

  const ColumnConfig({
    required this.key,
    this.titleKey,
    this.title,
    this.width,
    this.sortable = true,
    this.searchable = true,
    this.cellBuilder,
    this.valueGetter,
    this.displayValue,
    this.textAlign = TextAlign.start,
  }) : assert(titleKey != null || title != null, 'title key یا title باید مشخص شود');

  String resolveTitle(AppLocalizations l10n){
    if(titleKey != null) return l10n.translate(titleKey!);
    return title ?? key;
  }
}