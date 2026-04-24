import 'package:equatable/equatable.dart';

/// The type of UI control rendered for a schema field.
enum AssetFieldType {
  text,
  number,
  year,
  dropdown,
  textarea,
  vinScanner,
  gpsCapture,
  currency,
}

/// Describes a single field in an asset submission form.
///
/// The form engine renders each field according to its [type] and
/// validates it using [isRequired], [minValue], [maxValue], and [maxLength].
final class AssetFieldSchema extends Equatable {
  const AssetFieldSchema({
    required this.key,
    required this.label,
    required this.type,
    this.isRequired = true,
    this.hint,
    this.options = const [],
    this.maxLength,
    this.minValue,
    this.maxValue,
  });

  /// Unique key used as the map key in `AssetDraft.fieldValues`.
  final String key;
  final String label;
  final AssetFieldType type;
  final bool isRequired;

  /// Helper text displayed below the field.
  final String? hint;

  /// Valid options for [AssetFieldType.dropdown].
  final List<String> options;

  /// Max character count for text fields.
  final int? maxLength;

  /// Minimum numeric value (inclusive) for number/year/currency fields.
  final num? minValue;

  /// Maximum numeric value (inclusive) for number/year/currency fields.
  final num? maxValue;

  @override
  List<Object?> get props => [
    key,
    label,
    type,
    isRequired,
    hint,
    options,
    maxLength,
    minValue,
    maxValue,
  ];
}
