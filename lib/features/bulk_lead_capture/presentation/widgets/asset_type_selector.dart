import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/bulk_lead_capture/domain/entities/bulk_lead.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/bloc/bulk_lead_bloc.dart';

/// Multi-select asset type list with inline Make/Model/Quantity fields.
///
/// Implements BR-07A (multi-select), BR-07B (inline field expansion),
/// BR-07C (Make dropdown with Other fallback), BR-07D (Model dropdown),
/// BR-07E (Quantity per type).
///
/// Asset types are hard-coded for Phase 1 (industrial/machinery).
/// Phase 2+: load from the asset schema API and drive from `AssetSchema`.
class AssetTypeSelector extends StatelessWidget {
  const AssetTypeSelector({super.key});

  static const List<_AssetTypeOption> _options = [
    _AssetTypeOption(key: 'excavators', label: 'Excavators'),
    _AssetTypeOption(key: 'loaders', label: 'Loaders'),
    _AssetTypeOption(key: 'bulldozers', label: 'Bulldozers'),
    _AssetTypeOption(key: 'graders', label: 'Graders'),
    _AssetTypeOption(key: 'cranes', label: 'Cranes'),
    _AssetTypeOption(key: 'forklifts', label: 'Forklifts'),
    _AssetTypeOption(key: 'trucks', label: 'Trucks'),
    _AssetTypeOption(key: 'trailers', label: 'Trailers'),
    _AssetTypeOption(key: 'agricultural', label: 'Agricultural Machinery'),
    _AssetTypeOption(key: 'other', label: 'Other Equipment'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkLeadBloc, BulkLeadState>(
      builder: (context, state) {
        return Column(
          children: _options.map((option) {
            final selected = state.isAssetTypeSelected(option.key);
            final item = state.itemForType(option.key);
            return _AssetTypeRow(
              option: option,
              selected: selected,
              item: item,
            );
          }).toList(),
        );
      },
    );
  }
}

class _AssetTypeRow extends StatelessWidget {
  const _AssetTypeRow({
    required this.option,
    required this.selected,
    this.item,
  });

  final _AssetTypeOption option;
  final bool selected;
  final BulkLeadAssetItem? item;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;

    return Column(
      children: [
        // ── Checkbox row ───────────────────────────────────────────────────
        InkWell(
          onTap: () => context.read<BulkLeadBloc>().add(
                BulkLeadAssetTypeToggled(
                  assetTypeKey: option.key,
                  assetTypeLabel: option.label,
                ),
              ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingSm,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: selected,
                  onChanged: (_) => context.read<BulkLeadBloc>().add(
                        BulkLeadAssetTypeToggled(
                          assetTypeKey: option.key,
                          assetTypeLabel: option.label,
                        ),
                      ),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  option.label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colours.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Inline expansion (BR-07B) — shown only when selected ──────────
        if (selected && item != null)
          _AssetItemFields(assetTypeKey: option.key, item: item!),

        Divider(color: colours.outline.withAlpha(77), height: 1),
      ],
    );
  }
}

/// Inline make/model/quantity fields that appear when an asset type is selected.
class _AssetItemFields extends StatefulWidget {
  const _AssetItemFields({required this.assetTypeKey, required this.item});

  final String assetTypeKey;
  final BulkLeadAssetItem item;

  @override
  State<_AssetItemFields> createState() => _AssetItemFieldsState();
}

class _AssetItemFieldsState extends State<_AssetItemFields> {
  late String? _selectedMake;
  late String? _selectedModel;
  late int _quantity;
  bool _makeIsOther = false;
  final _otherMakeController = TextEditingController();
  final _otherModelController = TextEditingController();

  // Phase 1 make lists per asset type — to be driven by asset schema API.
  static const Map<String, List<String>> _makesByType = {
    'excavators': ['Caterpillar', 'Komatsu', 'Hitachi', 'Volvo', 'Liebherr', 'Hyundai'],
    'loaders': ['Caterpillar', 'Komatsu', 'Volvo', 'JCB', 'Case'],
    'bulldozers': ['Caterpillar', 'Komatsu', 'John Deere', 'Case'],
    'graders': ['Caterpillar', 'Komatsu', 'John Deere', 'Volvo'],
    'cranes': ['Liebherr', 'Tadano', 'Manitowoc', 'Terex', 'Kobelco'],
    'forklifts': ['Toyota', 'Crown', 'Linde', 'Hyster', 'Yale', 'Nissan'],
    'trucks': ['Kenworth', 'Mack', 'Volvo', 'Mercedes-Benz', 'Scania', 'Isuzu'],
    'trailers': ['Vawdrey', 'Maxitrans', 'Krueger', 'Hamelex White'],
    'agricultural': ['John Deere', 'Case IH', 'New Holland', 'AGCO', 'Claas'],
    'other': [],
  };

  @override
  void initState() {
    super.initState();
    _selectedMake = widget.item.make;
    _selectedModel = widget.item.model;
    _quantity = widget.item.quantity;
    _makeIsOther = _selectedMake == 'Other' || (_selectedMake != null &&
        !(_makesByType[widget.assetTypeKey] ?? []).contains(_selectedMake));
  }

  @override
  void dispose() {
    _otherMakeController.dispose();
    _otherModelController.dispose();
    super.dispose();
  }

  List<String> get _makes =>
      [...(_makesByType[widget.assetTypeKey] ?? []), 'Other'];

  void _dispatch() {
    context.read<BulkLeadBloc>().add(
          BulkLeadAssetItemUpdated(
            assetTypeKey: widget.assetTypeKey,
            quantity: _quantity,
            make: _makeIsOther ? _otherMakeController.text : _selectedMake,
            model: (_selectedModel == 'Other' || _selectedModel == null)
                ? _otherModelController.text
                : _selectedModel,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.spacingXxl,
        bottom: AppDimensions.spacingMd,
        right: AppDimensions.spacingSm,
      ),
      child: Column(
        children: [
          // ── Quantity ─────────────────────────────────────────────────────
          Row(
            children: [
              const Text('Quantity:', style: AppTextStyles.bodyMedium),
              const SizedBox(width: AppDimensions.spacingMd),
              _QuantitySelector(
                value: _quantity,
                onChanged: (val) {
                  setState(() => _quantity = val);
                  _dispatch();
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          // ── Make ──────────────────────────────────────────────────────────
          if (_makes.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              initialValue: _makeIsOther ? 'Other' : _selectedMake,
              decoration: const InputDecoration(labelText: 'Make (optional)'),
              items: _makes
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _makeIsOther = val == 'Other';
                  _selectedMake = _makeIsOther ? null : val;
                  _selectedModel = null;
                });
                _dispatch();
              },
            ),
            if (_makeIsOther) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              TextFormField(
                controller: _otherMakeController,
                onChanged: (_) => _dispatch(),
                decoration: const InputDecoration(labelText: 'Specify make'),
              ),
            ],
          ],

          const SizedBox(height: AppDimensions.spacingSm),

          // ── Model ─────────────────────────────────────────────────────────
          TextFormField(
            controller: _otherModelController,
            onChanged: (_) => _dispatch(),
            decoration: const InputDecoration(
              labelText: 'Model (optional)',
              hintText: 'e.g. 320, 730D',
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove, size: 18),
          visualDensity: VisualDensity.compact,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
          child: Text(
            '$value',
            style: AppTextStyles.titleMedium,
          ),
        ),
        IconButton.outlined(
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add, size: 18),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _AssetTypeOption {
  const _AssetTypeOption({required this.key, required this.label});
  final String key;
  final String label;
}
