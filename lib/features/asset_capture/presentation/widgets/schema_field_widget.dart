import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/core/theme/app_theme.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_field_schema.dart';
import 'package:pickles_direct/features/asset_capture/presentation/bloc/asset_capture_bloc.dart';
import 'package:pickles_direct/features/asset_capture/presentation/widgets/vin_scanner_sheet.dart';

/// Renders a single form field driven by an [AssetFieldSchema].
///
/// Each field type maps to a specific widget:
/// - text / vinScanner → TextFormField
/// - number / year / currency → numeric TextFormField
/// - dropdown → DropdownButtonFormField
/// - textarea → multi-line TextFormField
/// - gpsCapture → GPS row with "Use My Location" button
///
/// Field values are read from and written to AssetCaptureBloc via events.
class SchemaFieldWidget extends StatefulWidget {
  const SchemaFieldWidget({
    required this.schema,
    super.key,
  });

  final AssetFieldSchema schema;

  @override
  State<SchemaFieldWidget> createState() => _SchemaFieldWidgetState();
}

class _SchemaFieldWidgetState extends State<SchemaFieldWidget> {
  late final TextEditingController _controller;
  bool _controllerInitialised = false;

  AssetFieldSchema get _schema => widget.schema;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncControllerFromState(Map<String, dynamic> values) {
    final raw = values[_schema.key]?.toString() ?? '';
    if (_controller.text != raw) {
      _controller.text = raw;
      _controller.selection = TextSelection.collapsed(
        offset: raw.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetCaptureBloc, AssetCaptureState>(
      buildWhen: (prev, curr) =>
          prev.fieldValues[_schema.key] != curr.fieldValues[_schema.key] ||
          prev.validationErrors[_schema.key] !=
              curr.validationErrors[_schema.key] ||
          prev.gpsStatus != curr.gpsStatus,
      listenWhen: (prev, curr) =>
          prev.fieldValues[_schema.key] != curr.fieldValues[_schema.key],
      listener: (context, state) {
        if (_schema.type != AssetFieldType.dropdown &&
            _schema.type != AssetFieldType.gpsCapture) {
          _syncControllerFromState(state.fieldValues);
        }
      },
      builder: (context, state) {
        if (!_controllerInitialised) {
          _controllerInitialised = true;
          _syncControllerFromState(state.fieldValues);
        }

        final error = state.validationErrors[_schema.key];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
          child: _buildField(context, state, error),
        );
      },
    );
  }

  Widget _buildField(
    BuildContext context,
    AssetCaptureState state,
    String? error,
  ) {
    return switch (_schema.type) {
      AssetFieldType.dropdown => _buildDropdown(context, state, error),
      AssetFieldType.gpsCapture => _buildGpsField(context, state),
      AssetFieldType.textarea => _buildTextArea(context, error),
      AssetFieldType.vinScanner => _buildVinField(context, error),
      AssetFieldType.number ||
      AssetFieldType.year ||
      AssetFieldType.currency =>
        _buildNumericField(context, error),
      AssetFieldType.text => _buildTextField(context, error),
    };
  }

  // ── Text ──────────────────────────────────────────────────────────────────

  Widget _buildTextField(BuildContext context, String? error) {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(error),
      textCapitalization: TextCapitalization.words,
      maxLength: _schema.maxLength,
      onChanged: (v) => _dispatch(context, v.isEmpty ? null : v),
    );
  }

  // ── Textarea ──────────────────────────────────────────────────────────────

  Widget _buildTextArea(BuildContext context, String? error) {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(error),
      maxLines: 4,
      minLines: 3,
      maxLength: _schema.maxLength ?? AppConstants.assetDescriptionMaxChars,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (v) => _dispatch(context, v.isEmpty ? null : v),
    );
  }

  // ── Numeric (number / year / currency) ───────────────────────────────────

  Widget _buildNumericField(BuildContext context, String? error) {
    final isDecimal = _schema.type == AssetFieldType.currency;
    return TextFormField(
      controller: _controller,
      decoration: _decoration(error).copyWith(
        prefixText: _schema.type == AssetFieldType.currency ? r'$ ' : null,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          isDecimal ? RegExp('[0-9.]') : RegExp('[0-9]'),
        ),
      ],
      onChanged: (v) {
        if (v.isEmpty) {
          _dispatch(context, null);
          return;
        }
        final parsed = isDecimal ? double.tryParse(v) : int.tryParse(v);
        _dispatch(context, parsed ?? v);
      },
    );
  }

  // ── Dropdown ──────────────────────────────────────────────────────────────

  Widget _buildDropdown(
    BuildContext context,
    AssetCaptureState state,
    String? error,
  ) {
    final current = state.fieldValues[_schema.key]?.toString();
    return DropdownButtonFormField<String>(
      initialValue: _schema.options.contains(current) ? current : null,
      decoration: _decoration(error),
      isExpanded: true,
      hint: Text(_schema.hint ?? 'Select\u2026'),
      items: _schema.options
          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
      onChanged: (v) => _dispatch(context, v),
    );
  }

  // ── VIN / Barcode Scanner ─────────────────────────────────────────────────

  Widget _buildVinField(BuildContext context, String? error) {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(error).copyWith(
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          tooltip: 'Scan barcode',
          onPressed: () => _openScanner(context),
        ),
      ),
      textCapitalization: TextCapitalization.characters,
      onChanged: (v) => _dispatch(context, v.isEmpty ? null : v),
    );
  }

  Future<void> _openScanner(BuildContext context) async {
    final result = await showVinScannerSheet(
      context,
      fieldLabel: _schema.label,
    );
    if (result != null && context.mounted) {
      context.read<AssetCaptureBloc>().add(
        AssetVinScanned(
          targetFieldKey: _schema.key,
          value: result,
        ),
      );
    }
  }

  // ── GPS ───────────────────────────────────────────────────────────────────

  Widget _buildGpsField(BuildContext context, AssetCaptureState state) {
    final colours = Theme.of(context).brightness == Brightness.dark
        ? AppColours.dark
        : AppColours.light;
    final isFetching = state.gpsStatus == GpsStatus.fetching;
    final address = state.locationAddress ??
        state.fieldValues[_schema.key]?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _schema.label +
              (_schema.isRequired ? '' : ' (optional)'),
          style: AppTextStyles.bodyMedium.copyWith(
            color: colours.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),

        // Manual text entry
        TextFormField(
          controller: _controller,
          decoration: _decoration(null).copyWith(
            hintText: 'Enter address or use GPS',
            suffixIcon: isFetching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.location_on_outlined),
          ),
          onChanged: (v) => _dispatch(context, v.isEmpty ? null : v),
        ),

        const SizedBox(height: AppDimensions.spacingXs),

        // GPS button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isFetching
                ? null
                : () => context
                    .read<AssetCaptureBloc>()
                    .add(const AssetGpsRequested()),
            icon: const Icon(Icons.my_location, size: AppDimensions.iconSizeSm),
            label: Text(
              address != null ? 'Update location' : 'Use My Location',
            ),
          ),
        ),

        if (state.gpsStatus == GpsStatus.error)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
            child: Text(
              'Could not get location. Please check permissions.',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  InputDecoration _decoration(String? error) => InputDecoration(
    labelText: _schema.label + (_schema.isRequired ? '' : ' (optional)'),
    hintText: _schema.hint,
    errorText: error,
  );

  void _dispatch(BuildContext context, dynamic value) {
    context.read<AssetCaptureBloc>().add(
      AssetFieldChanged(fieldKey: _schema.key, value: value),
    );
  }
}
