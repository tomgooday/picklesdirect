import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A labelled shot category shown in the category-assignment bottom sheet.
///
/// Required categories must be filled before the submission can proceed.
/// The minimum photo count is enforced separately via AppConstants.photoMinCount.
final class PhotoCategory extends Equatable {
  const PhotoCategory({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
    this.isRequired = false,
  });

  final String key;
  final String label;

  /// Helper text shown in the category picker.
  final String description;
  final IconData icon;

  /// If true, at least one photo in this category is mandatory.
  final bool isRequired;

  @override
  List<Object?> get props => [key, label, isRequired];
}

/// Canonical photo categories for all asset types.
///
/// The five required categories ensure every submission includes
/// all-round exterior views and the serial/identification plate.
/// Optional categories capture additional detail relevant to specific
/// asset types. Replace with server-fetched categories once the middleware
/// schema endpoint is available.
abstract final class PhotoCategories {
  PhotoCategories._();

  static const overviewFront = PhotoCategory(
    key: 'overview_front',
    label: 'Front View',
    description: 'Full front of the asset on level ground',
    icon: Icons.photo_camera_front,
    isRequired: true,
  );

  static const overviewRear = PhotoCategory(
    key: 'overview_rear',
    label: 'Rear View',
    description: 'Full rear of the asset',
    icon: Icons.flip_camera_android,
    isRequired: true,
  );

  static const overviewLeft = PhotoCategory(
    key: 'overview_left',
    label: 'Left Side',
    description: 'Full left-hand side',
    icon: Icons.chevron_left,
    isRequired: true,
  );

  static const overviewRight = PhotoCategory(
    key: 'overview_right',
    label: 'Right Side',
    description: 'Full right-hand side',
    icon: Icons.chevron_right,
    isRequired: true,
  );

  static const serialPlate = PhotoCategory(
    key: 'serial_plate',
    label: 'Serial / ID Plate',
    description: 'Manufacturer plate showing serial number and model',
    icon: Icons.badge,
    isRequired: true,
  );

  static const hoursMeter = PhotoCategory(
    key: 'hours_meter',
    label: 'Hours / Odometer',
    description: 'Instrument panel showing current hours or km reading',
    icon: Icons.speed,
  );

  static const engineDetail = PhotoCategory(
    key: 'engine_detail',
    label: 'Engine / Motor',
    description: 'Engine bay or motor compartment',
    icon: Icons.settings,
  );

  static const interiorCab = PhotoCategory(
    key: 'interior_cab',
    label: 'Interior / Cab',
    description: 'Inside cab, seat, controls, and dash',
    icon: Icons.airline_seat_recline_normal,
  );

  static const damageDefect = PhotoCategory(
    key: 'damage_defect',
    label: 'Damage / Defects',
    description: 'Any visible damage, wear, or defects',
    icon: Icons.warning_amber,
  );

  static const attachmentDetail = PhotoCategory(
    key: 'attachment_detail',
    label: 'Attachment Detail',
    description: 'Close-up of buckets, blades, forks, or other attachments',
    icon: Icons.construction,
  );

  static const additional = PhotoCategory(
    key: 'additional',
    label: 'Additional',
    description: 'Any other relevant views',
    icon: Icons.add_photo_alternate,
  );

  static const List<PhotoCategory> all = [
    overviewFront,
    overviewRear,
    overviewLeft,
    overviewRight,
    serialPlate,
    hoursMeter,
    engineDetail,
    interiorCab,
    damageDefect,
    attachmentDetail,
    additional,
  ];

  static const List<PhotoCategory> required = [
    overviewFront,
    overviewRear,
    overviewLeft,
    overviewRight,
    serialPlate,
  ];

  static PhotoCategory? forKey(String key) =>
      all.where((c) => c.key == key).firstOrNull;
}
