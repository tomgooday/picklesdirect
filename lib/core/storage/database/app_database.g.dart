// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubmissionDraftsTable extends SubmissionDrafts
    with TableInfo<$SubmissionDraftsTable, SubmissionDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetPayloadEncryptedMeta =
      const VerificationMeta('assetPayloadEncrypted');
  @override
  late final GeneratedColumn<String> assetPayloadEncrypted =
      GeneratedColumn<String>(
        'asset_payload_encrypted',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _assetCategoryMeta = const VerificationMeta(
    'assetCategory',
  );
  @override
  late final GeneratedColumn<String> assetCategory = GeneratedColumn<String>(
    'asset_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetLabelMeta = const VerificationMeta(
    'assetLabel',
  );
  @override
  late final GeneratedColumn<String> assetLabel = GeneratedColumn<String>(
    'asset_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gpsLatMeta = const VerificationMeta('gpsLat');
  @override
  late final GeneratedColumn<double> gpsLat = GeneratedColumn<double>(
    'gps_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpsLngMeta = const VerificationMeta('gpsLng');
  @override
  late final GeneratedColumn<double> gpsLng = GeneratedColumn<double>(
    'gps_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoCountMeta = const VerificationMeta(
    'photoCount',
  );
  @override
  late final GeneratedColumn<int> photoCount = GeneratedColumn<int>(
    'photo_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    status,
    assetPayloadEncrypted,
    assetCategory,
    assetLabel,
    gpsLat,
    gpsLng,
    photoCount,
    retryCount,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmissionDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('asset_payload_encrypted')) {
      context.handle(
        _assetPayloadEncryptedMeta,
        assetPayloadEncrypted.isAcceptableOrUnknown(
          data['asset_payload_encrypted']!,
          _assetPayloadEncryptedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetPayloadEncryptedMeta);
    }
    if (data.containsKey('asset_category')) {
      context.handle(
        _assetCategoryMeta,
        assetCategory.isAcceptableOrUnknown(
          data['asset_category']!,
          _assetCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetCategoryMeta);
    }
    if (data.containsKey('asset_label')) {
      context.handle(
        _assetLabelMeta,
        assetLabel.isAcceptableOrUnknown(data['asset_label']!, _assetLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_assetLabelMeta);
    }
    if (data.containsKey('gps_lat')) {
      context.handle(
        _gpsLatMeta,
        gpsLat.isAcceptableOrUnknown(data['gps_lat']!, _gpsLatMeta),
      );
    }
    if (data.containsKey('gps_lng')) {
      context.handle(
        _gpsLngMeta,
        gpsLng.isAcceptableOrUnknown(data['gps_lng']!, _gpsLngMeta),
      );
    }
    if (data.containsKey('photo_count')) {
      context.handle(
        _photoCountMeta,
        photoCount.isAcceptableOrUnknown(data['photo_count']!, _photoCountMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubmissionDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionDraft(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      assetPayloadEncrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_payload_encrypted'],
      )!,
      assetCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_category'],
      )!,
      assetLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_label'],
      )!,
      gpsLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_lat'],
      ),
      gpsLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_lng'],
      ),
      photoCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}photo_count'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SubmissionDraftsTable createAlias(String alias) {
    return $SubmissionDraftsTable(attachedDatabase, alias);
  }
}

class SubmissionDraft extends DataClass implements Insertable<SubmissionDraft> {
  final String id;
  final String vendorId;

  /// SubmissionStatus enum value stored as string.
  final String status;

  /// JSON-encoded asset payload (encrypted).
  final String assetPayloadEncrypted;

  /// Asset category key, e.g. "vehicles" | "industrial".
  final String assetCategory;

  /// Human-readable asset label for list display.
  final String assetLabel;
  final double? gpsLat;
  final double? gpsLng;
  final int photoCount;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const SubmissionDraft({
    required this.id,
    required this.vendorId,
    required this.status,
    required this.assetPayloadEncrypted,
    required this.assetCategory,
    required this.assetLabel,
    this.gpsLat,
    this.gpsLng,
    required this.photoCount,
    required this.retryCount,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vendor_id'] = Variable<String>(vendorId);
    map['status'] = Variable<String>(status);
    map['asset_payload_encrypted'] = Variable<String>(assetPayloadEncrypted);
    map['asset_category'] = Variable<String>(assetCategory);
    map['asset_label'] = Variable<String>(assetLabel);
    if (!nullToAbsent || gpsLat != null) {
      map['gps_lat'] = Variable<double>(gpsLat);
    }
    if (!nullToAbsent || gpsLng != null) {
      map['gps_lng'] = Variable<double>(gpsLng);
    }
    map['photo_count'] = Variable<int>(photoCount);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SubmissionDraftsCompanion toCompanion(bool nullToAbsent) {
    return SubmissionDraftsCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      status: Value(status),
      assetPayloadEncrypted: Value(assetPayloadEncrypted),
      assetCategory: Value(assetCategory),
      assetLabel: Value(assetLabel),
      gpsLat: gpsLat == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsLat),
      gpsLng: gpsLng == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsLng),
      photoCount: Value(photoCount),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SubmissionDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionDraft(
      id: serializer.fromJson<String>(json['id']),
      vendorId: serializer.fromJson<String>(json['vendorId']),
      status: serializer.fromJson<String>(json['status']),
      assetPayloadEncrypted: serializer.fromJson<String>(
        json['assetPayloadEncrypted'],
      ),
      assetCategory: serializer.fromJson<String>(json['assetCategory']),
      assetLabel: serializer.fromJson<String>(json['assetLabel']),
      gpsLat: serializer.fromJson<double?>(json['gpsLat']),
      gpsLng: serializer.fromJson<double?>(json['gpsLng']),
      photoCount: serializer.fromJson<int>(json['photoCount']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vendorId': serializer.toJson<String>(vendorId),
      'status': serializer.toJson<String>(status),
      'assetPayloadEncrypted': serializer.toJson<String>(assetPayloadEncrypted),
      'assetCategory': serializer.toJson<String>(assetCategory),
      'assetLabel': serializer.toJson<String>(assetLabel),
      'gpsLat': serializer.toJson<double?>(gpsLat),
      'gpsLng': serializer.toJson<double?>(gpsLng),
      'photoCount': serializer.toJson<int>(photoCount),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SubmissionDraft copyWith({
    String? id,
    String? vendorId,
    String? status,
    String? assetPayloadEncrypted,
    String? assetCategory,
    String? assetLabel,
    Value<double?> gpsLat = const Value.absent(),
    Value<double?> gpsLng = const Value.absent(),
    int? photoCount,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SubmissionDraft(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    status: status ?? this.status,
    assetPayloadEncrypted: assetPayloadEncrypted ?? this.assetPayloadEncrypted,
    assetCategory: assetCategory ?? this.assetCategory,
    assetLabel: assetLabel ?? this.assetLabel,
    gpsLat: gpsLat.present ? gpsLat.value : this.gpsLat,
    gpsLng: gpsLng.present ? gpsLng.value : this.gpsLng,
    photoCount: photoCount ?? this.photoCount,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SubmissionDraft copyWithCompanion(SubmissionDraftsCompanion data) {
    return SubmissionDraft(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      status: data.status.present ? data.status.value : this.status,
      assetPayloadEncrypted: data.assetPayloadEncrypted.present
          ? data.assetPayloadEncrypted.value
          : this.assetPayloadEncrypted,
      assetCategory: data.assetCategory.present
          ? data.assetCategory.value
          : this.assetCategory,
      assetLabel: data.assetLabel.present
          ? data.assetLabel.value
          : this.assetLabel,
      gpsLat: data.gpsLat.present ? data.gpsLat.value : this.gpsLat,
      gpsLng: data.gpsLng.present ? data.gpsLng.value : this.gpsLng,
      photoCount: data.photoCount.present
          ? data.photoCount.value
          : this.photoCount,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionDraft(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('status: $status, ')
          ..write('assetPayloadEncrypted: $assetPayloadEncrypted, ')
          ..write('assetCategory: $assetCategory, ')
          ..write('assetLabel: $assetLabel, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('photoCount: $photoCount, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vendorId,
    status,
    assetPayloadEncrypted,
    assetCategory,
    assetLabel,
    gpsLat,
    gpsLng,
    photoCount,
    retryCount,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionDraft &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.status == this.status &&
          other.assetPayloadEncrypted == this.assetPayloadEncrypted &&
          other.assetCategory == this.assetCategory &&
          other.assetLabel == this.assetLabel &&
          other.gpsLat == this.gpsLat &&
          other.gpsLng == this.gpsLng &&
          other.photoCount == this.photoCount &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class SubmissionDraftsCompanion extends UpdateCompanion<SubmissionDraft> {
  final Value<String> id;
  final Value<String> vendorId;
  final Value<String> status;
  final Value<String> assetPayloadEncrypted;
  final Value<String> assetCategory;
  final Value<String> assetLabel;
  final Value<double?> gpsLat;
  final Value<double?> gpsLng;
  final Value<int> photoCount;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SubmissionDraftsCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.status = const Value.absent(),
    this.assetPayloadEncrypted = const Value.absent(),
    this.assetCategory = const Value.absent(),
    this.assetLabel = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.photoCount = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubmissionDraftsCompanion.insert({
    required String id,
    required String vendorId,
    required String status,
    required String assetPayloadEncrypted,
    required String assetCategory,
    required String assetLabel,
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.photoCount = const Value.absent(),
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vendorId = Value(vendorId),
       status = Value(status),
       assetPayloadEncrypted = Value(assetPayloadEncrypted),
       assetCategory = Value(assetCategory),
       assetLabel = Value(assetLabel),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SubmissionDraft> custom({
    Expression<String>? id,
    Expression<String>? vendorId,
    Expression<String>? status,
    Expression<String>? assetPayloadEncrypted,
    Expression<String>? assetCategory,
    Expression<String>? assetLabel,
    Expression<double>? gpsLat,
    Expression<double>? gpsLng,
    Expression<int>? photoCount,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (status != null) 'status': status,
      if (assetPayloadEncrypted != null)
        'asset_payload_encrypted': assetPayloadEncrypted,
      if (assetCategory != null) 'asset_category': assetCategory,
      if (assetLabel != null) 'asset_label': assetLabel,
      if (gpsLat != null) 'gps_lat': gpsLat,
      if (gpsLng != null) 'gps_lng': gpsLng,
      if (photoCount != null) 'photo_count': photoCount,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubmissionDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? vendorId,
    Value<String>? status,
    Value<String>? assetPayloadEncrypted,
    Value<String>? assetCategory,
    Value<String>? assetLabel,
    Value<double?>? gpsLat,
    Value<double?>? gpsLng,
    Value<int>? photoCount,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SubmissionDraftsCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      status: status ?? this.status,
      assetPayloadEncrypted:
          assetPayloadEncrypted ?? this.assetPayloadEncrypted,
      assetCategory: assetCategory ?? this.assetCategory,
      assetLabel: assetLabel ?? this.assetLabel,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      photoCount: photoCount ?? this.photoCount,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assetPayloadEncrypted.present) {
      map['asset_payload_encrypted'] = Variable<String>(
        assetPayloadEncrypted.value,
      );
    }
    if (assetCategory.present) {
      map['asset_category'] = Variable<String>(assetCategory.value);
    }
    if (assetLabel.present) {
      map['asset_label'] = Variable<String>(assetLabel.value);
    }
    if (gpsLat.present) {
      map['gps_lat'] = Variable<double>(gpsLat.value);
    }
    if (gpsLng.present) {
      map['gps_lng'] = Variable<double>(gpsLng.value);
    }
    if (photoCount.present) {
      map['photo_count'] = Variable<int>(photoCount.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionDraftsCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('status: $status, ')
          ..write('assetPayloadEncrypted: $assetPayloadEncrypted, ')
          ..write('assetCategory: $assetCategory, ')
          ..write('assetLabel: $assetLabel, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('photoCount: $photoCount, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubmissionPhotosTable extends SubmissionPhotos
    with TableInfo<$SubmissionPhotosTable, SubmissionPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submissionIdMeta = const VerificationMeta(
    'submissionId',
  );
  @override
  late final GeneratedColumn<String> submissionId = GeneratedColumn<String>(
    'submission_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES submission_drafts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryKeyMeta = const VerificationMeta(
    'categoryKey',
  );
  @override
  late final GeneratedColumn<String> categoryKey = GeneratedColumn<String>(
    'category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalFilenameMeta = const VerificationMeta(
    'originalFilename',
  );
  @override
  late final GeneratedColumn<String> originalFilename = GeneratedColumn<String>(
    'original_filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthPxMeta = const VerificationMeta(
    'widthPx',
  );
  @override
  late final GeneratedColumn<int> widthPx = GeneratedColumn<int>(
    'width_px',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightPxMeta = const VerificationMeta(
    'heightPx',
  );
  @override
  late final GeneratedColumn<int> heightPx = GeneratedColumn<int>(
    'height_px',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gpsLatMeta = const VerificationMeta('gpsLat');
  @override
  late final GeneratedColumn<double> gpsLat = GeneratedColumn<double>(
    'gps_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpsLngMeta = const VerificationMeta('gpsLng');
  @override
  late final GeneratedColumn<double> gpsLng = GeneratedColumn<double>(
    'gps_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    submissionId,
    categoryKey,
    localPath,
    originalFilename,
    fileSizeBytes,
    widthPx,
    heightPx,
    gpsLat,
    gpsLng,
    sortOrder,
    capturedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmissionPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('submission_id')) {
      context.handle(
        _submissionIdMeta,
        submissionId.isAcceptableOrUnknown(
          data['submission_id']!,
          _submissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submissionIdMeta);
    }
    if (data.containsKey('category_key')) {
      context.handle(
        _categoryKeyMeta,
        categoryKey.isAcceptableOrUnknown(
          data['category_key']!,
          _categoryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryKeyMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('original_filename')) {
      context.handle(
        _originalFilenameMeta,
        originalFilename.isAcceptableOrUnknown(
          data['original_filename']!,
          _originalFilenameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalFilenameMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fileSizeBytesMeta);
    }
    if (data.containsKey('width_px')) {
      context.handle(
        _widthPxMeta,
        widthPx.isAcceptableOrUnknown(data['width_px']!, _widthPxMeta),
      );
    } else if (isInserting) {
      context.missing(_widthPxMeta);
    }
    if (data.containsKey('height_px')) {
      context.handle(
        _heightPxMeta,
        heightPx.isAcceptableOrUnknown(data['height_px']!, _heightPxMeta),
      );
    } else if (isInserting) {
      context.missing(_heightPxMeta);
    }
    if (data.containsKey('gps_lat')) {
      context.handle(
        _gpsLatMeta,
        gpsLat.isAcceptableOrUnknown(data['gps_lat']!, _gpsLatMeta),
      );
    }
    if (data.containsKey('gps_lng')) {
      context.handle(
        _gpsLngMeta,
        gpsLng.isAcceptableOrUnknown(data['gps_lng']!, _gpsLngMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubmissionPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      submissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_id'],
      )!,
      categoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_key'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      originalFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_filename'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      widthPx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width_px'],
      )!,
      heightPx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_px'],
      )!,
      gpsLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_lat'],
      ),
      gpsLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_lng'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
    );
  }

  @override
  $SubmissionPhotosTable createAlias(String alias) {
    return $SubmissionPhotosTable(attachedDatabase, alias);
  }
}

class SubmissionPhoto extends DataClass implements Insertable<SubmissionPhoto> {
  final String id;
  final String submissionId;

  /// Photo category key, e.g. "overview_front" | "serial_plate".
  final String categoryKey;

  /// Absolute path to the compressed JPEG on device storage.
  final String localPath;

  /// Original filename before compression.
  final String originalFilename;
  final int fileSizeBytes;
  final int widthPx;
  final int heightPx;
  final double? gpsLat;
  final double? gpsLng;
  final int sortOrder;
  final DateTime capturedAt;
  const SubmissionPhoto({
    required this.id,
    required this.submissionId,
    required this.categoryKey,
    required this.localPath,
    required this.originalFilename,
    required this.fileSizeBytes,
    required this.widthPx,
    required this.heightPx,
    this.gpsLat,
    this.gpsLng,
    required this.sortOrder,
    required this.capturedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['submission_id'] = Variable<String>(submissionId);
    map['category_key'] = Variable<String>(categoryKey);
    map['local_path'] = Variable<String>(localPath);
    map['original_filename'] = Variable<String>(originalFilename);
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['width_px'] = Variable<int>(widthPx);
    map['height_px'] = Variable<int>(heightPx);
    if (!nullToAbsent || gpsLat != null) {
      map['gps_lat'] = Variable<double>(gpsLat);
    }
    if (!nullToAbsent || gpsLng != null) {
      map['gps_lng'] = Variable<double>(gpsLng);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    return map;
  }

  SubmissionPhotosCompanion toCompanion(bool nullToAbsent) {
    return SubmissionPhotosCompanion(
      id: Value(id),
      submissionId: Value(submissionId),
      categoryKey: Value(categoryKey),
      localPath: Value(localPath),
      originalFilename: Value(originalFilename),
      fileSizeBytes: Value(fileSizeBytes),
      widthPx: Value(widthPx),
      heightPx: Value(heightPx),
      gpsLat: gpsLat == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsLat),
      gpsLng: gpsLng == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsLng),
      sortOrder: Value(sortOrder),
      capturedAt: Value(capturedAt),
    );
  }

  factory SubmissionPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionPhoto(
      id: serializer.fromJson<String>(json['id']),
      submissionId: serializer.fromJson<String>(json['submissionId']),
      categoryKey: serializer.fromJson<String>(json['categoryKey']),
      localPath: serializer.fromJson<String>(json['localPath']),
      originalFilename: serializer.fromJson<String>(json['originalFilename']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      widthPx: serializer.fromJson<int>(json['widthPx']),
      heightPx: serializer.fromJson<int>(json['heightPx']),
      gpsLat: serializer.fromJson<double?>(json['gpsLat']),
      gpsLng: serializer.fromJson<double?>(json['gpsLng']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'submissionId': serializer.toJson<String>(submissionId),
      'categoryKey': serializer.toJson<String>(categoryKey),
      'localPath': serializer.toJson<String>(localPath),
      'originalFilename': serializer.toJson<String>(originalFilename),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'widthPx': serializer.toJson<int>(widthPx),
      'heightPx': serializer.toJson<int>(heightPx),
      'gpsLat': serializer.toJson<double?>(gpsLat),
      'gpsLng': serializer.toJson<double?>(gpsLng),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
    };
  }

  SubmissionPhoto copyWith({
    String? id,
    String? submissionId,
    String? categoryKey,
    String? localPath,
    String? originalFilename,
    int? fileSizeBytes,
    int? widthPx,
    int? heightPx,
    Value<double?> gpsLat = const Value.absent(),
    Value<double?> gpsLng = const Value.absent(),
    int? sortOrder,
    DateTime? capturedAt,
  }) => SubmissionPhoto(
    id: id ?? this.id,
    submissionId: submissionId ?? this.submissionId,
    categoryKey: categoryKey ?? this.categoryKey,
    localPath: localPath ?? this.localPath,
    originalFilename: originalFilename ?? this.originalFilename,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    widthPx: widthPx ?? this.widthPx,
    heightPx: heightPx ?? this.heightPx,
    gpsLat: gpsLat.present ? gpsLat.value : this.gpsLat,
    gpsLng: gpsLng.present ? gpsLng.value : this.gpsLng,
    sortOrder: sortOrder ?? this.sortOrder,
    capturedAt: capturedAt ?? this.capturedAt,
  );
  SubmissionPhoto copyWithCompanion(SubmissionPhotosCompanion data) {
    return SubmissionPhoto(
      id: data.id.present ? data.id.value : this.id,
      submissionId: data.submissionId.present
          ? data.submissionId.value
          : this.submissionId,
      categoryKey: data.categoryKey.present
          ? data.categoryKey.value
          : this.categoryKey,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      originalFilename: data.originalFilename.present
          ? data.originalFilename.value
          : this.originalFilename,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      widthPx: data.widthPx.present ? data.widthPx.value : this.widthPx,
      heightPx: data.heightPx.present ? data.heightPx.value : this.heightPx,
      gpsLat: data.gpsLat.present ? data.gpsLat.value : this.gpsLat,
      gpsLng: data.gpsLng.present ? data.gpsLng.value : this.gpsLng,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionPhoto(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('localPath: $localPath, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('widthPx: $widthPx, ')
          ..write('heightPx: $heightPx, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    submissionId,
    categoryKey,
    localPath,
    originalFilename,
    fileSizeBytes,
    widthPx,
    heightPx,
    gpsLat,
    gpsLng,
    sortOrder,
    capturedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionPhoto &&
          other.id == this.id &&
          other.submissionId == this.submissionId &&
          other.categoryKey == this.categoryKey &&
          other.localPath == this.localPath &&
          other.originalFilename == this.originalFilename &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.widthPx == this.widthPx &&
          other.heightPx == this.heightPx &&
          other.gpsLat == this.gpsLat &&
          other.gpsLng == this.gpsLng &&
          other.sortOrder == this.sortOrder &&
          other.capturedAt == this.capturedAt);
}

class SubmissionPhotosCompanion extends UpdateCompanion<SubmissionPhoto> {
  final Value<String> id;
  final Value<String> submissionId;
  final Value<String> categoryKey;
  final Value<String> localPath;
  final Value<String> originalFilename;
  final Value<int> fileSizeBytes;
  final Value<int> widthPx;
  final Value<int> heightPx;
  final Value<double?> gpsLat;
  final Value<double?> gpsLng;
  final Value<int> sortOrder;
  final Value<DateTime> capturedAt;
  final Value<int> rowid;
  const SubmissionPhotosCompanion({
    this.id = const Value.absent(),
    this.submissionId = const Value.absent(),
    this.categoryKey = const Value.absent(),
    this.localPath = const Value.absent(),
    this.originalFilename = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.widthPx = const Value.absent(),
    this.heightPx = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubmissionPhotosCompanion.insert({
    required String id,
    required String submissionId,
    required String categoryKey,
    required String localPath,
    required String originalFilename,
    required int fileSizeBytes,
    required int widthPx,
    required int heightPx,
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime capturedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       submissionId = Value(submissionId),
       categoryKey = Value(categoryKey),
       localPath = Value(localPath),
       originalFilename = Value(originalFilename),
       fileSizeBytes = Value(fileSizeBytes),
       widthPx = Value(widthPx),
       heightPx = Value(heightPx),
       capturedAt = Value(capturedAt);
  static Insertable<SubmissionPhoto> custom({
    Expression<String>? id,
    Expression<String>? submissionId,
    Expression<String>? categoryKey,
    Expression<String>? localPath,
    Expression<String>? originalFilename,
    Expression<int>? fileSizeBytes,
    Expression<int>? widthPx,
    Expression<int>? heightPx,
    Expression<double>? gpsLat,
    Expression<double>? gpsLng,
    Expression<int>? sortOrder,
    Expression<DateTime>? capturedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (submissionId != null) 'submission_id': submissionId,
      if (categoryKey != null) 'category_key': categoryKey,
      if (localPath != null) 'local_path': localPath,
      if (originalFilename != null) 'original_filename': originalFilename,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (widthPx != null) 'width_px': widthPx,
      if (heightPx != null) 'height_px': heightPx,
      if (gpsLat != null) 'gps_lat': gpsLat,
      if (gpsLng != null) 'gps_lng': gpsLng,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubmissionPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? submissionId,
    Value<String>? categoryKey,
    Value<String>? localPath,
    Value<String>? originalFilename,
    Value<int>? fileSizeBytes,
    Value<int>? widthPx,
    Value<int>? heightPx,
    Value<double?>? gpsLat,
    Value<double?>? gpsLng,
    Value<int>? sortOrder,
    Value<DateTime>? capturedAt,
    Value<int>? rowid,
  }) {
    return SubmissionPhotosCompanion(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      categoryKey: categoryKey ?? this.categoryKey,
      localPath: localPath ?? this.localPath,
      originalFilename: originalFilename ?? this.originalFilename,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      widthPx: widthPx ?? this.widthPx,
      heightPx: heightPx ?? this.heightPx,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      sortOrder: sortOrder ?? this.sortOrder,
      capturedAt: capturedAt ?? this.capturedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (submissionId.present) {
      map['submission_id'] = Variable<String>(submissionId.value);
    }
    if (categoryKey.present) {
      map['category_key'] = Variable<String>(categoryKey.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (originalFilename.present) {
      map['original_filename'] = Variable<String>(originalFilename.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (widthPx.present) {
      map['width_px'] = Variable<int>(widthPx.value);
    }
    if (heightPx.present) {
      map['height_px'] = Variable<int>(heightPx.value);
    }
    if (gpsLat.present) {
      map['gps_lat'] = Variable<double>(gpsLat.value);
    }
    if (gpsLng.present) {
      map['gps_lng'] = Variable<double>(gpsLng.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionPhotosCompanion(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('localPath: $localPath, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('widthPx: $widthPx, ')
          ..write('heightPx: $heightPx, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submissionIdMeta = const VerificationMeta(
    'submissionId',
  );
  @override
  late final GeneratedColumn<String> submissionId = GeneratedColumn<String>(
    'submission_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES submission_drafts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMessageMeta = const VerificationMeta(
    'lastErrorMessage',
  );
  @override
  late final GeneratedColumn<String> lastErrorMessage = GeneratedColumn<String>(
    'last_error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enqueuedAtMeta = const VerificationMeta(
    'enqueuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> enqueuedAt = GeneratedColumn<DateTime>(
    'enqueued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    submissionId,
    syncStatus,
    retryCount,
    lastErrorMessage,
    enqueuedAt,
    nextRetryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('submission_id')) {
      context.handle(
        _submissionIdMeta,
        submissionId.isAcceptableOrUnknown(
          data['submission_id']!,
          _submissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submissionIdMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error_message')) {
      context.handle(
        _lastErrorMessageMeta,
        lastErrorMessage.isAcceptableOrUnknown(
          data['last_error_message']!,
          _lastErrorMessageMeta,
        ),
      );
    }
    if (data.containsKey('enqueued_at')) {
      context.handle(
        _enqueuedAtMeta,
        enqueuedAt.isAcceptableOrUnknown(data['enqueued_at']!, _enqueuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enqueuedAtMeta);
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      submissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_id'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastErrorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_message'],
      ),
      enqueuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}enqueued_at'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String submissionId;

  /// SyncStatus enum value: pending | in_progress | failed | succeeded.
  final String syncStatus;
  final int retryCount;
  final String? lastErrorMessage;
  final DateTime enqueuedAt;
  final DateTime? nextRetryAt;
  const SyncQueueData({
    required this.id,
    required this.submissionId,
    required this.syncStatus,
    required this.retryCount,
    this.lastErrorMessage,
    required this.enqueuedAt,
    this.nextRetryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['submission_id'] = Variable<String>(submissionId);
    map['sync_status'] = Variable<String>(syncStatus);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastErrorMessage != null) {
      map['last_error_message'] = Variable<String>(lastErrorMessage);
    }
    map['enqueued_at'] = Variable<DateTime>(enqueuedAt);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      submissionId: Value(submissionId),
      syncStatus: Value(syncStatus),
      retryCount: Value(retryCount),
      lastErrorMessage: lastErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorMessage),
      enqueuedAt: Value(enqueuedAt),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      submissionId: serializer.fromJson<String>(json['submissionId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastErrorMessage: serializer.fromJson<String?>(json['lastErrorMessage']),
      enqueuedAt: serializer.fromJson<DateTime>(json['enqueuedAt']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'submissionId': serializer.toJson<String>(submissionId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastErrorMessage': serializer.toJson<String?>(lastErrorMessage),
      'enqueuedAt': serializer.toJson<DateTime>(enqueuedAt),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? submissionId,
    String? syncStatus,
    int? retryCount,
    Value<String?> lastErrorMessage = const Value.absent(),
    DateTime? enqueuedAt,
    Value<DateTime?> nextRetryAt = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    submissionId: submissionId ?? this.submissionId,
    syncStatus: syncStatus ?? this.syncStatus,
    retryCount: retryCount ?? this.retryCount,
    lastErrorMessage: lastErrorMessage.present
        ? lastErrorMessage.value
        : this.lastErrorMessage,
    enqueuedAt: enqueuedAt ?? this.enqueuedAt,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      submissionId: data.submissionId.present
          ? data.submissionId.value
          : this.submissionId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastErrorMessage: data.lastErrorMessage.present
          ? data.lastErrorMessage.value
          : this.lastErrorMessage,
      enqueuedAt: data.enqueuedAt.present
          ? data.enqueuedAt.value
          : this.enqueuedAt,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastErrorMessage: $lastErrorMessage, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    submissionId,
    syncStatus,
    retryCount,
    lastErrorMessage,
    enqueuedAt,
    nextRetryAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.submissionId == this.submissionId &&
          other.syncStatus == this.syncStatus &&
          other.retryCount == this.retryCount &&
          other.lastErrorMessage == this.lastErrorMessage &&
          other.enqueuedAt == this.enqueuedAt &&
          other.nextRetryAt == this.nextRetryAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> submissionId;
  final Value<String> syncStatus;
  final Value<int> retryCount;
  final Value<String?> lastErrorMessage;
  final Value<DateTime> enqueuedAt;
  final Value<DateTime?> nextRetryAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.submissionId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastErrorMessage = const Value.absent(),
    this.enqueuedAt = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String submissionId,
    required String syncStatus,
    this.retryCount = const Value.absent(),
    this.lastErrorMessage = const Value.absent(),
    required DateTime enqueuedAt,
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       submissionId = Value(submissionId),
       syncStatus = Value(syncStatus),
       enqueuedAt = Value(enqueuedAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? submissionId,
    Expression<String>? syncStatus,
    Expression<int>? retryCount,
    Expression<String>? lastErrorMessage,
    Expression<DateTime>? enqueuedAt,
    Expression<DateTime>? nextRetryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (submissionId != null) 'submission_id': submissionId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastErrorMessage != null) 'last_error_message': lastErrorMessage,
      if (enqueuedAt != null) 'enqueued_at': enqueuedAt,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? submissionId,
    Value<String>? syncStatus,
    Value<int>? retryCount,
    Value<String?>? lastErrorMessage,
    Value<DateTime>? enqueuedAt,
    Value<DateTime?>? nextRetryAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      lastErrorMessage: lastErrorMessage ?? this.lastErrorMessage,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (submissionId.present) {
      map['submission_id'] = Variable<String>(submissionId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastErrorMessage.present) {
      map['last_error_message'] = Variable<String>(lastErrorMessage.value);
    }
    if (enqueuedAt.present) {
      map['enqueued_at'] = Variable<DateTime>(enqueuedAt.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastErrorMessage: $lastErrorMessage, ')
          ..write('enqueuedAt: $enqueuedAt, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubmittedAssetsTable extends SubmittedAssets
    with TableInfo<$SubmittedAssetsTable, SubmittedAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmittedAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetLabelMeta = const VerificationMeta(
    'assetLabel',
  );
  @override
  late final GeneratedColumn<String> assetLabel = GeneratedColumn<String>(
    'asset_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetCategoryMeta = const VerificationMeta(
    'assetCategory',
  );
  @override
  late final GeneratedColumn<String> assetCategory = GeneratedColumn<String>(
    'asset_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valuationPayloadMeta = const VerificationMeta(
    'valuationPayload',
  );
  @override
  late final GeneratedColumn<String> valuationPayload = GeneratedColumn<String>(
    'valuation_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    remoteId,
    status,
    assetLabel,
    assetCategory,
    valuationPayload,
    submittedAt,
    lastUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submitted_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmittedAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('asset_label')) {
      context.handle(
        _assetLabelMeta,
        assetLabel.isAcceptableOrUnknown(data['asset_label']!, _assetLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_assetLabelMeta);
    }
    if (data.containsKey('asset_category')) {
      context.handle(
        _assetCategoryMeta,
        assetCategory.isAcceptableOrUnknown(
          data['asset_category']!,
          _assetCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetCategoryMeta);
    }
    if (data.containsKey('valuation_payload')) {
      context.handle(
        _valuationPayloadMeta,
        valuationPayload.isAcceptableOrUnknown(
          data['valuation_payload']!,
          _valuationPayloadMeta,
        ),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubmittedAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmittedAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      assetLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_label'],
      )!,
      assetCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_category'],
      )!,
      valuationPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valuation_payload'],
      ),
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      )!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
    );
  }

  @override
  $SubmittedAssetsTable createAlias(String alias) {
    return $SubmittedAssetsTable(attachedDatabase, alias);
  }
}

class SubmittedAsset extends DataClass implements Insertable<SubmittedAsset> {
  final String id;
  final String vendorId;
  final String remoteId;

  /// Submission status from CRM, e.g. "valuation_pending" | "accepted".
  final String status;
  final String assetLabel;
  final String assetCategory;

  /// JSON-encoded valuation response (nullable until valued).
  final String? valuationPayload;
  final DateTime submittedAt;
  final DateTime lastUpdatedAt;
  const SubmittedAsset({
    required this.id,
    required this.vendorId,
    required this.remoteId,
    required this.status,
    required this.assetLabel,
    required this.assetCategory,
    this.valuationPayload,
    required this.submittedAt,
    required this.lastUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vendor_id'] = Variable<String>(vendorId);
    map['remote_id'] = Variable<String>(remoteId);
    map['status'] = Variable<String>(status);
    map['asset_label'] = Variable<String>(assetLabel);
    map['asset_category'] = Variable<String>(assetCategory);
    if (!nullToAbsent || valuationPayload != null) {
      map['valuation_payload'] = Variable<String>(valuationPayload);
    }
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    return map;
  }

  SubmittedAssetsCompanion toCompanion(bool nullToAbsent) {
    return SubmittedAssetsCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      remoteId: Value(remoteId),
      status: Value(status),
      assetLabel: Value(assetLabel),
      assetCategory: Value(assetCategory),
      valuationPayload: valuationPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(valuationPayload),
      submittedAt: Value(submittedAt),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory SubmittedAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmittedAsset(
      id: serializer.fromJson<String>(json['id']),
      vendorId: serializer.fromJson<String>(json['vendorId']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      status: serializer.fromJson<String>(json['status']),
      assetLabel: serializer.fromJson<String>(json['assetLabel']),
      assetCategory: serializer.fromJson<String>(json['assetCategory']),
      valuationPayload: serializer.fromJson<String?>(json['valuationPayload']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vendorId': serializer.toJson<String>(vendorId),
      'remoteId': serializer.toJson<String>(remoteId),
      'status': serializer.toJson<String>(status),
      'assetLabel': serializer.toJson<String>(assetLabel),
      'assetCategory': serializer.toJson<String>(assetCategory),
      'valuationPayload': serializer.toJson<String?>(valuationPayload),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
    };
  }

  SubmittedAsset copyWith({
    String? id,
    String? vendorId,
    String? remoteId,
    String? status,
    String? assetLabel,
    String? assetCategory,
    Value<String?> valuationPayload = const Value.absent(),
    DateTime? submittedAt,
    DateTime? lastUpdatedAt,
  }) => SubmittedAsset(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    remoteId: remoteId ?? this.remoteId,
    status: status ?? this.status,
    assetLabel: assetLabel ?? this.assetLabel,
    assetCategory: assetCategory ?? this.assetCategory,
    valuationPayload: valuationPayload.present
        ? valuationPayload.value
        : this.valuationPayload,
    submittedAt: submittedAt ?? this.submittedAt,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
  );
  SubmittedAsset copyWithCompanion(SubmittedAssetsCompanion data) {
    return SubmittedAsset(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      status: data.status.present ? data.status.value : this.status,
      assetLabel: data.assetLabel.present
          ? data.assetLabel.value
          : this.assetLabel,
      assetCategory: data.assetCategory.present
          ? data.assetCategory.value
          : this.assetCategory,
      valuationPayload: data.valuationPayload.present
          ? data.valuationPayload.value
          : this.valuationPayload,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmittedAsset(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('remoteId: $remoteId, ')
          ..write('status: $status, ')
          ..write('assetLabel: $assetLabel, ')
          ..write('assetCategory: $assetCategory, ')
          ..write('valuationPayload: $valuationPayload, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vendorId,
    remoteId,
    status,
    assetLabel,
    assetCategory,
    valuationPayload,
    submittedAt,
    lastUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmittedAsset &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.remoteId == this.remoteId &&
          other.status == this.status &&
          other.assetLabel == this.assetLabel &&
          other.assetCategory == this.assetCategory &&
          other.valuationPayload == this.valuationPayload &&
          other.submittedAt == this.submittedAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class SubmittedAssetsCompanion extends UpdateCompanion<SubmittedAsset> {
  final Value<String> id;
  final Value<String> vendorId;
  final Value<String> remoteId;
  final Value<String> status;
  final Value<String> assetLabel;
  final Value<String> assetCategory;
  final Value<String?> valuationPayload;
  final Value<DateTime> submittedAt;
  final Value<DateTime> lastUpdatedAt;
  final Value<int> rowid;
  const SubmittedAssetsCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.status = const Value.absent(),
    this.assetLabel = const Value.absent(),
    this.assetCategory = const Value.absent(),
    this.valuationPayload = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubmittedAssetsCompanion.insert({
    required String id,
    required String vendorId,
    required String remoteId,
    required String status,
    required String assetLabel,
    required String assetCategory,
    this.valuationPayload = const Value.absent(),
    required DateTime submittedAt,
    required DateTime lastUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vendorId = Value(vendorId),
       remoteId = Value(remoteId),
       status = Value(status),
       assetLabel = Value(assetLabel),
       assetCategory = Value(assetCategory),
       submittedAt = Value(submittedAt),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<SubmittedAsset> custom({
    Expression<String>? id,
    Expression<String>? vendorId,
    Expression<String>? remoteId,
    Expression<String>? status,
    Expression<String>? assetLabel,
    Expression<String>? assetCategory,
    Expression<String>? valuationPayload,
    Expression<DateTime>? submittedAt,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (remoteId != null) 'remote_id': remoteId,
      if (status != null) 'status': status,
      if (assetLabel != null) 'asset_label': assetLabel,
      if (assetCategory != null) 'asset_category': assetCategory,
      if (valuationPayload != null) 'valuation_payload': valuationPayload,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubmittedAssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? vendorId,
    Value<String>? remoteId,
    Value<String>? status,
    Value<String>? assetLabel,
    Value<String>? assetCategory,
    Value<String?>? valuationPayload,
    Value<DateTime>? submittedAt,
    Value<DateTime>? lastUpdatedAt,
    Value<int>? rowid,
  }) {
    return SubmittedAssetsCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      remoteId: remoteId ?? this.remoteId,
      status: status ?? this.status,
      assetLabel: assetLabel ?? this.assetLabel,
      assetCategory: assetCategory ?? this.assetCategory,
      valuationPayload: valuationPayload ?? this.valuationPayload,
      submittedAt: submittedAt ?? this.submittedAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assetLabel.present) {
      map['asset_label'] = Variable<String>(assetLabel.value);
    }
    if (assetCategory.present) {
      map['asset_category'] = Variable<String>(assetCategory.value);
    }
    if (valuationPayload.present) {
      map['valuation_payload'] = Variable<String>(valuationPayload.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmittedAssetsCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('remoteId: $remoteId, ')
          ..write('status: $status, ')
          ..write('assetLabel: $assetLabel, ')
          ..write('assetCategory: $assetCategory, ')
          ..write('valuationPayload: $valuationPayload, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetSchemasTable extends AssetSchemas
    with TableInfo<$AssetSchemasTable, AssetSchema> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetSchemasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryKeyMeta = const VerificationMeta(
    'categoryKey',
  );
  @override
  late final GeneratedColumn<String> categoryKey = GeneratedColumn<String>(
    'category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaJsonMeta = const VerificationMeta(
    'schemaJson',
  );
  @override
  late final GeneratedColumn<String> schemaJson = GeneratedColumn<String>(
    'schema_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    categoryKey,
    schemaJson,
    version,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_schemas';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetSchema> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_key')) {
      context.handle(
        _categoryKeyMeta,
        categoryKey.isAcceptableOrUnknown(
          data['category_key']!,
          _categoryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryKeyMeta);
    }
    if (data.containsKey('schema_json')) {
      context.handle(
        _schemaJsonMeta,
        schemaJson.isAcceptableOrUnknown(data['schema_json']!, _schemaJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_schemaJsonMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryKey};
  @override
  AssetSchema map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetSchema(
      categoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_key'],
      )!,
      schemaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_json'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $AssetSchemasTable createAlias(String alias) {
    return $AssetSchemasTable(attachedDatabase, alias);
  }
}

class AssetSchema extends DataClass implements Insertable<AssetSchema> {
  final String categoryKey;
  final String schemaJson;
  final String version;
  final DateTime cachedAt;
  const AssetSchema({
    required this.categoryKey,
    required this.schemaJson,
    required this.version,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_key'] = Variable<String>(categoryKey);
    map['schema_json'] = Variable<String>(schemaJson);
    map['version'] = Variable<String>(version);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  AssetSchemasCompanion toCompanion(bool nullToAbsent) {
    return AssetSchemasCompanion(
      categoryKey: Value(categoryKey),
      schemaJson: Value(schemaJson),
      version: Value(version),
      cachedAt: Value(cachedAt),
    );
  }

  factory AssetSchema.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetSchema(
      categoryKey: serializer.fromJson<String>(json['categoryKey']),
      schemaJson: serializer.fromJson<String>(json['schemaJson']),
      version: serializer.fromJson<String>(json['version']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryKey': serializer.toJson<String>(categoryKey),
      'schemaJson': serializer.toJson<String>(schemaJson),
      'version': serializer.toJson<String>(version),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  AssetSchema copyWith({
    String? categoryKey,
    String? schemaJson,
    String? version,
    DateTime? cachedAt,
  }) => AssetSchema(
    categoryKey: categoryKey ?? this.categoryKey,
    schemaJson: schemaJson ?? this.schemaJson,
    version: version ?? this.version,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  AssetSchema copyWithCompanion(AssetSchemasCompanion data) {
    return AssetSchema(
      categoryKey: data.categoryKey.present
          ? data.categoryKey.value
          : this.categoryKey,
      schemaJson: data.schemaJson.present
          ? data.schemaJson.value
          : this.schemaJson,
      version: data.version.present ? data.version.value : this.version,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetSchema(')
          ..write('categoryKey: $categoryKey, ')
          ..write('schemaJson: $schemaJson, ')
          ..write('version: $version, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryKey, schemaJson, version, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetSchema &&
          other.categoryKey == this.categoryKey &&
          other.schemaJson == this.schemaJson &&
          other.version == this.version &&
          other.cachedAt == this.cachedAt);
}

class AssetSchemasCompanion extends UpdateCompanion<AssetSchema> {
  final Value<String> categoryKey;
  final Value<String> schemaJson;
  final Value<String> version;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const AssetSchemasCompanion({
    this.categoryKey = const Value.absent(),
    this.schemaJson = const Value.absent(),
    this.version = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetSchemasCompanion.insert({
    required String categoryKey,
    required String schemaJson,
    required String version,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : categoryKey = Value(categoryKey),
       schemaJson = Value(schemaJson),
       version = Value(version),
       cachedAt = Value(cachedAt);
  static Insertable<AssetSchema> custom({
    Expression<String>? categoryKey,
    Expression<String>? schemaJson,
    Expression<String>? version,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryKey != null) 'category_key': categoryKey,
      if (schemaJson != null) 'schema_json': schemaJson,
      if (version != null) 'version': version,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetSchemasCompanion copyWith({
    Value<String>? categoryKey,
    Value<String>? schemaJson,
    Value<String>? version,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return AssetSchemasCompanion(
      categoryKey: categoryKey ?? this.categoryKey,
      schemaJson: schemaJson ?? this.schemaJson,
      version: version ?? this.version,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryKey.present) {
      map['category_key'] = Variable<String>(categoryKey.value);
    }
    if (schemaJson.present) {
      map['schema_json'] = Variable<String>(schemaJson.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetSchemasCompanion(')
          ..write('categoryKey: $categoryKey, ')
          ..write('schemaJson: $schemaJson, ')
          ..write('version: $version, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubmissionDraftsTable submissionDrafts = $SubmissionDraftsTable(
    this,
  );
  late final $SubmissionPhotosTable submissionPhotos = $SubmissionPhotosTable(
    this,
  );
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SubmittedAssetsTable submittedAssets = $SubmittedAssetsTable(
    this,
  );
  late final $AssetSchemasTable assetSchemas = $AssetSchemasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    submissionDrafts,
    submissionPhotos,
    syncQueue,
    submittedAssets,
    assetSchemas,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'submission_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('submission_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'submission_drafts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sync_queue', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SubmissionDraftsTableCreateCompanionBuilder =
    SubmissionDraftsCompanion Function({
      required String id,
      required String vendorId,
      required String status,
      required String assetPayloadEncrypted,
      required String assetCategory,
      required String assetLabel,
      Value<double?> gpsLat,
      Value<double?> gpsLng,
      Value<int> photoCount,
      Value<int> retryCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$SubmissionDraftsTableUpdateCompanionBuilder =
    SubmissionDraftsCompanion Function({
      Value<String> id,
      Value<String> vendorId,
      Value<String> status,
      Value<String> assetPayloadEncrypted,
      Value<String> assetCategory,
      Value<String> assetLabel,
      Value<double?> gpsLat,
      Value<double?> gpsLng,
      Value<int> photoCount,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

final class $$SubmissionDraftsTableReferences
    extends
        BaseReferences<_$AppDatabase, $SubmissionDraftsTable, SubmissionDraft> {
  $$SubmissionDraftsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SubmissionPhotosTable, List<SubmissionPhoto>>
  _submissionPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.submissionPhotos,
    aliasName: $_aliasNameGenerator(
      db.submissionDrafts.id,
      db.submissionPhotos.submissionId,
    ),
  );

  $$SubmissionPhotosTableProcessedTableManager get submissionPhotosRefs {
    final manager = $$SubmissionPhotosTableTableManager(
      $_db,
      $_db.submissionPhotos,
    ).filter((f) => f.submissionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _submissionPhotosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncQueueTable, List<SyncQueueData>>
  _syncQueueRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncQueue,
    aliasName: $_aliasNameGenerator(
      db.submissionDrafts.id,
      db.syncQueue.submissionId,
    ),
  );

  $$SyncQueueTableProcessedTableManager get syncQueueRefs {
    final manager = $$SyncQueueTableTableManager(
      $_db,
      $_db.syncQueue,
    ).filter((f) => f.submissionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_syncQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubmissionDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionDraftsTable> {
  $$SubmissionDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetPayloadEncrypted => $composableBuilder(
    column: $table.assetPayloadEncrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetCategory => $composableBuilder(
    column: $table.assetCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetLabel => $composableBuilder(
    column: $table.assetLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsLat => $composableBuilder(
    column: $table.gpsLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsLng => $composableBuilder(
    column: $table.gpsLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get photoCount => $composableBuilder(
    column: $table.photoCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> submissionPhotosRefs(
    Expression<bool> Function($$SubmissionPhotosTableFilterComposer f) f,
  ) {
    final $$SubmissionPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionPhotos,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionPhotosTableFilterComposer(
            $db: $db,
            $table: $db.submissionPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> syncQueueRefs(
    Expression<bool> Function($$SyncQueueTableFilterComposer f) f,
  ) {
    final $$SyncQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncQueue,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncQueueTableFilterComposer(
            $db: $db,
            $table: $db.syncQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubmissionDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionDraftsTable> {
  $$SubmissionDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetPayloadEncrypted => $composableBuilder(
    column: $table.assetPayloadEncrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetCategory => $composableBuilder(
    column: $table.assetCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetLabel => $composableBuilder(
    column: $table.assetLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsLat => $composableBuilder(
    column: $table.gpsLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsLng => $composableBuilder(
    column: $table.gpsLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get photoCount => $composableBuilder(
    column: $table.photoCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubmissionDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionDraftsTable> {
  $$SubmissionDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get assetPayloadEncrypted => $composableBuilder(
    column: $table.assetPayloadEncrypted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetCategory => $composableBuilder(
    column: $table.assetCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetLabel => $composableBuilder(
    column: $table.assetLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gpsLat =>
      $composableBuilder(column: $table.gpsLat, builder: (column) => column);

  GeneratedColumn<double> get gpsLng =>
      $composableBuilder(column: $table.gpsLng, builder: (column) => column);

  GeneratedColumn<int> get photoCount => $composableBuilder(
    column: $table.photoCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> submissionPhotosRefs<T extends Object>(
    Expression<T> Function($$SubmissionPhotosTableAnnotationComposer a) f,
  ) {
    final $$SubmissionPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionPhotos,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.submissionPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> syncQueueRefs<T extends Object>(
    Expression<T> Function($$SyncQueueTableAnnotationComposer a) f,
  ) {
    final $$SyncQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncQueue,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.syncQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubmissionDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionDraftsTable,
          SubmissionDraft,
          $$SubmissionDraftsTableFilterComposer,
          $$SubmissionDraftsTableOrderingComposer,
          $$SubmissionDraftsTableAnnotationComposer,
          $$SubmissionDraftsTableCreateCompanionBuilder,
          $$SubmissionDraftsTableUpdateCompanionBuilder,
          (SubmissionDraft, $$SubmissionDraftsTableReferences),
          SubmissionDraft,
          PrefetchHooks Function({
            bool submissionPhotosRefs,
            bool syncQueueRefs,
          })
        > {
  $$SubmissionDraftsTableTableManager(
    _$AppDatabase db,
    $SubmissionDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmissionDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmissionDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmissionDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vendorId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> assetPayloadEncrypted = const Value.absent(),
                Value<String> assetCategory = const Value.absent(),
                Value<String> assetLabel = const Value.absent(),
                Value<double?> gpsLat = const Value.absent(),
                Value<double?> gpsLng = const Value.absent(),
                Value<int> photoCount = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubmissionDraftsCompanion(
                id: id,
                vendorId: vendorId,
                status: status,
                assetPayloadEncrypted: assetPayloadEncrypted,
                assetCategory: assetCategory,
                assetLabel: assetLabel,
                gpsLat: gpsLat,
                gpsLng: gpsLng,
                photoCount: photoCount,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vendorId,
                required String status,
                required String assetPayloadEncrypted,
                required String assetCategory,
                required String assetLabel,
                Value<double?> gpsLat = const Value.absent(),
                Value<double?> gpsLng = const Value.absent(),
                Value<int> photoCount = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubmissionDraftsCompanion.insert(
                id: id,
                vendorId: vendorId,
                status: status,
                assetPayloadEncrypted: assetPayloadEncrypted,
                assetCategory: assetCategory,
                assetLabel: assetLabel,
                gpsLat: gpsLat,
                gpsLng: gpsLng,
                photoCount: photoCount,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubmissionDraftsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({submissionPhotosRefs = false, syncQueueRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (submissionPhotosRefs) db.submissionPhotos,
                    if (syncQueueRefs) db.syncQueue,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (submissionPhotosRefs)
                        await $_getPrefetchedData<
                          SubmissionDraft,
                          $SubmissionDraftsTable,
                          SubmissionPhoto
                        >(
                          currentTable: table,
                          referencedTable: $$SubmissionDraftsTableReferences
                              ._submissionPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubmissionDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).submissionPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.submissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (syncQueueRefs)
                        await $_getPrefetchedData<
                          SubmissionDraft,
                          $SubmissionDraftsTable,
                          SyncQueueData
                        >(
                          currentTable: table,
                          referencedTable: $$SubmissionDraftsTableReferences
                              ._syncQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubmissionDraftsTableReferences(
                                db,
                                table,
                                p0,
                              ).syncQueueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.submissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubmissionDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionDraftsTable,
      SubmissionDraft,
      $$SubmissionDraftsTableFilterComposer,
      $$SubmissionDraftsTableOrderingComposer,
      $$SubmissionDraftsTableAnnotationComposer,
      $$SubmissionDraftsTableCreateCompanionBuilder,
      $$SubmissionDraftsTableUpdateCompanionBuilder,
      (SubmissionDraft, $$SubmissionDraftsTableReferences),
      SubmissionDraft,
      PrefetchHooks Function({bool submissionPhotosRefs, bool syncQueueRefs})
    >;
typedef $$SubmissionPhotosTableCreateCompanionBuilder =
    SubmissionPhotosCompanion Function({
      required String id,
      required String submissionId,
      required String categoryKey,
      required String localPath,
      required String originalFilename,
      required int fileSizeBytes,
      required int widthPx,
      required int heightPx,
      Value<double?> gpsLat,
      Value<double?> gpsLng,
      Value<int> sortOrder,
      required DateTime capturedAt,
      Value<int> rowid,
    });
typedef $$SubmissionPhotosTableUpdateCompanionBuilder =
    SubmissionPhotosCompanion Function({
      Value<String> id,
      Value<String> submissionId,
      Value<String> categoryKey,
      Value<String> localPath,
      Value<String> originalFilename,
      Value<int> fileSizeBytes,
      Value<int> widthPx,
      Value<int> heightPx,
      Value<double?> gpsLat,
      Value<double?> gpsLng,
      Value<int> sortOrder,
      Value<DateTime> capturedAt,
      Value<int> rowid,
    });

final class $$SubmissionPhotosTableReferences
    extends
        BaseReferences<_$AppDatabase, $SubmissionPhotosTable, SubmissionPhoto> {
  $$SubmissionPhotosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubmissionDraftsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissionDrafts.createAlias(
        $_aliasNameGenerator(
          db.submissionPhotos.submissionId,
          db.submissionDrafts.id,
        ),
      );

  $$SubmissionDraftsTableProcessedTableManager get submissionId {
    final $_column = $_itemColumn<String>('submission_id')!;

    final manager = $$SubmissionDraftsTableTableManager(
      $_db,
      $_db.submissionDrafts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubmissionPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionPhotosTable> {
  $$SubmissionPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get widthPx => $composableBuilder(
    column: $table.widthPx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightPx => $composableBuilder(
    column: $table.heightPx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsLat => $composableBuilder(
    column: $table.gpsLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsLng => $composableBuilder(
    column: $table.gpsLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubmissionDraftsTableFilterComposer get submissionId {
    final $$SubmissionDraftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissionDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionDraftsTableFilterComposer(
            $db: $db,
            $table: $db.submissionDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionPhotosTable> {
  $$SubmissionPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widthPx => $composableBuilder(
    column: $table.widthPx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightPx => $composableBuilder(
    column: $table.heightPx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsLat => $composableBuilder(
    column: $table.gpsLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsLng => $composableBuilder(
    column: $table.gpsLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubmissionDraftsTableOrderingComposer get submissionId {
    final $$SubmissionDraftsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissionDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionDraftsTableOrderingComposer(
            $db: $db,
            $table: $db.submissionDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionPhotosTable> {
  $$SubmissionPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get widthPx =>
      $composableBuilder(column: $table.widthPx, builder: (column) => column);

  GeneratedColumn<int> get heightPx =>
      $composableBuilder(column: $table.heightPx, builder: (column) => column);

  GeneratedColumn<double> get gpsLat =>
      $composableBuilder(column: $table.gpsLat, builder: (column) => column);

  GeneratedColumn<double> get gpsLng =>
      $composableBuilder(column: $table.gpsLng, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  $$SubmissionDraftsTableAnnotationComposer get submissionId {
    final $$SubmissionDraftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissionDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionDraftsTableAnnotationComposer(
            $db: $db,
            $table: $db.submissionDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionPhotosTable,
          SubmissionPhoto,
          $$SubmissionPhotosTableFilterComposer,
          $$SubmissionPhotosTableOrderingComposer,
          $$SubmissionPhotosTableAnnotationComposer,
          $$SubmissionPhotosTableCreateCompanionBuilder,
          $$SubmissionPhotosTableUpdateCompanionBuilder,
          (SubmissionPhoto, $$SubmissionPhotosTableReferences),
          SubmissionPhoto,
          PrefetchHooks Function({bool submissionId})
        > {
  $$SubmissionPhotosTableTableManager(
    _$AppDatabase db,
    $SubmissionPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmissionPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmissionPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmissionPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> submissionId = const Value.absent(),
                Value<String> categoryKey = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> originalFilename = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<int> widthPx = const Value.absent(),
                Value<int> heightPx = const Value.absent(),
                Value<double?> gpsLat = const Value.absent(),
                Value<double?> gpsLng = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubmissionPhotosCompanion(
                id: id,
                submissionId: submissionId,
                categoryKey: categoryKey,
                localPath: localPath,
                originalFilename: originalFilename,
                fileSizeBytes: fileSizeBytes,
                widthPx: widthPx,
                heightPx: heightPx,
                gpsLat: gpsLat,
                gpsLng: gpsLng,
                sortOrder: sortOrder,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String submissionId,
                required String categoryKey,
                required String localPath,
                required String originalFilename,
                required int fileSizeBytes,
                required int widthPx,
                required int heightPx,
                Value<double?> gpsLat = const Value.absent(),
                Value<double?> gpsLng = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime capturedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubmissionPhotosCompanion.insert(
                id: id,
                submissionId: submissionId,
                categoryKey: categoryKey,
                localPath: localPath,
                originalFilename: originalFilename,
                fileSizeBytes: fileSizeBytes,
                widthPx: widthPx,
                heightPx: heightPx,
                gpsLat: gpsLat,
                gpsLng: gpsLng,
                sortOrder: sortOrder,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubmissionPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (submissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.submissionId,
                                referencedTable:
                                    $$SubmissionPhotosTableReferences
                                        ._submissionIdTable(db),
                                referencedColumn:
                                    $$SubmissionPhotosTableReferences
                                        ._submissionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubmissionPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionPhotosTable,
      SubmissionPhoto,
      $$SubmissionPhotosTableFilterComposer,
      $$SubmissionPhotosTableOrderingComposer,
      $$SubmissionPhotosTableAnnotationComposer,
      $$SubmissionPhotosTableCreateCompanionBuilder,
      $$SubmissionPhotosTableUpdateCompanionBuilder,
      (SubmissionPhoto, $$SubmissionPhotosTableReferences),
      SubmissionPhoto,
      PrefetchHooks Function({bool submissionId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String submissionId,
      required String syncStatus,
      Value<int> retryCount,
      Value<String?> lastErrorMessage,
      required DateTime enqueuedAt,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> submissionId,
      Value<String> syncStatus,
      Value<int> retryCount,
      Value<String?> lastErrorMessage,
      Value<DateTime> enqueuedAt,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });

final class $$SyncQueueTableReferences
    extends BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData> {
  $$SyncQueueTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubmissionDraftsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissionDrafts.createAlias(
        $_aliasNameGenerator(db.syncQueue.submissionId, db.submissionDrafts.id),
      );

  $$SubmissionDraftsTableProcessedTableManager get submissionId {
    final $_column = $_itemColumn<String>('submission_id')!;

    final manager = $$SubmissionDraftsTableTableManager(
      $_db,
      $_db.submissionDrafts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubmissionDraftsTableFilterComposer get submissionId {
    final $$SubmissionDraftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissionDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionDraftsTableFilterComposer(
            $db: $db,
            $table: $db.submissionDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubmissionDraftsTableOrderingComposer get submissionId {
    final $$SubmissionDraftsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissionDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionDraftsTableOrderingComposer(
            $db: $db,
            $table: $db.submissionDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get enqueuedAt => $composableBuilder(
    column: $table.enqueuedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  $$SubmissionDraftsTableAnnotationComposer get submissionId {
    final $$SubmissionDraftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissionDrafts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionDraftsTableAnnotationComposer(
            $db: $db,
            $table: $db.submissionDrafts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (SyncQueueData, $$SyncQueueTableReferences),
          SyncQueueData,
          PrefetchHooks Function({bool submissionId})
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> submissionId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastErrorMessage = const Value.absent(),
                Value<DateTime> enqueuedAt = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                submissionId: submissionId,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastErrorMessage: lastErrorMessage,
                enqueuedAt: enqueuedAt,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String submissionId,
                required String syncStatus,
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastErrorMessage = const Value.absent(),
                required DateTime enqueuedAt,
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                submissionId: submissionId,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastErrorMessage: lastErrorMessage,
                enqueuedAt: enqueuedAt,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncQueueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (submissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.submissionId,
                                referencedTable: $$SyncQueueTableReferences
                                    ._submissionIdTable(db),
                                referencedColumn: $$SyncQueueTableReferences
                                    ._submissionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (SyncQueueData, $$SyncQueueTableReferences),
      SyncQueueData,
      PrefetchHooks Function({bool submissionId})
    >;
typedef $$SubmittedAssetsTableCreateCompanionBuilder =
    SubmittedAssetsCompanion Function({
      required String id,
      required String vendorId,
      required String remoteId,
      required String status,
      required String assetLabel,
      required String assetCategory,
      Value<String?> valuationPayload,
      required DateTime submittedAt,
      required DateTime lastUpdatedAt,
      Value<int> rowid,
    });
typedef $$SubmittedAssetsTableUpdateCompanionBuilder =
    SubmittedAssetsCompanion Function({
      Value<String> id,
      Value<String> vendorId,
      Value<String> remoteId,
      Value<String> status,
      Value<String> assetLabel,
      Value<String> assetCategory,
      Value<String?> valuationPayload,
      Value<DateTime> submittedAt,
      Value<DateTime> lastUpdatedAt,
      Value<int> rowid,
    });

class $$SubmittedAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $SubmittedAssetsTable> {
  $$SubmittedAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetLabel => $composableBuilder(
    column: $table.assetLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetCategory => $composableBuilder(
    column: $table.assetCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuationPayload => $composableBuilder(
    column: $table.valuationPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubmittedAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmittedAssetsTable> {
  $$SubmittedAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetLabel => $composableBuilder(
    column: $table.assetLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetCategory => $composableBuilder(
    column: $table.assetCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuationPayload => $composableBuilder(
    column: $table.valuationPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubmittedAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmittedAssetsTable> {
  $$SubmittedAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get assetLabel => $composableBuilder(
    column: $table.assetLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetCategory => $composableBuilder(
    column: $table.assetCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valuationPayload => $composableBuilder(
    column: $table.valuationPayload,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );
}

class $$SubmittedAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmittedAssetsTable,
          SubmittedAsset,
          $$SubmittedAssetsTableFilterComposer,
          $$SubmittedAssetsTableOrderingComposer,
          $$SubmittedAssetsTableAnnotationComposer,
          $$SubmittedAssetsTableCreateCompanionBuilder,
          $$SubmittedAssetsTableUpdateCompanionBuilder,
          (
            SubmittedAsset,
            BaseReferences<
              _$AppDatabase,
              $SubmittedAssetsTable,
              SubmittedAsset
            >,
          ),
          SubmittedAsset,
          PrefetchHooks Function()
        > {
  $$SubmittedAssetsTableTableManager(
    _$AppDatabase db,
    $SubmittedAssetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmittedAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmittedAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmittedAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vendorId = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> assetLabel = const Value.absent(),
                Value<String> assetCategory = const Value.absent(),
                Value<String?> valuationPayload = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubmittedAssetsCompanion(
                id: id,
                vendorId: vendorId,
                remoteId: remoteId,
                status: status,
                assetLabel: assetLabel,
                assetCategory: assetCategory,
                valuationPayload: valuationPayload,
                submittedAt: submittedAt,
                lastUpdatedAt: lastUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vendorId,
                required String remoteId,
                required String status,
                required String assetLabel,
                required String assetCategory,
                Value<String?> valuationPayload = const Value.absent(),
                required DateTime submittedAt,
                required DateTime lastUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubmittedAssetsCompanion.insert(
                id: id,
                vendorId: vendorId,
                remoteId: remoteId,
                status: status,
                assetLabel: assetLabel,
                assetCategory: assetCategory,
                valuationPayload: valuationPayload,
                submittedAt: submittedAt,
                lastUpdatedAt: lastUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubmittedAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmittedAssetsTable,
      SubmittedAsset,
      $$SubmittedAssetsTableFilterComposer,
      $$SubmittedAssetsTableOrderingComposer,
      $$SubmittedAssetsTableAnnotationComposer,
      $$SubmittedAssetsTableCreateCompanionBuilder,
      $$SubmittedAssetsTableUpdateCompanionBuilder,
      (
        SubmittedAsset,
        BaseReferences<_$AppDatabase, $SubmittedAssetsTable, SubmittedAsset>,
      ),
      SubmittedAsset,
      PrefetchHooks Function()
    >;
typedef $$AssetSchemasTableCreateCompanionBuilder =
    AssetSchemasCompanion Function({
      required String categoryKey,
      required String schemaJson,
      required String version,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$AssetSchemasTableUpdateCompanionBuilder =
    AssetSchemasCompanion Function({
      Value<String> categoryKey,
      Value<String> schemaJson,
      Value<String> version,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$AssetSchemasTableFilterComposer
    extends Composer<_$AppDatabase, $AssetSchemasTable> {
  $$AssetSchemasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaJson => $composableBuilder(
    column: $table.schemaJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetSchemasTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetSchemasTable> {
  $$AssetSchemasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaJson => $composableBuilder(
    column: $table.schemaJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetSchemasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetSchemasTable> {
  $$AssetSchemasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schemaJson => $composableBuilder(
    column: $table.schemaJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$AssetSchemasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetSchemasTable,
          AssetSchema,
          $$AssetSchemasTableFilterComposer,
          $$AssetSchemasTableOrderingComposer,
          $$AssetSchemasTableAnnotationComposer,
          $$AssetSchemasTableCreateCompanionBuilder,
          $$AssetSchemasTableUpdateCompanionBuilder,
          (
            AssetSchema,
            BaseReferences<_$AppDatabase, $AssetSchemasTable, AssetSchema>,
          ),
          AssetSchema,
          PrefetchHooks Function()
        > {
  $$AssetSchemasTableTableManager(_$AppDatabase db, $AssetSchemasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetSchemasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetSchemasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetSchemasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> categoryKey = const Value.absent(),
                Value<String> schemaJson = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetSchemasCompanion(
                categoryKey: categoryKey,
                schemaJson: schemaJson,
                version: version,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String categoryKey,
                required String schemaJson,
                required String version,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssetSchemasCompanion.insert(
                categoryKey: categoryKey,
                schemaJson: schemaJson,
                version: version,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetSchemasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetSchemasTable,
      AssetSchema,
      $$AssetSchemasTableFilterComposer,
      $$AssetSchemasTableOrderingComposer,
      $$AssetSchemasTableAnnotationComposer,
      $$AssetSchemasTableCreateCompanionBuilder,
      $$AssetSchemasTableUpdateCompanionBuilder,
      (
        AssetSchema,
        BaseReferences<_$AppDatabase, $AssetSchemasTable, AssetSchema>,
      ),
      AssetSchema,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubmissionDraftsTableTableManager get submissionDrafts =>
      $$SubmissionDraftsTableTableManager(_db, _db.submissionDrafts);
  $$SubmissionPhotosTableTableManager get submissionPhotos =>
      $$SubmissionPhotosTableTableManager(_db, _db.submissionPhotos);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SubmittedAssetsTableTableManager get submittedAssets =>
      $$SubmittedAssetsTableTableManager(_db, _db.submittedAssets);
  $$AssetSchemasTableTableManager get assetSchemas =>
      $$AssetSchemasTableTableManager(_db, _db.assetSchemas);
}
