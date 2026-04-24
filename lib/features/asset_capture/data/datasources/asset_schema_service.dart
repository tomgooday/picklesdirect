import 'package:flutter/material.dart';
import 'package:pickles_direct/core/constants/app_constants.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_category.dart';
import 'package:pickles_direct/features/asset_capture/domain/entities/asset_field_schema.dart';

/// Provides hardcoded asset category schemas.
///
/// This service is intentionally a pure static lookup — no DI, no async.
/// It will be replaced by a Retrofit call to `GET /schemas/{categoryKey}`
/// once the Pickles middleware OpenAPI spec is available. The AssetSchemas
/// Drift table is already set up for caching the server response.
abstract final class AssetSchemaService {
  AssetSchemaService._();

  static List<AssetCategory> get categories => [
    _earthmoving,
    _transport,
    _agriculture,
    _forklifts,
    _cranes,
    _vehicles,
    _marine,
    _other,
  ];

  static AssetCategory? categoryForKey(String key) =>
      categories.where((c) => c.key == key).firstOrNull;

  // ── Shared fields appended to every category ────────────────────────────

  static final _commonTailFields = [
    const AssetFieldSchema(
      key: 'condition',
      label: 'Condition',
      type: AssetFieldType.dropdown,
      options: ['Excellent', 'Good', 'Fair', 'Poor', 'Salvage'],
      hint: 'Overall condition of the asset',
    ),
    const AssetFieldSchema(
      key: 'description',
      label: 'Additional Details',
      type: AssetFieldType.textarea,
      isRequired: false,
      hint: 'Service history, modifications, known faults, etc.',
      maxLength: AppConstants.assetDescriptionMaxChars,
    ),
    const AssetFieldSchema(
      key: 'asking_price',
      label: 'Asking Price (AUD)',
      type: AssetFieldType.currency,
      isRequired: false,
      hint: 'Optional — leave blank if unsure',
      minValue: 0,
    ),
    const AssetFieldSchema(
      key: 'location',
      label: 'Asset Location',
      type: AssetFieldType.gpsCapture,
      hint: 'Where is the asset currently located?',
    ),
  ];

  // ── Earthmoving & Excavation ─────────────────────────────────────────────

  static final _earthmoving = AssetCategory(
    key: 'earthmoving',
    label: 'Earthmoving',
    description: 'Excavators, dozers, loaders & more',
    icon: Icons.construction,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Asset Type',
        type: AssetFieldType.dropdown,
        options: [
          'Excavator',
          'Bulldozer',
          'Front End Loader',
          'Motor Grader',
          'Compactor / Roller',
          'Scraper',
          'Backhoe Loader',
          'Skid Steer',
          'Mini Excavator',
          'Dump Truck',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. Caterpillar, Komatsu, Hitachi',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
        hint: 'e.g. 320, PC200, ZX200',
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'hours',
        label: 'Engine Hours',
        type: AssetFieldType.number,
        hint: 'Hours shown on meter',
        minValue: 0,
        maxValue: 500000,
      ),
      const AssetFieldSchema(
        key: 'serial_number',
        label: 'Serial / PIN Number',
        type: AssetFieldType.vinScanner,
        isRequired: false,
        hint: 'Scan or type the machine serial / PIN',
      ),
      const AssetFieldSchema(
        key: 'attachments',
        label: 'Attachments Included',
        type: AssetFieldType.textarea,
        isRequired: false,
        hint: 'e.g. Bucket 1200mm, Hydraulic Thumb, Ripper',
        maxLength: 300,
      ),
      ..._commonTailFields,
    ],
  );

  // ── Transport & Trucks ───────────────────────────────────────────────────

  static final _transport = AssetCategory(
    key: 'transport',
    label: 'Transport & Trucks',
    description: 'Trucks, trailers & prime movers',
    icon: Icons.local_shipping,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Asset Type',
        type: AssetFieldType.dropdown,
        options: [
          'Rigid Truck',
          'Prime Mover / Semi',
          'B-Double Prime Mover',
          'Trailer',
          'Semi-Trailer',
          'B-Double Trailer',
          'Tanker',
          'Refrigerated Truck',
          'Tipper Truck',
          'Crane Truck',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. Kenworth, Mack, Volvo, Isuzu',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'odometer_km',
        label: 'Odometer (km)',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 2000000,
      ),
      const AssetFieldSchema(
        key: 'gvm_kg',
        label: 'GVM (kg)',
        type: AssetFieldType.number,
        isRequired: false,
        hint: 'Gross Vehicle Mass',
        minValue: 0,
      ),
      const AssetFieldSchema(
        key: 'drive_config',
        label: 'Drive Configuration',
        type: AssetFieldType.dropdown,
        isRequired: false,
        options: ['4x2', '6x2', '6x4', '8x4', 'Other / N/A'],
      ),
      const AssetFieldSchema(
        key: 'transmission',
        label: 'Transmission',
        type: AssetFieldType.dropdown,
        isRequired: false,
        options: ['Automatic', 'Manual', 'Auto-Manual (AMT)', 'Other'],
      ),
      const AssetFieldSchema(
        key: 'registration',
        label: 'Registration Number',
        type: AssetFieldType.text,
        isRequired: false,
        hint: 'Current rego plate',
      ),
      const AssetFieldSchema(
        key: 'vin',
        label: 'VIN',
        type: AssetFieldType.vinScanner,
        isRequired: false,
        hint: 'Scan barcode or type 17-character VIN',
      ),
      ..._commonTailFields,
    ],
  );

  // ── Agriculture & Farming ────────────────────────────────────────────────

  static final _agriculture = AssetCategory(
    key: 'agriculture',
    label: 'Agriculture',
    description: 'Tractors, harvesters & implements',
    icon: Icons.agriculture,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Asset Type',
        type: AssetFieldType.dropdown,
        options: [
          'Tractor',
          'Harvester / Header',
          'Sprayer',
          'Planter / Seeder',
          'Baler',
          'Tillage Equipment',
          'Hay Equipment',
          'Irrigation Equipment',
          'Header Front',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. John Deere, New Holland, Case IH',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'hours',
        label: 'Engine Hours',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 500000,
      ),
      const AssetFieldSchema(
        key: 'pto_hp',
        label: 'PTO Horsepower',
        type: AssetFieldType.number,
        isRequired: false,
        hint: 'Power Take-Off output in HP',
        minValue: 0,
        maxValue: 1000,
      ),
      const AssetFieldSchema(
        key: 'serial_number',
        label: 'Serial Number',
        type: AssetFieldType.vinScanner,
        isRequired: false,
        hint: 'Scan or type the serial number',
      ),
      const AssetFieldSchema(
        key: 'attachments',
        label: 'Attachments / Implements',
        type: AssetFieldType.textarea,
        isRequired: false,
        hint: 'List any implements or attachments included',
        maxLength: 300,
      ),
      ..._commonTailFields,
    ],
  );

  // ── Forklifts & Warehouse ────────────────────────────────────────────────

  static final _forklifts = AssetCategory(
    key: 'forklifts',
    label: 'Forklifts',
    description: 'Counterbalance, reach & rough terrain',
    icon: Icons.forklift,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Asset Type',
        type: AssetFieldType.dropdown,
        options: [
          'Counterbalance Forklift',
          'Reach Truck',
          'Rough Terrain Forklift',
          'Order Picker',
          'Pallet Jack / Walkie Stacker',
          'Telehandler / Telescopic',
          'Side Loader',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. Toyota, Crown, Linde, Yale',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'capacity_kg',
        label: 'Lift Capacity (kg)',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 100000,
      ),
      const AssetFieldSchema(
        key: 'lift_height_mm',
        label: 'Lift Height (mm)',
        type: AssetFieldType.number,
        isRequired: false,
        minValue: 0,
        maxValue: 20000,
      ),
      const AssetFieldSchema(
        key: 'fuel_type',
        label: 'Fuel / Power Type',
        type: AssetFieldType.dropdown,
        options: ['Electric (Battery)', 'LPG', 'Diesel', 'Petrol', 'Dual Fuel'],
      ),
      const AssetFieldSchema(
        key: 'hours',
        label: 'Hours',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 500000,
      ),
      const AssetFieldSchema(
        key: 'mast_type',
        label: 'Mast Type',
        type: AssetFieldType.dropdown,
        isRequired: false,
        options: ['Simplex', 'Duplex', 'Triplex', 'Quad', 'Other / N/A'],
      ),
      const AssetFieldSchema(
        key: 'serial_number',
        label: 'Serial Number',
        type: AssetFieldType.vinScanner,
        isRequired: false,
        hint: 'Scan or type the serial number',
      ),
      ..._commonTailFields,
    ],
  );

  // ── Cranes & Lifting Equipment ───────────────────────────────────────────

  static final _cranes = AssetCategory(
    key: 'cranes',
    label: 'Cranes & Lifting',
    description: 'Mobile cranes, boom lifts & EWPs',
    icon: Icons.engineering,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Asset Type',
        type: AssetFieldType.dropdown,
        options: [
          'Mobile Crane',
          'Tower Crane',
          'Crawler Crane',
          'Pick & Carry Crane',
          'Boom Lift / EWP',
          'Scissor Lift',
          'Knuckle Boom Crane',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. Liebherr, Tadano, Manitowoc',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'capacity_tonne',
        label: 'Lifting Capacity (tonne)',
        type: AssetFieldType.number,
        isRequired: false,
        minValue: 0,
        maxValue: 5000,
      ),
      const AssetFieldSchema(
        key: 'boom_length_m',
        label: 'Boom Length (m)',
        type: AssetFieldType.number,
        isRequired: false,
        minValue: 0,
        maxValue: 500,
      ),
      const AssetFieldSchema(
        key: 'hours',
        label: 'Engine Hours',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 500000,
      ),
      const AssetFieldSchema(
        key: 'registration',
        label: 'Registration Number',
        type: AssetFieldType.text,
        isRequired: false,
      ),
      const AssetFieldSchema(
        key: 'serial_number',
        label: 'Serial Number',
        type: AssetFieldType.vinScanner,
        isRequired: false,
      ),
      ..._commonTailFields,
    ],
  );

  // ── Cars & Light Commercial ──────────────────────────────────────────────

  static final _vehicles = AssetCategory(
    key: 'vehicles',
    label: 'Cars & Light Commercial',
    description: 'Passenger, SUV, ute & van',
    icon: Icons.directions_car,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Vehicle Type',
        type: AssetFieldType.dropdown,
        options: [
          'Passenger Car',
          'SUV / 4WD',
          'Utility / Ute',
          'Van',
          'Light Truck / Cab-Chassis',
          'Minibus',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. Toyota, Ford, Holden',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'odometer_km',
        label: 'Odometer (km)',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 2000000,
      ),
      const AssetFieldSchema(
        key: 'fuel_type',
        label: 'Fuel Type',
        type: AssetFieldType.dropdown,
        options: [
          'Petrol',
          'Diesel',
          'Hybrid',
          'Electric',
          'LPG / CNG',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'transmission',
        label: 'Transmission',
        type: AssetFieldType.dropdown,
        options: ['Automatic', 'Manual', 'CVT', 'Other'],
      ),
      const AssetFieldSchema(
        key: 'drive_type',
        label: 'Drive Type',
        type: AssetFieldType.dropdown,
        isRequired: false,
        options: ['2WD (FWD)', '2WD (RWD)', '4WD / AWD'],
      ),
      const AssetFieldSchema(
        key: 'colour',
        label: 'Colour',
        type: AssetFieldType.text,
        isRequired: false,
      ),
      const AssetFieldSchema(
        key: 'registration',
        label: 'Registration Number',
        type: AssetFieldType.text,
        isRequired: false,
      ),
      const AssetFieldSchema(
        key: 'vin',
        label: 'VIN',
        type: AssetFieldType.vinScanner,
        isRequired: false,
        hint: 'Scan barcode or type 17-character VIN',
      ),
      ..._commonTailFields,
    ],
  );

  // ── Marine & Watercraft ──────────────────────────────────────────────────

  static final _marine = AssetCategory(
    key: 'marine',
    label: 'Marine',
    description: 'Boats, vessels & jet skis',
    icon: Icons.directions_boat,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'Vessel Type',
        type: AssetFieldType.dropdown,
        options: [
          'Recreational Boat',
          'Commercial Vessel',
          'Jet Ski / PWC',
          'Pontoon',
          'Sailing Boat',
          'Aluminium Tinnie',
          'Fibreglass Runabout',
          'Other',
        ],
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make',
        type: AssetFieldType.text,
        hint: 'e.g. Quintrex, Stacer, Seafarer',
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'length_m',
        label: 'Length (m)',
        type: AssetFieldType.number,
        minValue: 0,
        maxValue: 200,
      ),
      const AssetFieldSchema(
        key: 'hull_material',
        label: 'Hull Material',
        type: AssetFieldType.dropdown,
        isRequired: false,
        options: ['Fibreglass', 'Aluminium', 'Steel', 'Timber', 'Other'],
      ),
      const AssetFieldSchema(
        key: 'engine_type',
        label: 'Engine / Propulsion',
        type: AssetFieldType.dropdown,
        isRequired: false,
        options: [
          'Outboard',
          'Inboard',
          'Sterndrive / I/O',
          'Jet Drive',
          'Sail / Auxiliary',
          'Electric',
        ],
      ),
      const AssetFieldSchema(
        key: 'engine_hp',
        label: 'Engine Power (HP)',
        type: AssetFieldType.number,
        isRequired: false,
        minValue: 0,
        maxValue: 3000,
      ),
      const AssetFieldSchema(
        key: 'hours',
        label: 'Engine Hours',
        type: AssetFieldType.number,
        isRequired: false,
        minValue: 0,
        maxValue: 100000,
      ),
      const AssetFieldSchema(
        key: 'registration',
        label: 'Vessel Registration',
        type: AssetFieldType.text,
        isRequired: false,
      ),
      const AssetFieldSchema(
        key: 'serial_number',
        label: 'Hull Identification Number (HIN)',
        type: AssetFieldType.vinScanner,
        isRequired: false,
      ),
      ..._commonTailFields,
    ],
  );

  // ── Other Equipment ──────────────────────────────────────────────────────

  static final _other = AssetCategory(
    key: 'other',
    label: 'Other Equipment',
    description: 'Generators, pumps & miscellaneous',
    icon: Icons.settings,
    fields: [
      const AssetFieldSchema(
        key: 'asset_type',
        label: 'What type of equipment is it?',
        type: AssetFieldType.text,
        hint: 'e.g. Generator, Air Compressor, Pump, Mining Equipment',
      ),
      const AssetFieldSchema(
        key: 'make',
        label: 'Make / Manufacturer',
        type: AssetFieldType.text,
      ),
      const AssetFieldSchema(
        key: 'model',
        label: 'Model',
        type: AssetFieldType.text,
      ),
      AssetFieldSchema(
        key: 'year',
        label: 'Year of Manufacture',
        type: AssetFieldType.year,
        isRequired: false,
        minValue: AppConstants.manufactureYearMin.toDouble(),
        maxValue: DateTime.now().year.toDouble(),
      ),
      const AssetFieldSchema(
        key: 'hours',
        label: 'Hours / Usage Meter',
        type: AssetFieldType.number,
        isRequired: false,
        minValue: 0,
        maxValue: 999999,
      ),
      const AssetFieldSchema(
        key: 'serial_number',
        label: 'Serial Number',
        type: AssetFieldType.vinScanner,
        isRequired: false,
      ),
      ..._commonTailFields,
    ],
  );
}
