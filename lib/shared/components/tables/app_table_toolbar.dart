import 'package:flutter/material.dart';

import '../dropdowns/app_dropdown.dart';

class AppTableToolbar extends StatelessWidget {
  const AppTableToolbar({
    super.key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  final List<String> currencies;
  final String? selectedCurrency;
  final ValueChanged<String?> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    final currencyItems = currencies
        .map(
          (currency) => AppDropdownItem<String>(
        value: currency,
        label: currency,
      ),
    )
        .toList();

    return Row(
      children: [
        Expanded(
          child: AppDropdown<String>(
            label: 'Currency',
            value: selectedCurrency,
            items: currencyItems,
            onChanged: onCurrencyChanged,
          ),
        ),
      ],
    );
  }
}
