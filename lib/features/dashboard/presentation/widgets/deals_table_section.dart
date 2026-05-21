import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/utils/csv_exporter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/components/cards/app_section_card.dart';
import '../../../../shared/components/tables/app_table_toolbar.dart';

class DealsTableSection extends StatefulWidget {
  const DealsTableSection({super.key});

  @override
  State<DealsTableSection> createState() => _DealsTableSectionState();
}

class _DealsTableSectionState extends State<DealsTableSection> {
  final _searchController = TextEditingController();

  String? _selectedService;

  final List<Map<String, String>> _allDeals = const [
    {
      'id': 'FA122170',
      'customerName': 'Mira Torff',
      'customerEmail': 'miratorff@gmail.com',
      'service': 'Software Service',
      'dealValue': '\$968.45',
      'closeDate': '29 Oct 2025',
    },
    {
      'id': 'FA128272',
      'customerName': 'John Smith',
      'customerEmail': 'smithjo@gmail.com',
      'service': 'Consulting',
      'dealValue': '\$1,228.20',
      'closeDate': '28 Oct 2025',
    },
    {
      'id': 'FA127829',
      'customerName': 'Simon Joe',
      'customerEmail': 'josimon@gmail.com',
      'service': 'Software Service',
      'dealValue': '\$1,928.90',
      'closeDate': '28 Oct 2025',
    },
  ];

  List<Map<String, String>> get _filteredDeals {
    final search = _searchController.text.trim().toLowerCase();

    return _allDeals.where((deal) {
      final matchesSearch = search.isEmpty ||
          deal.values.any((value) => value.toLowerCase().contains(search));

      final matchesFilter = _selectedService == null ||
          _selectedService!.isEmpty ||
          deal['service'] == _selectedService;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showExportDialog(BuildContext context) {
    final csv = CsvExporter.build(
      headers: const [
        'ID Deal',
        'Customer Name',
        'Customer Email',
        'Product/Service',
        'Deal Value',
        'Close Date',
      ],
      rows: _filteredDeals
          .map(
            (e) => [
          e['id'] ?? '',
          e['customerName'] ?? '',
          e['customerEmail'] ?? '',
          e['service'] ?? '',
          e['dealValue'] ?? '',
          e['closeDate'] ?? '',
        ],
      )
          .toList(),
    );

    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('CSV Export'),
          content: SingleChildScrollView(child: SelectableText(csv)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final deals = _filteredDeals;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.translate('salesDeals'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF98A2B3)),
            ],
          ),
          // const SizedBox(height: 18),
          // AppTableToolbar(
          //   searchController: _searchController,
          //   searchHint: l10n.translate('searchSomething'),
          //   onSearchSubmitted: (_) => setState(() {}),
          //   filterLabel: l10n.translate('filter'),
          //   selectedFilterValue: _selectedService,
          //   filters: const [
          //     AppTableFilterOption(value: 'Software Service', label: 'Software Service'),
          //     AppTableFilterOption(value: 'Consulting', label: 'Consulting'),
          //   ],
          //   onFilterChanged: (value) {
          //     setState(() => _selectedService = value);
          //   },
          //   onExportPressed: () => _showExportDialog(context),
          // ),
          const SizedBox(height: 18),
          isMobile ? _DealsMobileList(deals: deals) : _DealsTable(deals: deals),
        ],
      ),
    );
  }
}

class _DealsTable extends StatelessWidget {
  const _DealsTable({required this.deals});

  final List<Map<String, String>> deals;

  @override
  Widget build(BuildContext context) {
    const headers = [
      'ID Deal',
      'Customer Name',
      'Customer Email',
      'Product/Service',
      'Deal Value',
      'Close Date',
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: headers.map((header) {
              return Expanded(
                child: Text(
                  header,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B7280),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        ...deals.map(
              (deal) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0F2F5)),
            ),
            child: Row(
              children: [
                Expanded(child: Text(deal['id'] ?? '')),
                Expanded(child: Text(deal['customerName'] ?? '')),
                Expanded(child: Text(deal['customerEmail'] ?? '')),
                Expanded(child: Text(deal['service'] ?? '')),
                Expanded(child: Text(deal['dealValue'] ?? '')),
                Expanded(child: Text(deal['closeDate'] ?? '')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DealsMobileList extends StatelessWidget {
  const _DealsMobileList({required this.deals});

  final List<Map<String, String>> deals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: deals.map((deal) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF0F2F5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deal['customerName'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(deal['id'] ?? ''),
              const SizedBox(height: 6),
              Text(deal['service'] ?? ''),
              const SizedBox(height: 6),
              Text(deal['dealValue'] ?? ''),
              const SizedBox(height: 6),
              Text(
                deal['closeDate'] ?? '',
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
