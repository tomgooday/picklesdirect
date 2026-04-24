import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_field_schema.dart';

/// A top-level asset category shown on the category selection screen.
///
/// Each category maps to an ordered list of field schemas that drive the form
/// on AssetFormPage. The schema is currently hardcoded in AssetSchemaService
/// and will be replaced by a server-fetched version once the middleware
/// OpenAPI spec is available.
final class AssetCategory extends Equatable {
  const AssetCategory({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.fields,
  });

  /// Stable identifier used as the URL path parameter and Drift `assetCategory`.
  final String key;
  final String label;

  /// Short descriptor shown on the category card.
  final String description;
  final IconData icon;

  /// Ordered list of fields rendered in the form.
  final List<AssetFieldSchema> fields;

  @override
  List<Object?> get props => [key, label, description, fields];
}
