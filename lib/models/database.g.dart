// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _departmentMeta =
      const VerificationMeta('department');
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
      'department', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _faceHashMeta =
      const VerificationMeta('faceHash');
  @override
  late final GeneratedColumn<String> faceHash = GeneratedColumn<String>(
      'face_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enrolledAtMeta =
      const VerificationMeta('enrolledAt');
  @override
  late final GeneratedColumn<String> enrolledAt = GeneratedColumn<String>(
      'enrolled_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, department, faceHash, deviceId, enrolledAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
          _departmentMeta,
          department.isAcceptableOrUnknown(
              data['department']!, _departmentMeta));
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('face_hash')) {
      context.handle(_faceHashMeta,
          faceHash.isAcceptableOrUnknown(data['face_hash']!, _faceHashMeta));
    } else if (isInserting) {
      context.missing(_faceHashMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('enrolled_at')) {
      context.handle(
          _enrolledAtMeta,
          enrolledAt.isAcceptableOrUnknown(
              data['enrolled_at']!, _enrolledAtMeta));
    } else if (isInserting) {
      context.missing(_enrolledAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      department: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department'])!,
      faceHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}face_hash'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      enrolledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}enrolled_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String name;
  final String department;
  final String faceHash;
  final String deviceId;
  final String enrolledAt;
  final bool isActive;
  const Student(
      {required this.id,
      required this.name,
      required this.department,
      required this.faceHash,
      required this.deviceId,
      required this.enrolledAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['department'] = Variable<String>(department);
    map['face_hash'] = Variable<String>(faceHash);
    map['device_id'] = Variable<String>(deviceId);
    map['enrolled_at'] = Variable<String>(enrolledAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      name: Value(name),
      department: Value(department),
      faceHash: Value(faceHash),
      deviceId: Value(deviceId),
      enrolledAt: Value(enrolledAt),
      isActive: Value(isActive),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      department: serializer.fromJson<String>(json['department']),
      faceHash: serializer.fromJson<String>(json['faceHash']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      enrolledAt: serializer.fromJson<String>(json['enrolledAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'department': serializer.toJson<String>(department),
      'faceHash': serializer.toJson<String>(faceHash),
      'deviceId': serializer.toJson<String>(deviceId),
      'enrolledAt': serializer.toJson<String>(enrolledAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Student copyWith(
          {String? id,
          String? name,
          String? department,
          String? faceHash,
          String? deviceId,
          String? enrolledAt,
          bool? isActive}) =>
      Student(
        id: id ?? this.id,
        name: name ?? this.name,
        department: department ?? this.department,
        faceHash: faceHash ?? this.faceHash,
        deviceId: deviceId ?? this.deviceId,
        enrolledAt: enrolledAt ?? this.enrolledAt,
        isActive: isActive ?? this.isActive,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      department:
          data.department.present ? data.department.value : this.department,
      faceHash: data.faceHash.present ? data.faceHash.value : this.faceHash,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      enrolledAt:
          data.enrolledAt.present ? data.enrolledAt.value : this.enrolledAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('department: $department, ')
          ..write('faceHash: $faceHash, ')
          ..write('deviceId: $deviceId, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, department, faceHash, deviceId, enrolledAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.name == this.name &&
          other.department == this.department &&
          other.faceHash == this.faceHash &&
          other.deviceId == this.deviceId &&
          other.enrolledAt == this.enrolledAt &&
          other.isActive == this.isActive);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> department;
  final Value<String> faceHash;
  final Value<String> deviceId;
  final Value<String> enrolledAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.department = const Value.absent(),
    this.faceHash = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.enrolledAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String name,
    required String department,
    required String faceHash,
    required String deviceId,
    required String enrolledAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        department = Value(department),
        faceHash = Value(faceHash),
        deviceId = Value(deviceId),
        enrolledAt = Value(enrolledAt);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? department,
    Expression<String>? faceHash,
    Expression<String>? deviceId,
    Expression<String>? enrolledAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (department != null) 'department': department,
      if (faceHash != null) 'face_hash': faceHash,
      if (deviceId != null) 'device_id': deviceId,
      if (enrolledAt != null) 'enrolled_at': enrolledAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? department,
      Value<String>? faceHash,
      Value<String>? deviceId,
      Value<String>? enrolledAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return StudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      faceHash: faceHash ?? this.faceHash,
      deviceId: deviceId ?? this.deviceId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (faceHash.present) {
      map['face_hash'] = Variable<String>(faceHash.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (enrolledAt.present) {
      map['enrolled_at'] = Variable<String>(enrolledAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('department: $department, ')
          ..write('faceHash: $faceHash, ')
          ..write('deviceId: $deviceId, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GateEventsTable extends GateEvents
    with TableInfo<$GateEventsTable, GateEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GateEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
      'event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expectedReturnIsoMeta =
      const VerificationMeta('expectedReturnIso');
  @override
  late final GeneratedColumn<String> expectedReturnIso =
      GeneratedColumn<String>('expected_return_iso', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expectedDurationMsMeta =
      const VerificationMeta('expectedDurationMs');
  @override
  late final GeneratedColumn<int> expectedDurationMs = GeneratedColumn<int>(
      'expected_duration_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _requiresApprovalMeta =
      const VerificationMeta('requiresApproval');
  @override
  late final GeneratedColumn<bool> requiresApproval = GeneratedColumn<bool>(
      'requires_approval', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_approval" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _approvalDocPathMeta =
      const VerificationMeta('approvalDocPath');
  @override
  late final GeneratedColumn<String> approvalDocPath = GeneratedColumn<String>(
      'approval_doc_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gpsLatMeta = const VerificationMeta('gpsLat');
  @override
  late final GeneratedColumn<double> gpsLat = GeneratedColumn<double>(
      'gps_lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gpsLngMeta = const VerificationMeta('gpsLng');
  @override
  late final GeneratedColumn<double> gpsLng = GeneratedColumn<double>(
      'gps_lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gpsAccuracyMeta =
      const VerificationMeta('gpsAccuracy');
  @override
  late final GeneratedColumn<double> gpsAccuracy = GeneratedColumn<double>(
      'gps_accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _gateIdMeta = const VerificationMeta('gateId');
  @override
  late final GeneratedColumn<String> gateId = GeneratedColumn<String>(
      'gate_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trueTimestampMeta =
      const VerificationMeta('trueTimestamp');
  @override
  late final GeneratedColumn<String> trueTimestamp = GeneratedColumn<String>(
      'true_timestamp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneTimestampMeta =
      const VerificationMeta('phoneTimestamp');
  @override
  late final GeneratedColumn<String> phoneTimestamp = GeneratedColumn<String>(
      'phone_timestamp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clockDeltaMsMeta =
      const VerificationMeta('clockDeltaMs');
  @override
  late final GeneratedColumn<int> clockDeltaMs = GeneratedColumn<int>(
      'clock_delta_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _faceConfidenceMeta =
      const VerificationMeta('faceConfidence');
  @override
  late final GeneratedColumn<double> faceConfidence = GeneratedColumn<double>(
      'face_confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hmacSignatureMeta =
      const VerificationMeta('hmacSignature');
  @override
  late final GeneratedColumn<String> hmacSignature = GeneratedColumn<String>(
      'hmac_signature', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<String> nonce = GeneratedColumn<String>(
      'nonce', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<String> syncedAt = GeneratedColumn<String>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSpoofAttemptMeta =
      const VerificationMeta('isSpoofAttempt');
  @override
  late final GeneratedColumn<bool> isSpoofAttempt = GeneratedColumn<bool>(
      'is_spoof_attempt', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_spoof_attempt" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        eventId,
        studentId,
        status,
        reason,
        expectedReturnIso,
        expectedDurationMs,
        requiresApproval,
        approvalDocPath,
        gpsLat,
        gpsLng,
        gpsAccuracy,
        gateId,
        trueTimestamp,
        phoneTimestamp,
        clockDeltaMs,
        faceConfidence,
        hmacSignature,
        nonce,
        syncStatus,
        retryCount,
        syncedAt,
        isSpoofAttempt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gate_events';
  @override
  VerificationContext validateIntegrity(Insertable<GateEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('expected_return_iso')) {
      context.handle(
          _expectedReturnIsoMeta,
          expectedReturnIso.isAcceptableOrUnknown(
              data['expected_return_iso']!, _expectedReturnIsoMeta));
    }
    if (data.containsKey('expected_duration_ms')) {
      context.handle(
          _expectedDurationMsMeta,
          expectedDurationMs.isAcceptableOrUnknown(
              data['expected_duration_ms']!, _expectedDurationMsMeta));
    }
    if (data.containsKey('requires_approval')) {
      context.handle(
          _requiresApprovalMeta,
          requiresApproval.isAcceptableOrUnknown(
              data['requires_approval']!, _requiresApprovalMeta));
    }
    if (data.containsKey('approval_doc_path')) {
      context.handle(
          _approvalDocPathMeta,
          approvalDocPath.isAcceptableOrUnknown(
              data['approval_doc_path']!, _approvalDocPathMeta));
    }
    if (data.containsKey('gps_lat')) {
      context.handle(_gpsLatMeta,
          gpsLat.isAcceptableOrUnknown(data['gps_lat']!, _gpsLatMeta));
    } else if (isInserting) {
      context.missing(_gpsLatMeta);
    }
    if (data.containsKey('gps_lng')) {
      context.handle(_gpsLngMeta,
          gpsLng.isAcceptableOrUnknown(data['gps_lng']!, _gpsLngMeta));
    } else if (isInserting) {
      context.missing(_gpsLngMeta);
    }
    if (data.containsKey('gps_accuracy')) {
      context.handle(
          _gpsAccuracyMeta,
          gpsAccuracy.isAcceptableOrUnknown(
              data['gps_accuracy']!, _gpsAccuracyMeta));
    } else if (isInserting) {
      context.missing(_gpsAccuracyMeta);
    }
    if (data.containsKey('gate_id')) {
      context.handle(_gateIdMeta,
          gateId.isAcceptableOrUnknown(data['gate_id']!, _gateIdMeta));
    } else if (isInserting) {
      context.missing(_gateIdMeta);
    }
    if (data.containsKey('true_timestamp')) {
      context.handle(
          _trueTimestampMeta,
          trueTimestamp.isAcceptableOrUnknown(
              data['true_timestamp']!, _trueTimestampMeta));
    } else if (isInserting) {
      context.missing(_trueTimestampMeta);
    }
    if (data.containsKey('phone_timestamp')) {
      context.handle(
          _phoneTimestampMeta,
          phoneTimestamp.isAcceptableOrUnknown(
              data['phone_timestamp']!, _phoneTimestampMeta));
    } else if (isInserting) {
      context.missing(_phoneTimestampMeta);
    }
    if (data.containsKey('clock_delta_ms')) {
      context.handle(
          _clockDeltaMsMeta,
          clockDeltaMs.isAcceptableOrUnknown(
              data['clock_delta_ms']!, _clockDeltaMsMeta));
    } else if (isInserting) {
      context.missing(_clockDeltaMsMeta);
    }
    if (data.containsKey('face_confidence')) {
      context.handle(
          _faceConfidenceMeta,
          faceConfidence.isAcceptableOrUnknown(
              data['face_confidence']!, _faceConfidenceMeta));
    } else if (isInserting) {
      context.missing(_faceConfidenceMeta);
    }
    if (data.containsKey('hmac_signature')) {
      context.handle(
          _hmacSignatureMeta,
          hmacSignature.isAcceptableOrUnknown(
              data['hmac_signature']!, _hmacSignatureMeta));
    } else if (isInserting) {
      context.missing(_hmacSignatureMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_spoof_attempt')) {
      context.handle(
          _isSpoofAttemptMeta,
          isSpoofAttempt.isAcceptableOrUnknown(
              data['is_spoof_attempt']!, _isSpoofAttemptMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  GateEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GateEvent(
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      expectedReturnIso: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}expected_return_iso']),
      expectedDurationMs: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_duration_ms']),
      requiresApproval: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}requires_approval'])!,
      approvalDocPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}approval_doc_path']),
      gpsLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_lat'])!,
      gpsLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_lng'])!,
      gpsAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_accuracy'])!,
      gateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gate_id'])!,
      trueTimestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}true_timestamp'])!,
      phoneTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}phone_timestamp'])!,
      clockDeltaMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}clock_delta_ms'])!,
      faceConfidence: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}face_confidence'])!,
      hmacSignature: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hmac_signature'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nonce'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synced_at']),
      isSpoofAttempt: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_spoof_attempt'])!,
    );
  }

  @override
  $GateEventsTable createAlias(String alias) {
    return $GateEventsTable(attachedDatabase, alias);
  }
}

class GateEvent extends DataClass implements Insertable<GateEvent> {
  final String eventId;
  final String studentId;
  final String status;
  final String reason;
  final String? expectedReturnIso;
  final int? expectedDurationMs;
  final bool requiresApproval;
  final String? approvalDocPath;
  final double gpsLat;
  final double gpsLng;
  final double gpsAccuracy;
  final String gateId;
  final String trueTimestamp;
  final String phoneTimestamp;
  final int clockDeltaMs;
  final double faceConfidence;
  final String hmacSignature;
  final String nonce;
  final String syncStatus;
  final int retryCount;
  final String? syncedAt;
  final bool isSpoofAttempt;
  const GateEvent(
      {required this.eventId,
      required this.studentId,
      required this.status,
      required this.reason,
      this.expectedReturnIso,
      this.expectedDurationMs,
      required this.requiresApproval,
      this.approvalDocPath,
      required this.gpsLat,
      required this.gpsLng,
      required this.gpsAccuracy,
      required this.gateId,
      required this.trueTimestamp,
      required this.phoneTimestamp,
      required this.clockDeltaMs,
      required this.faceConfidence,
      required this.hmacSignature,
      required this.nonce,
      required this.syncStatus,
      required this.retryCount,
      this.syncedAt,
      required this.isSpoofAttempt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['student_id'] = Variable<String>(studentId);
    map['status'] = Variable<String>(status);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || expectedReturnIso != null) {
      map['expected_return_iso'] = Variable<String>(expectedReturnIso);
    }
    if (!nullToAbsent || expectedDurationMs != null) {
      map['expected_duration_ms'] = Variable<int>(expectedDurationMs);
    }
    map['requires_approval'] = Variable<bool>(requiresApproval);
    if (!nullToAbsent || approvalDocPath != null) {
      map['approval_doc_path'] = Variable<String>(approvalDocPath);
    }
    map['gps_lat'] = Variable<double>(gpsLat);
    map['gps_lng'] = Variable<double>(gpsLng);
    map['gps_accuracy'] = Variable<double>(gpsAccuracy);
    map['gate_id'] = Variable<String>(gateId);
    map['true_timestamp'] = Variable<String>(trueTimestamp);
    map['phone_timestamp'] = Variable<String>(phoneTimestamp);
    map['clock_delta_ms'] = Variable<int>(clockDeltaMs);
    map['face_confidence'] = Variable<double>(faceConfidence);
    map['hmac_signature'] = Variable<String>(hmacSignature);
    map['nonce'] = Variable<String>(nonce);
    map['sync_status'] = Variable<String>(syncStatus);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<String>(syncedAt);
    }
    map['is_spoof_attempt'] = Variable<bool>(isSpoofAttempt);
    return map;
  }

  GateEventsCompanion toCompanion(bool nullToAbsent) {
    return GateEventsCompanion(
      eventId: Value(eventId),
      studentId: Value(studentId),
      status: Value(status),
      reason: Value(reason),
      expectedReturnIso: expectedReturnIso == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedReturnIso),
      expectedDurationMs: expectedDurationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedDurationMs),
      requiresApproval: Value(requiresApproval),
      approvalDocPath: approvalDocPath == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalDocPath),
      gpsLat: Value(gpsLat),
      gpsLng: Value(gpsLng),
      gpsAccuracy: Value(gpsAccuracy),
      gateId: Value(gateId),
      trueTimestamp: Value(trueTimestamp),
      phoneTimestamp: Value(phoneTimestamp),
      clockDeltaMs: Value(clockDeltaMs),
      faceConfidence: Value(faceConfidence),
      hmacSignature: Value(hmacSignature),
      nonce: Value(nonce),
      syncStatus: Value(syncStatus),
      retryCount: Value(retryCount),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isSpoofAttempt: Value(isSpoofAttempt),
    );
  }

  factory GateEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GateEvent(
      eventId: serializer.fromJson<String>(json['eventId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      status: serializer.fromJson<String>(json['status']),
      reason: serializer.fromJson<String>(json['reason']),
      expectedReturnIso:
          serializer.fromJson<String?>(json['expectedReturnIso']),
      expectedDurationMs: serializer.fromJson<int?>(json['expectedDurationMs']),
      requiresApproval: serializer.fromJson<bool>(json['requiresApproval']),
      approvalDocPath: serializer.fromJson<String?>(json['approvalDocPath']),
      gpsLat: serializer.fromJson<double>(json['gpsLat']),
      gpsLng: serializer.fromJson<double>(json['gpsLng']),
      gpsAccuracy: serializer.fromJson<double>(json['gpsAccuracy']),
      gateId: serializer.fromJson<String>(json['gateId']),
      trueTimestamp: serializer.fromJson<String>(json['trueTimestamp']),
      phoneTimestamp: serializer.fromJson<String>(json['phoneTimestamp']),
      clockDeltaMs: serializer.fromJson<int>(json['clockDeltaMs']),
      faceConfidence: serializer.fromJson<double>(json['faceConfidence']),
      hmacSignature: serializer.fromJson<String>(json['hmacSignature']),
      nonce: serializer.fromJson<String>(json['nonce']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      syncedAt: serializer.fromJson<String?>(json['syncedAt']),
      isSpoofAttempt: serializer.fromJson<bool>(json['isSpoofAttempt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'studentId': serializer.toJson<String>(studentId),
      'status': serializer.toJson<String>(status),
      'reason': serializer.toJson<String>(reason),
      'expectedReturnIso': serializer.toJson<String?>(expectedReturnIso),
      'expectedDurationMs': serializer.toJson<int?>(expectedDurationMs),
      'requiresApproval': serializer.toJson<bool>(requiresApproval),
      'approvalDocPath': serializer.toJson<String?>(approvalDocPath),
      'gpsLat': serializer.toJson<double>(gpsLat),
      'gpsLng': serializer.toJson<double>(gpsLng),
      'gpsAccuracy': serializer.toJson<double>(gpsAccuracy),
      'gateId': serializer.toJson<String>(gateId),
      'trueTimestamp': serializer.toJson<String>(trueTimestamp),
      'phoneTimestamp': serializer.toJson<String>(phoneTimestamp),
      'clockDeltaMs': serializer.toJson<int>(clockDeltaMs),
      'faceConfidence': serializer.toJson<double>(faceConfidence),
      'hmacSignature': serializer.toJson<String>(hmacSignature),
      'nonce': serializer.toJson<String>(nonce),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'retryCount': serializer.toJson<int>(retryCount),
      'syncedAt': serializer.toJson<String?>(syncedAt),
      'isSpoofAttempt': serializer.toJson<bool>(isSpoofAttempt),
    };
  }

  GateEvent copyWith(
          {String? eventId,
          String? studentId,
          String? status,
          String? reason,
          Value<String?> expectedReturnIso = const Value.absent(),
          Value<int?> expectedDurationMs = const Value.absent(),
          bool? requiresApproval,
          Value<String?> approvalDocPath = const Value.absent(),
          double? gpsLat,
          double? gpsLng,
          double? gpsAccuracy,
          String? gateId,
          String? trueTimestamp,
          String? phoneTimestamp,
          int? clockDeltaMs,
          double? faceConfidence,
          String? hmacSignature,
          String? nonce,
          String? syncStatus,
          int? retryCount,
          Value<String?> syncedAt = const Value.absent(),
          bool? isSpoofAttempt}) =>
      GateEvent(
        eventId: eventId ?? this.eventId,
        studentId: studentId ?? this.studentId,
        status: status ?? this.status,
        reason: reason ?? this.reason,
        expectedReturnIso: expectedReturnIso.present
            ? expectedReturnIso.value
            : this.expectedReturnIso,
        expectedDurationMs: expectedDurationMs.present
            ? expectedDurationMs.value
            : this.expectedDurationMs,
        requiresApproval: requiresApproval ?? this.requiresApproval,
        approvalDocPath: approvalDocPath.present
            ? approvalDocPath.value
            : this.approvalDocPath,
        gpsLat: gpsLat ?? this.gpsLat,
        gpsLng: gpsLng ?? this.gpsLng,
        gpsAccuracy: gpsAccuracy ?? this.gpsAccuracy,
        gateId: gateId ?? this.gateId,
        trueTimestamp: trueTimestamp ?? this.trueTimestamp,
        phoneTimestamp: phoneTimestamp ?? this.phoneTimestamp,
        clockDeltaMs: clockDeltaMs ?? this.clockDeltaMs,
        faceConfidence: faceConfidence ?? this.faceConfidence,
        hmacSignature: hmacSignature ?? this.hmacSignature,
        nonce: nonce ?? this.nonce,
        syncStatus: syncStatus ?? this.syncStatus,
        retryCount: retryCount ?? this.retryCount,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isSpoofAttempt: isSpoofAttempt ?? this.isSpoofAttempt,
      );
  GateEvent copyWithCompanion(GateEventsCompanion data) {
    return GateEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      expectedReturnIso: data.expectedReturnIso.present
          ? data.expectedReturnIso.value
          : this.expectedReturnIso,
      expectedDurationMs: data.expectedDurationMs.present
          ? data.expectedDurationMs.value
          : this.expectedDurationMs,
      requiresApproval: data.requiresApproval.present
          ? data.requiresApproval.value
          : this.requiresApproval,
      approvalDocPath: data.approvalDocPath.present
          ? data.approvalDocPath.value
          : this.approvalDocPath,
      gpsLat: data.gpsLat.present ? data.gpsLat.value : this.gpsLat,
      gpsLng: data.gpsLng.present ? data.gpsLng.value : this.gpsLng,
      gpsAccuracy:
          data.gpsAccuracy.present ? data.gpsAccuracy.value : this.gpsAccuracy,
      gateId: data.gateId.present ? data.gateId.value : this.gateId,
      trueTimestamp: data.trueTimestamp.present
          ? data.trueTimestamp.value
          : this.trueTimestamp,
      phoneTimestamp: data.phoneTimestamp.present
          ? data.phoneTimestamp.value
          : this.phoneTimestamp,
      clockDeltaMs: data.clockDeltaMs.present
          ? data.clockDeltaMs.value
          : this.clockDeltaMs,
      faceConfidence: data.faceConfidence.present
          ? data.faceConfidence.value
          : this.faceConfidence,
      hmacSignature: data.hmacSignature.present
          ? data.hmacSignature.value
          : this.hmacSignature,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      isSpoofAttempt: data.isSpoofAttempt.present
          ? data.isSpoofAttempt.value
          : this.isSpoofAttempt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GateEvent(')
          ..write('eventId: $eventId, ')
          ..write('studentId: $studentId, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('expectedReturnIso: $expectedReturnIso, ')
          ..write('expectedDurationMs: $expectedDurationMs, ')
          ..write('requiresApproval: $requiresApproval, ')
          ..write('approvalDocPath: $approvalDocPath, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('gpsAccuracy: $gpsAccuracy, ')
          ..write('gateId: $gateId, ')
          ..write('trueTimestamp: $trueTimestamp, ')
          ..write('phoneTimestamp: $phoneTimestamp, ')
          ..write('clockDeltaMs: $clockDeltaMs, ')
          ..write('faceConfidence: $faceConfidence, ')
          ..write('hmacSignature: $hmacSignature, ')
          ..write('nonce: $nonce, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSpoofAttempt: $isSpoofAttempt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        eventId,
        studentId,
        status,
        reason,
        expectedReturnIso,
        expectedDurationMs,
        requiresApproval,
        approvalDocPath,
        gpsLat,
        gpsLng,
        gpsAccuracy,
        gateId,
        trueTimestamp,
        phoneTimestamp,
        clockDeltaMs,
        faceConfidence,
        hmacSignature,
        nonce,
        syncStatus,
        retryCount,
        syncedAt,
        isSpoofAttempt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GateEvent &&
          other.eventId == this.eventId &&
          other.studentId == this.studentId &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.expectedReturnIso == this.expectedReturnIso &&
          other.expectedDurationMs == this.expectedDurationMs &&
          other.requiresApproval == this.requiresApproval &&
          other.approvalDocPath == this.approvalDocPath &&
          other.gpsLat == this.gpsLat &&
          other.gpsLng == this.gpsLng &&
          other.gpsAccuracy == this.gpsAccuracy &&
          other.gateId == this.gateId &&
          other.trueTimestamp == this.trueTimestamp &&
          other.phoneTimestamp == this.phoneTimestamp &&
          other.clockDeltaMs == this.clockDeltaMs &&
          other.faceConfidence == this.faceConfidence &&
          other.hmacSignature == this.hmacSignature &&
          other.nonce == this.nonce &&
          other.syncStatus == this.syncStatus &&
          other.retryCount == this.retryCount &&
          other.syncedAt == this.syncedAt &&
          other.isSpoofAttempt == this.isSpoofAttempt);
}

class GateEventsCompanion extends UpdateCompanion<GateEvent> {
  final Value<String> eventId;
  final Value<String> studentId;
  final Value<String> status;
  final Value<String> reason;
  final Value<String?> expectedReturnIso;
  final Value<int?> expectedDurationMs;
  final Value<bool> requiresApproval;
  final Value<String?> approvalDocPath;
  final Value<double> gpsLat;
  final Value<double> gpsLng;
  final Value<double> gpsAccuracy;
  final Value<String> gateId;
  final Value<String> trueTimestamp;
  final Value<String> phoneTimestamp;
  final Value<int> clockDeltaMs;
  final Value<double> faceConfidence;
  final Value<String> hmacSignature;
  final Value<String> nonce;
  final Value<String> syncStatus;
  final Value<int> retryCount;
  final Value<String?> syncedAt;
  final Value<bool> isSpoofAttempt;
  final Value<int> rowid;
  const GateEventsCompanion({
    this.eventId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.expectedReturnIso = const Value.absent(),
    this.expectedDurationMs = const Value.absent(),
    this.requiresApproval = const Value.absent(),
    this.approvalDocPath = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.gpsAccuracy = const Value.absent(),
    this.gateId = const Value.absent(),
    this.trueTimestamp = const Value.absent(),
    this.phoneTimestamp = const Value.absent(),
    this.clockDeltaMs = const Value.absent(),
    this.faceConfidence = const Value.absent(),
    this.hmacSignature = const Value.absent(),
    this.nonce = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSpoofAttempt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GateEventsCompanion.insert({
    required String eventId,
    required String studentId,
    required String status,
    required String reason,
    this.expectedReturnIso = const Value.absent(),
    this.expectedDurationMs = const Value.absent(),
    this.requiresApproval = const Value.absent(),
    this.approvalDocPath = const Value.absent(),
    required double gpsLat,
    required double gpsLng,
    required double gpsAccuracy,
    required String gateId,
    required String trueTimestamp,
    required String phoneTimestamp,
    required int clockDeltaMs,
    required double faceConfidence,
    required String hmacSignature,
    required String nonce,
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSpoofAttempt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : eventId = Value(eventId),
        studentId = Value(studentId),
        status = Value(status),
        reason = Value(reason),
        gpsLat = Value(gpsLat),
        gpsLng = Value(gpsLng),
        gpsAccuracy = Value(gpsAccuracy),
        gateId = Value(gateId),
        trueTimestamp = Value(trueTimestamp),
        phoneTimestamp = Value(phoneTimestamp),
        clockDeltaMs = Value(clockDeltaMs),
        faceConfidence = Value(faceConfidence),
        hmacSignature = Value(hmacSignature),
        nonce = Value(nonce);
  static Insertable<GateEvent> custom({
    Expression<String>? eventId,
    Expression<String>? studentId,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<String>? expectedReturnIso,
    Expression<int>? expectedDurationMs,
    Expression<bool>? requiresApproval,
    Expression<String>? approvalDocPath,
    Expression<double>? gpsLat,
    Expression<double>? gpsLng,
    Expression<double>? gpsAccuracy,
    Expression<String>? gateId,
    Expression<String>? trueTimestamp,
    Expression<String>? phoneTimestamp,
    Expression<int>? clockDeltaMs,
    Expression<double>? faceConfidence,
    Expression<String>? hmacSignature,
    Expression<String>? nonce,
    Expression<String>? syncStatus,
    Expression<int>? retryCount,
    Expression<String>? syncedAt,
    Expression<bool>? isSpoofAttempt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (studentId != null) 'student_id': studentId,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (expectedReturnIso != null) 'expected_return_iso': expectedReturnIso,
      if (expectedDurationMs != null)
        'expected_duration_ms': expectedDurationMs,
      if (requiresApproval != null) 'requires_approval': requiresApproval,
      if (approvalDocPath != null) 'approval_doc_path': approvalDocPath,
      if (gpsLat != null) 'gps_lat': gpsLat,
      if (gpsLng != null) 'gps_lng': gpsLng,
      if (gpsAccuracy != null) 'gps_accuracy': gpsAccuracy,
      if (gateId != null) 'gate_id': gateId,
      if (trueTimestamp != null) 'true_timestamp': trueTimestamp,
      if (phoneTimestamp != null) 'phone_timestamp': phoneTimestamp,
      if (clockDeltaMs != null) 'clock_delta_ms': clockDeltaMs,
      if (faceConfidence != null) 'face_confidence': faceConfidence,
      if (hmacSignature != null) 'hmac_signature': hmacSignature,
      if (nonce != null) 'nonce': nonce,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isSpoofAttempt != null) 'is_spoof_attempt': isSpoofAttempt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GateEventsCompanion copyWith(
      {Value<String>? eventId,
      Value<String>? studentId,
      Value<String>? status,
      Value<String>? reason,
      Value<String?>? expectedReturnIso,
      Value<int?>? expectedDurationMs,
      Value<bool>? requiresApproval,
      Value<String?>? approvalDocPath,
      Value<double>? gpsLat,
      Value<double>? gpsLng,
      Value<double>? gpsAccuracy,
      Value<String>? gateId,
      Value<String>? trueTimestamp,
      Value<String>? phoneTimestamp,
      Value<int>? clockDeltaMs,
      Value<double>? faceConfidence,
      Value<String>? hmacSignature,
      Value<String>? nonce,
      Value<String>? syncStatus,
      Value<int>? retryCount,
      Value<String?>? syncedAt,
      Value<bool>? isSpoofAttempt,
      Value<int>? rowid}) {
    return GateEventsCompanion(
      eventId: eventId ?? this.eventId,
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      expectedReturnIso: expectedReturnIso ?? this.expectedReturnIso,
      expectedDurationMs: expectedDurationMs ?? this.expectedDurationMs,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      approvalDocPath: approvalDocPath ?? this.approvalDocPath,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      gpsAccuracy: gpsAccuracy ?? this.gpsAccuracy,
      gateId: gateId ?? this.gateId,
      trueTimestamp: trueTimestamp ?? this.trueTimestamp,
      phoneTimestamp: phoneTimestamp ?? this.phoneTimestamp,
      clockDeltaMs: clockDeltaMs ?? this.clockDeltaMs,
      faceConfidence: faceConfidence ?? this.faceConfidence,
      hmacSignature: hmacSignature ?? this.hmacSignature,
      nonce: nonce ?? this.nonce,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      syncedAt: syncedAt ?? this.syncedAt,
      isSpoofAttempt: isSpoofAttempt ?? this.isSpoofAttempt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (expectedReturnIso.present) {
      map['expected_return_iso'] = Variable<String>(expectedReturnIso.value);
    }
    if (expectedDurationMs.present) {
      map['expected_duration_ms'] = Variable<int>(expectedDurationMs.value);
    }
    if (requiresApproval.present) {
      map['requires_approval'] = Variable<bool>(requiresApproval.value);
    }
    if (approvalDocPath.present) {
      map['approval_doc_path'] = Variable<String>(approvalDocPath.value);
    }
    if (gpsLat.present) {
      map['gps_lat'] = Variable<double>(gpsLat.value);
    }
    if (gpsLng.present) {
      map['gps_lng'] = Variable<double>(gpsLng.value);
    }
    if (gpsAccuracy.present) {
      map['gps_accuracy'] = Variable<double>(gpsAccuracy.value);
    }
    if (gateId.present) {
      map['gate_id'] = Variable<String>(gateId.value);
    }
    if (trueTimestamp.present) {
      map['true_timestamp'] = Variable<String>(trueTimestamp.value);
    }
    if (phoneTimestamp.present) {
      map['phone_timestamp'] = Variable<String>(phoneTimestamp.value);
    }
    if (clockDeltaMs.present) {
      map['clock_delta_ms'] = Variable<int>(clockDeltaMs.value);
    }
    if (faceConfidence.present) {
      map['face_confidence'] = Variable<double>(faceConfidence.value);
    }
    if (hmacSignature.present) {
      map['hmac_signature'] = Variable<String>(hmacSignature.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<String>(syncedAt.value);
    }
    if (isSpoofAttempt.present) {
      map['is_spoof_attempt'] = Variable<bool>(isSpoofAttempt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GateEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('studentId: $studentId, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('expectedReturnIso: $expectedReturnIso, ')
          ..write('expectedDurationMs: $expectedDurationMs, ')
          ..write('requiresApproval: $requiresApproval, ')
          ..write('approvalDocPath: $approvalDocPath, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('gpsAccuracy: $gpsAccuracy, ')
          ..write('gateId: $gateId, ')
          ..write('trueTimestamp: $trueTimestamp, ')
          ..write('phoneTimestamp: $phoneTimestamp, ')
          ..write('clockDeltaMs: $clockDeltaMs, ')
          ..write('faceConfidence: $faceConfidence, ')
          ..write('hmacSignature: $hmacSignature, ')
          ..write('nonce: $nonce, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSpoofAttempt: $isSpoofAttempt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpoofAttemptsTable extends SpoofAttempts
    with TableInfo<$SpoofAttemptsTable, SpoofAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpoofAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta =
      const VerificationMeta('attemptId');
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
      'attempt_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gateIdMeta = const VerificationMeta('gateId');
  @override
  late final GeneratedColumn<String> gateId = GeneratedColumn<String>(
      'gate_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _failedStepMeta =
      const VerificationMeta('failedStep');
  @override
  late final GeneratedColumn<String> failedStep = GeneratedColumn<String>(
      'failed_step', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _failureReasonMeta =
      const VerificationMeta('failureReason');
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
      'failure_reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gpsLatMeta = const VerificationMeta('gpsLat');
  @override
  late final GeneratedColumn<double> gpsLat = GeneratedColumn<double>(
      'gps_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _gpsLngMeta = const VerificationMeta('gpsLng');
  @override
  late final GeneratedColumn<double> gpsLng = GeneratedColumn<double>(
      'gps_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _faceScoreMeta =
      const VerificationMeta('faceScore');
  @override
  late final GeneratedColumn<double> faceScore = GeneratedColumn<double>(
      'face_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        attemptId,
        studentId,
        gateId,
        failedStep,
        failureReason,
        gpsLat,
        gpsLng,
        faceScore,
        timestamp,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spoof_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<SpoofAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(_attemptIdMeta,
          attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta));
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    }
    if (data.containsKey('gate_id')) {
      context.handle(_gateIdMeta,
          gateId.isAcceptableOrUnknown(data['gate_id']!, _gateIdMeta));
    }
    if (data.containsKey('failed_step')) {
      context.handle(
          _failedStepMeta,
          failedStep.isAcceptableOrUnknown(
              data['failed_step']!, _failedStepMeta));
    } else if (isInserting) {
      context.missing(_failedStepMeta);
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
          _failureReasonMeta,
          failureReason.isAcceptableOrUnknown(
              data['failure_reason']!, _failureReasonMeta));
    } else if (isInserting) {
      context.missing(_failureReasonMeta);
    }
    if (data.containsKey('gps_lat')) {
      context.handle(_gpsLatMeta,
          gpsLat.isAcceptableOrUnknown(data['gps_lat']!, _gpsLatMeta));
    }
    if (data.containsKey('gps_lng')) {
      context.handle(_gpsLngMeta,
          gpsLng.isAcceptableOrUnknown(data['gps_lng']!, _gpsLngMeta));
    }
    if (data.containsKey('face_score')) {
      context.handle(_faceScoreMeta,
          faceScore.isAcceptableOrUnknown(data['face_score']!, _faceScoreMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId};
  @override
  SpoofAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpoofAttempt(
      attemptId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attempt_id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id']),
      gateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gate_id']),
      failedStep: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}failed_step'])!,
      failureReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}failure_reason'])!,
      gpsLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_lat']),
      gpsLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_lng']),
      faceScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}face_score']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timestamp'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $SpoofAttemptsTable createAlias(String alias) {
    return $SpoofAttemptsTable(attachedDatabase, alias);
  }
}

class SpoofAttempt extends DataClass implements Insertable<SpoofAttempt> {
  final String attemptId;
  final String? studentId;
  final String? gateId;
  final String failedStep;
  final String failureReason;
  final double? gpsLat;
  final double? gpsLng;
  final double? faceScore;
  final String timestamp;
  final bool synced;
  const SpoofAttempt(
      {required this.attemptId,
      this.studentId,
      this.gateId,
      required this.failedStep,
      required this.failureReason,
      this.gpsLat,
      this.gpsLng,
      this.faceScore,
      required this.timestamp,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<String>(studentId);
    }
    if (!nullToAbsent || gateId != null) {
      map['gate_id'] = Variable<String>(gateId);
    }
    map['failed_step'] = Variable<String>(failedStep);
    map['failure_reason'] = Variable<String>(failureReason);
    if (!nullToAbsent || gpsLat != null) {
      map['gps_lat'] = Variable<double>(gpsLat);
    }
    if (!nullToAbsent || gpsLng != null) {
      map['gps_lng'] = Variable<double>(gpsLng);
    }
    if (!nullToAbsent || faceScore != null) {
      map['face_score'] = Variable<double>(faceScore);
    }
    map['timestamp'] = Variable<String>(timestamp);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SpoofAttemptsCompanion toCompanion(bool nullToAbsent) {
    return SpoofAttemptsCompanion(
      attemptId: Value(attemptId),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
      gateId:
          gateId == null && nullToAbsent ? const Value.absent() : Value(gateId),
      failedStep: Value(failedStep),
      failureReason: Value(failureReason),
      gpsLat:
          gpsLat == null && nullToAbsent ? const Value.absent() : Value(gpsLat),
      gpsLng:
          gpsLng == null && nullToAbsent ? const Value.absent() : Value(gpsLng),
      faceScore: faceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(faceScore),
      timestamp: Value(timestamp),
      synced: Value(synced),
    );
  }

  factory SpoofAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpoofAttempt(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      studentId: serializer.fromJson<String?>(json['studentId']),
      gateId: serializer.fromJson<String?>(json['gateId']),
      failedStep: serializer.fromJson<String>(json['failedStep']),
      failureReason: serializer.fromJson<String>(json['failureReason']),
      gpsLat: serializer.fromJson<double?>(json['gpsLat']),
      gpsLng: serializer.fromJson<double?>(json['gpsLng']),
      faceScore: serializer.fromJson<double?>(json['faceScore']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'studentId': serializer.toJson<String?>(studentId),
      'gateId': serializer.toJson<String?>(gateId),
      'failedStep': serializer.toJson<String>(failedStep),
      'failureReason': serializer.toJson<String>(failureReason),
      'gpsLat': serializer.toJson<double?>(gpsLat),
      'gpsLng': serializer.toJson<double?>(gpsLng),
      'faceScore': serializer.toJson<double?>(faceScore),
      'timestamp': serializer.toJson<String>(timestamp),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SpoofAttempt copyWith(
          {String? attemptId,
          Value<String?> studentId = const Value.absent(),
          Value<String?> gateId = const Value.absent(),
          String? failedStep,
          String? failureReason,
          Value<double?> gpsLat = const Value.absent(),
          Value<double?> gpsLng = const Value.absent(),
          Value<double?> faceScore = const Value.absent(),
          String? timestamp,
          bool? synced}) =>
      SpoofAttempt(
        attemptId: attemptId ?? this.attemptId,
        studentId: studentId.present ? studentId.value : this.studentId,
        gateId: gateId.present ? gateId.value : this.gateId,
        failedStep: failedStep ?? this.failedStep,
        failureReason: failureReason ?? this.failureReason,
        gpsLat: gpsLat.present ? gpsLat.value : this.gpsLat,
        gpsLng: gpsLng.present ? gpsLng.value : this.gpsLng,
        faceScore: faceScore.present ? faceScore.value : this.faceScore,
        timestamp: timestamp ?? this.timestamp,
        synced: synced ?? this.synced,
      );
  SpoofAttempt copyWithCompanion(SpoofAttemptsCompanion data) {
    return SpoofAttempt(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      gateId: data.gateId.present ? data.gateId.value : this.gateId,
      failedStep:
          data.failedStep.present ? data.failedStep.value : this.failedStep,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
      gpsLat: data.gpsLat.present ? data.gpsLat.value : this.gpsLat,
      gpsLng: data.gpsLng.present ? data.gpsLng.value : this.gpsLng,
      faceScore: data.faceScore.present ? data.faceScore.value : this.faceScore,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpoofAttempt(')
          ..write('attemptId: $attemptId, ')
          ..write('studentId: $studentId, ')
          ..write('gateId: $gateId, ')
          ..write('failedStep: $failedStep, ')
          ..write('failureReason: $failureReason, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('faceScore: $faceScore, ')
          ..write('timestamp: $timestamp, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(attemptId, studentId, gateId, failedStep,
      failureReason, gpsLat, gpsLng, faceScore, timestamp, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpoofAttempt &&
          other.attemptId == this.attemptId &&
          other.studentId == this.studentId &&
          other.gateId == this.gateId &&
          other.failedStep == this.failedStep &&
          other.failureReason == this.failureReason &&
          other.gpsLat == this.gpsLat &&
          other.gpsLng == this.gpsLng &&
          other.faceScore == this.faceScore &&
          other.timestamp == this.timestamp &&
          other.synced == this.synced);
}

class SpoofAttemptsCompanion extends UpdateCompanion<SpoofAttempt> {
  final Value<String> attemptId;
  final Value<String?> studentId;
  final Value<String?> gateId;
  final Value<String> failedStep;
  final Value<String> failureReason;
  final Value<double?> gpsLat;
  final Value<double?> gpsLng;
  final Value<double?> faceScore;
  final Value<String> timestamp;
  final Value<bool> synced;
  final Value<int> rowid;
  const SpoofAttemptsCompanion({
    this.attemptId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.gateId = const Value.absent(),
    this.failedStep = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.faceScore = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpoofAttemptsCompanion.insert({
    required String attemptId,
    this.studentId = const Value.absent(),
    this.gateId = const Value.absent(),
    required String failedStep,
    required String failureReason,
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.faceScore = const Value.absent(),
    required String timestamp,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : attemptId = Value(attemptId),
        failedStep = Value(failedStep),
        failureReason = Value(failureReason),
        timestamp = Value(timestamp);
  static Insertable<SpoofAttempt> custom({
    Expression<String>? attemptId,
    Expression<String>? studentId,
    Expression<String>? gateId,
    Expression<String>? failedStep,
    Expression<String>? failureReason,
    Expression<double>? gpsLat,
    Expression<double>? gpsLng,
    Expression<double>? faceScore,
    Expression<String>? timestamp,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (studentId != null) 'student_id': studentId,
      if (gateId != null) 'gate_id': gateId,
      if (failedStep != null) 'failed_step': failedStep,
      if (failureReason != null) 'failure_reason': failureReason,
      if (gpsLat != null) 'gps_lat': gpsLat,
      if (gpsLng != null) 'gps_lng': gpsLng,
      if (faceScore != null) 'face_score': faceScore,
      if (timestamp != null) 'timestamp': timestamp,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpoofAttemptsCompanion copyWith(
      {Value<String>? attemptId,
      Value<String?>? studentId,
      Value<String?>? gateId,
      Value<String>? failedStep,
      Value<String>? failureReason,
      Value<double?>? gpsLat,
      Value<double?>? gpsLng,
      Value<double?>? faceScore,
      Value<String>? timestamp,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return SpoofAttemptsCompanion(
      attemptId: attemptId ?? this.attemptId,
      studentId: studentId ?? this.studentId,
      gateId: gateId ?? this.gateId,
      failedStep: failedStep ?? this.failedStep,
      failureReason: failureReason ?? this.failureReason,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      faceScore: faceScore ?? this.faceScore,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (gateId.present) {
      map['gate_id'] = Variable<String>(gateId.value);
    }
    if (failedStep.present) {
      map['failed_step'] = Variable<String>(failedStep.value);
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    if (gpsLat.present) {
      map['gps_lat'] = Variable<double>(gpsLat.value);
    }
    if (gpsLng.present) {
      map['gps_lng'] = Variable<double>(gpsLng.value);
    }
    if (faceScore.present) {
      map['face_score'] = Variable<double>(faceScore.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpoofAttemptsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('studentId: $studentId, ')
          ..write('gateId: $gateId, ')
          ..write('failedStep: $failedStep, ')
          ..write('failureReason: $failureReason, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('faceScore: $faceScore, ')
          ..write('timestamp: $timestamp, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeofenceZonesTable extends GeofenceZones
    with TableInfo<$GeofenceZonesTable, GeofenceZone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeofenceZonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<String> zoneId = GeneratedColumn<String>(
      'zone_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gateIdMeta = const VerificationMeta('gateId');
  @override
  late final GeneratedColumn<String> gateId = GeneratedColumn<String>(
      'gate_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gateNameMeta =
      const VerificationMeta('gateName');
  @override
  late final GeneratedColumn<String> gateName = GeneratedColumn<String>(
      'gate_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _centerLatMeta =
      const VerificationMeta('centerLat');
  @override
  late final GeneratedColumn<double> centerLat = GeneratedColumn<double>(
      'center_lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _centerLngMeta =
      const VerificationMeta('centerLng');
  @override
  late final GeneratedColumn<double> centerLng = GeneratedColumn<double>(
      'center_lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _radiusMetersMeta =
      const VerificationMeta('radiusMeters');
  @override
  late final GeneratedColumn<double> radiusMeters = GeneratedColumn<double>(
      'radius_meters', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [zoneId, gateId, gateName, centerLat, centerLng, radiusMeters, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geofence_zones';
  @override
  VerificationContext validateIntegrity(Insertable<GeofenceZone> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('zone_id')) {
      context.handle(_zoneIdMeta,
          zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta));
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('gate_id')) {
      context.handle(_gateIdMeta,
          gateId.isAcceptableOrUnknown(data['gate_id']!, _gateIdMeta));
    } else if (isInserting) {
      context.missing(_gateIdMeta);
    }
    if (data.containsKey('gate_name')) {
      context.handle(_gateNameMeta,
          gateName.isAcceptableOrUnknown(data['gate_name']!, _gateNameMeta));
    } else if (isInserting) {
      context.missing(_gateNameMeta);
    }
    if (data.containsKey('center_lat')) {
      context.handle(_centerLatMeta,
          centerLat.isAcceptableOrUnknown(data['center_lat']!, _centerLatMeta));
    } else if (isInserting) {
      context.missing(_centerLatMeta);
    }
    if (data.containsKey('center_lng')) {
      context.handle(_centerLngMeta,
          centerLng.isAcceptableOrUnknown(data['center_lng']!, _centerLngMeta));
    } else if (isInserting) {
      context.missing(_centerLngMeta);
    }
    if (data.containsKey('radius_meters')) {
      context.handle(
          _radiusMetersMeta,
          radiusMeters.isAcceptableOrUnknown(
              data['radius_meters']!, _radiusMetersMeta));
    } else if (isInserting) {
      context.missing(_radiusMetersMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {zoneId};
  @override
  GeofenceZone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeofenceZone(
      zoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone_id'])!,
      gateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gate_id'])!,
      gateName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gate_name'])!,
      centerLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}center_lat'])!,
      centerLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}center_lng'])!,
      radiusMeters: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}radius_meters'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GeofenceZonesTable createAlias(String alias) {
    return $GeofenceZonesTable(attachedDatabase, alias);
  }
}

class GeofenceZone extends DataClass implements Insertable<GeofenceZone> {
  final String zoneId;
  final String gateId;
  final String gateName;
  final double centerLat;
  final double centerLng;
  final double radiusMeters;
  final String updatedAt;
  const GeofenceZone(
      {required this.zoneId,
      required this.gateId,
      required this.gateName,
      required this.centerLat,
      required this.centerLng,
      required this.radiusMeters,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['zone_id'] = Variable<String>(zoneId);
    map['gate_id'] = Variable<String>(gateId);
    map['gate_name'] = Variable<String>(gateName);
    map['center_lat'] = Variable<double>(centerLat);
    map['center_lng'] = Variable<double>(centerLng);
    map['radius_meters'] = Variable<double>(radiusMeters);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  GeofenceZonesCompanion toCompanion(bool nullToAbsent) {
    return GeofenceZonesCompanion(
      zoneId: Value(zoneId),
      gateId: Value(gateId),
      gateName: Value(gateName),
      centerLat: Value(centerLat),
      centerLng: Value(centerLng),
      radiusMeters: Value(radiusMeters),
      updatedAt: Value(updatedAt),
    );
  }

  factory GeofenceZone.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeofenceZone(
      zoneId: serializer.fromJson<String>(json['zoneId']),
      gateId: serializer.fromJson<String>(json['gateId']),
      gateName: serializer.fromJson<String>(json['gateName']),
      centerLat: serializer.fromJson<double>(json['centerLat']),
      centerLng: serializer.fromJson<double>(json['centerLng']),
      radiusMeters: serializer.fromJson<double>(json['radiusMeters']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'zoneId': serializer.toJson<String>(zoneId),
      'gateId': serializer.toJson<String>(gateId),
      'gateName': serializer.toJson<String>(gateName),
      'centerLat': serializer.toJson<double>(centerLat),
      'centerLng': serializer.toJson<double>(centerLng),
      'radiusMeters': serializer.toJson<double>(radiusMeters),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  GeofenceZone copyWith(
          {String? zoneId,
          String? gateId,
          String? gateName,
          double? centerLat,
          double? centerLng,
          double? radiusMeters,
          String? updatedAt}) =>
      GeofenceZone(
        zoneId: zoneId ?? this.zoneId,
        gateId: gateId ?? this.gateId,
        gateName: gateName ?? this.gateName,
        centerLat: centerLat ?? this.centerLat,
        centerLng: centerLng ?? this.centerLng,
        radiusMeters: radiusMeters ?? this.radiusMeters,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  GeofenceZone copyWithCompanion(GeofenceZonesCompanion data) {
    return GeofenceZone(
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      gateId: data.gateId.present ? data.gateId.value : this.gateId,
      gateName: data.gateName.present ? data.gateName.value : this.gateName,
      centerLat: data.centerLat.present ? data.centerLat.value : this.centerLat,
      centerLng: data.centerLng.present ? data.centerLng.value : this.centerLng,
      radiusMeters: data.radiusMeters.present
          ? data.radiusMeters.value
          : this.radiusMeters,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeofenceZone(')
          ..write('zoneId: $zoneId, ')
          ..write('gateId: $gateId, ')
          ..write('gateName: $gateName, ')
          ..write('centerLat: $centerLat, ')
          ..write('centerLng: $centerLng, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      zoneId, gateId, gateName, centerLat, centerLng, radiusMeters, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeofenceZone &&
          other.zoneId == this.zoneId &&
          other.gateId == this.gateId &&
          other.gateName == this.gateName &&
          other.centerLat == this.centerLat &&
          other.centerLng == this.centerLng &&
          other.radiusMeters == this.radiusMeters &&
          other.updatedAt == this.updatedAt);
}

class GeofenceZonesCompanion extends UpdateCompanion<GeofenceZone> {
  final Value<String> zoneId;
  final Value<String> gateId;
  final Value<String> gateName;
  final Value<double> centerLat;
  final Value<double> centerLng;
  final Value<double> radiusMeters;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const GeofenceZonesCompanion({
    this.zoneId = const Value.absent(),
    this.gateId = const Value.absent(),
    this.gateName = const Value.absent(),
    this.centerLat = const Value.absent(),
    this.centerLng = const Value.absent(),
    this.radiusMeters = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeofenceZonesCompanion.insert({
    required String zoneId,
    required String gateId,
    required String gateName,
    required double centerLat,
    required double centerLng,
    required double radiusMeters,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : zoneId = Value(zoneId),
        gateId = Value(gateId),
        gateName = Value(gateName),
        centerLat = Value(centerLat),
        centerLng = Value(centerLng),
        radiusMeters = Value(radiusMeters),
        updatedAt = Value(updatedAt);
  static Insertable<GeofenceZone> custom({
    Expression<String>? zoneId,
    Expression<String>? gateId,
    Expression<String>? gateName,
    Expression<double>? centerLat,
    Expression<double>? centerLng,
    Expression<double>? radiusMeters,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (zoneId != null) 'zone_id': zoneId,
      if (gateId != null) 'gate_id': gateId,
      if (gateName != null) 'gate_name': gateName,
      if (centerLat != null) 'center_lat': centerLat,
      if (centerLng != null) 'center_lng': centerLng,
      if (radiusMeters != null) 'radius_meters': radiusMeters,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeofenceZonesCompanion copyWith(
      {Value<String>? zoneId,
      Value<String>? gateId,
      Value<String>? gateName,
      Value<double>? centerLat,
      Value<double>? centerLng,
      Value<double>? radiusMeters,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return GeofenceZonesCompanion(
      zoneId: zoneId ?? this.zoneId,
      gateId: gateId ?? this.gateId,
      gateName: gateName ?? this.gateName,
      centerLat: centerLat ?? this.centerLat,
      centerLng: centerLng ?? this.centerLng,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (zoneId.present) {
      map['zone_id'] = Variable<String>(zoneId.value);
    }
    if (gateId.present) {
      map['gate_id'] = Variable<String>(gateId.value);
    }
    if (gateName.present) {
      map['gate_name'] = Variable<String>(gateName.value);
    }
    if (centerLat.present) {
      map['center_lat'] = Variable<double>(centerLat.value);
    }
    if (centerLng.present) {
      map['center_lng'] = Variable<double>(centerLng.value);
    }
    if (radiusMeters.present) {
      map['radius_meters'] = Variable<double>(radiusMeters.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeofenceZonesCompanion(')
          ..write('zoneId: $zoneId, ')
          ..write('gateId: $gateId, ')
          ..write('gateName: $gateName, ')
          ..write('centerLat: $centerLat, ')
          ..write('centerLng: $centerLng, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GateTokensTable extends GateTokens
    with TableInfo<$GateTokensTable, GateToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GateTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenIdMeta =
      const VerificationMeta('tokenId');
  @override
  late final GeneratedColumn<String> tokenId = GeneratedColumn<String>(
      'token_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gateIdMeta = const VerificationMeta('gateId');
  @override
  late final GeneratedColumn<String> gateId = GeneratedColumn<String>(
      'gate_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tokenHashMeta =
      const VerificationMeta('tokenHash');
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
      'token_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<String> nonce = GeneratedColumn<String>(
      'nonce', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<String> expiresAt = GeneratedColumn<String>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usedMeta = const VerificationMeta('used');
  @override
  late final GeneratedColumn<bool> used = GeneratedColumn<bool>(
      'used', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("used" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [tokenId, gateId, tokenHash, nonce, expiresAt, used];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gate_tokens';
  @override
  VerificationContext validateIntegrity(Insertable<GateToken> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token_id')) {
      context.handle(_tokenIdMeta,
          tokenId.isAcceptableOrUnknown(data['token_id']!, _tokenIdMeta));
    } else if (isInserting) {
      context.missing(_tokenIdMeta);
    }
    if (data.containsKey('gate_id')) {
      context.handle(_gateIdMeta,
          gateId.isAcceptableOrUnknown(data['gate_id']!, _gateIdMeta));
    } else if (isInserting) {
      context.missing(_gateIdMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(_tokenHashMeta,
          tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta));
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
          _nonceMeta, nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta));
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('used')) {
      context.handle(
          _usedMeta, used.isAcceptableOrUnknown(data['used']!, _usedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tokenId};
  @override
  GateToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GateToken(
      tokenId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_id'])!,
      gateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gate_id'])!,
      tokenHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_hash'])!,
      nonce: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nonce'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expires_at'])!,
      used: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}used'])!,
    );
  }

  @override
  $GateTokensTable createAlias(String alias) {
    return $GateTokensTable(attachedDatabase, alias);
  }
}

class GateToken extends DataClass implements Insertable<GateToken> {
  final String tokenId;
  final String gateId;
  final String tokenHash;
  final String nonce;
  final String expiresAt;
  final bool used;
  const GateToken(
      {required this.tokenId,
      required this.gateId,
      required this.tokenHash,
      required this.nonce,
      required this.expiresAt,
      required this.used});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token_id'] = Variable<String>(tokenId);
    map['gate_id'] = Variable<String>(gateId);
    map['token_hash'] = Variable<String>(tokenHash);
    map['nonce'] = Variable<String>(nonce);
    map['expires_at'] = Variable<String>(expiresAt);
    map['used'] = Variable<bool>(used);
    return map;
  }

  GateTokensCompanion toCompanion(bool nullToAbsent) {
    return GateTokensCompanion(
      tokenId: Value(tokenId),
      gateId: Value(gateId),
      tokenHash: Value(tokenHash),
      nonce: Value(nonce),
      expiresAt: Value(expiresAt),
      used: Value(used),
    );
  }

  factory GateToken.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GateToken(
      tokenId: serializer.fromJson<String>(json['tokenId']),
      gateId: serializer.fromJson<String>(json['gateId']),
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      nonce: serializer.fromJson<String>(json['nonce']),
      expiresAt: serializer.fromJson<String>(json['expiresAt']),
      used: serializer.fromJson<bool>(json['used']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tokenId': serializer.toJson<String>(tokenId),
      'gateId': serializer.toJson<String>(gateId),
      'tokenHash': serializer.toJson<String>(tokenHash),
      'nonce': serializer.toJson<String>(nonce),
      'expiresAt': serializer.toJson<String>(expiresAt),
      'used': serializer.toJson<bool>(used),
    };
  }

  GateToken copyWith(
          {String? tokenId,
          String? gateId,
          String? tokenHash,
          String? nonce,
          String? expiresAt,
          bool? used}) =>
      GateToken(
        tokenId: tokenId ?? this.tokenId,
        gateId: gateId ?? this.gateId,
        tokenHash: tokenHash ?? this.tokenHash,
        nonce: nonce ?? this.nonce,
        expiresAt: expiresAt ?? this.expiresAt,
        used: used ?? this.used,
      );
  GateToken copyWithCompanion(GateTokensCompanion data) {
    return GateToken(
      tokenId: data.tokenId.present ? data.tokenId.value : this.tokenId,
      gateId: data.gateId.present ? data.gateId.value : this.gateId,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      used: data.used.present ? data.used.value : this.used,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GateToken(')
          ..write('tokenId: $tokenId, ')
          ..write('gateId: $gateId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('nonce: $nonce, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('used: $used')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tokenId, gateId, tokenHash, nonce, expiresAt, used);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GateToken &&
          other.tokenId == this.tokenId &&
          other.gateId == this.gateId &&
          other.tokenHash == this.tokenHash &&
          other.nonce == this.nonce &&
          other.expiresAt == this.expiresAt &&
          other.used == this.used);
}

class GateTokensCompanion extends UpdateCompanion<GateToken> {
  final Value<String> tokenId;
  final Value<String> gateId;
  final Value<String> tokenHash;
  final Value<String> nonce;
  final Value<String> expiresAt;
  final Value<bool> used;
  final Value<int> rowid;
  const GateTokensCompanion({
    this.tokenId = const Value.absent(),
    this.gateId = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.nonce = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.used = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GateTokensCompanion.insert({
    required String tokenId,
    required String gateId,
    required String tokenHash,
    required String nonce,
    required String expiresAt,
    this.used = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tokenId = Value(tokenId),
        gateId = Value(gateId),
        tokenHash = Value(tokenHash),
        nonce = Value(nonce),
        expiresAt = Value(expiresAt);
  static Insertable<GateToken> custom({
    Expression<String>? tokenId,
    Expression<String>? gateId,
    Expression<String>? tokenHash,
    Expression<String>? nonce,
    Expression<String>? expiresAt,
    Expression<bool>? used,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tokenId != null) 'token_id': tokenId,
      if (gateId != null) 'gate_id': gateId,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (nonce != null) 'nonce': nonce,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (used != null) 'used': used,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GateTokensCompanion copyWith(
      {Value<String>? tokenId,
      Value<String>? gateId,
      Value<String>? tokenHash,
      Value<String>? nonce,
      Value<String>? expiresAt,
      Value<bool>? used,
      Value<int>? rowid}) {
    return GateTokensCompanion(
      tokenId: tokenId ?? this.tokenId,
      gateId: gateId ?? this.gateId,
      tokenHash: tokenHash ?? this.tokenHash,
      nonce: nonce ?? this.nonce,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tokenId.present) {
      map['token_id'] = Variable<String>(tokenId.value);
    }
    if (gateId.present) {
      map['gate_id'] = Variable<String>(gateId.value);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<String>(expiresAt.value);
    }
    if (used.present) {
      map['used'] = Variable<bool>(used.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GateTokensCompanion(')
          ..write('tokenId: $tokenId, ')
          ..write('gateId: $gateId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('nonce: $nonce, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('used: $used, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $GateEventsTable gateEvents = $GateEventsTable(this);
  late final $SpoofAttemptsTable spoofAttempts = $SpoofAttemptsTable(this);
  late final $GeofenceZonesTable geofenceZones = $GeofenceZonesTable(this);
  late final $GateTokensTable gateTokens = $GateTokensTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [students, gateEvents, spoofAttempts, geofenceZones, gateTokens];
}

typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  required String id,
  required String name,
  required String department,
  required String faceHash,
  required String deviceId,
  required String enrolledAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> department,
  Value<String> faceHash,
  Value<String> deviceId,
  Value<String> enrolledAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get faceHash => $composableBuilder(
      column: $table.faceHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enrolledAt => $composableBuilder(
      column: $table.enrolledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get faceHash => $composableBuilder(
      column: $table.faceHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enrolledAt => $composableBuilder(
      column: $table.enrolledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => column);

  GeneratedColumn<String> get faceHash =>
      $composableBuilder(column: $table.faceHash, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get enrolledAt => $composableBuilder(
      column: $table.enrolledAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> department = const Value.absent(),
            Value<String> faceHash = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> enrolledAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            name: name,
            department: department,
            faceHash: faceHash,
            deviceId: deviceId,
            enrolledAt: enrolledAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String department,
            required String faceHash,
            required String deviceId,
            required String enrolledAt,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion.insert(
            id: id,
            name: name,
            department: department,
            faceHash: faceHash,
            deviceId: deviceId,
            enrolledAt: enrolledAt,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()>;
typedef $$GateEventsTableCreateCompanionBuilder = GateEventsCompanion Function({
  required String eventId,
  required String studentId,
  required String status,
  required String reason,
  Value<String?> expectedReturnIso,
  Value<int?> expectedDurationMs,
  Value<bool> requiresApproval,
  Value<String?> approvalDocPath,
  required double gpsLat,
  required double gpsLng,
  required double gpsAccuracy,
  required String gateId,
  required String trueTimestamp,
  required String phoneTimestamp,
  required int clockDeltaMs,
  required double faceConfidence,
  required String hmacSignature,
  required String nonce,
  Value<String> syncStatus,
  Value<int> retryCount,
  Value<String?> syncedAt,
  Value<bool> isSpoofAttempt,
  Value<int> rowid,
});
typedef $$GateEventsTableUpdateCompanionBuilder = GateEventsCompanion Function({
  Value<String> eventId,
  Value<String> studentId,
  Value<String> status,
  Value<String> reason,
  Value<String?> expectedReturnIso,
  Value<int?> expectedDurationMs,
  Value<bool> requiresApproval,
  Value<String?> approvalDocPath,
  Value<double> gpsLat,
  Value<double> gpsLng,
  Value<double> gpsAccuracy,
  Value<String> gateId,
  Value<String> trueTimestamp,
  Value<String> phoneTimestamp,
  Value<int> clockDeltaMs,
  Value<double> faceConfidence,
  Value<String> hmacSignature,
  Value<String> nonce,
  Value<String> syncStatus,
  Value<int> retryCount,
  Value<String?> syncedAt,
  Value<bool> isSpoofAttempt,
  Value<int> rowid,
});

class $$GateEventsTableFilterComposer
    extends Composer<_$AppDatabase, $GateEventsTable> {
  $$GateEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
      column: $table.eventId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expectedReturnIso => $composableBuilder(
      column: $table.expectedReturnIso,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedDurationMs => $composableBuilder(
      column: $table.expectedDurationMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get requiresApproval => $composableBuilder(
      column: $table.requiresApproval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvalDocPath => $composableBuilder(
      column: $table.approvalDocPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsLat => $composableBuilder(
      column: $table.gpsLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsLng => $composableBuilder(
      column: $table.gpsLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsAccuracy => $composableBuilder(
      column: $table.gpsAccuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trueTimestamp => $composableBuilder(
      column: $table.trueTimestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneTimestamp => $composableBuilder(
      column: $table.phoneTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clockDeltaMs => $composableBuilder(
      column: $table.clockDeltaMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get faceConfidence => $composableBuilder(
      column: $table.faceConfidence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hmacSignature => $composableBuilder(
      column: $table.hmacSignature, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSpoofAttempt => $composableBuilder(
      column: $table.isSpoofAttempt,
      builder: (column) => ColumnFilters(column));
}

class $$GateEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $GateEventsTable> {
  $$GateEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
      column: $table.eventId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expectedReturnIso => $composableBuilder(
      column: $table.expectedReturnIso,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedDurationMs => $composableBuilder(
      column: $table.expectedDurationMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get requiresApproval => $composableBuilder(
      column: $table.requiresApproval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvalDocPath => $composableBuilder(
      column: $table.approvalDocPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsLat => $composableBuilder(
      column: $table.gpsLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsLng => $composableBuilder(
      column: $table.gpsLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsAccuracy => $composableBuilder(
      column: $table.gpsAccuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trueTimestamp => $composableBuilder(
      column: $table.trueTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneTimestamp => $composableBuilder(
      column: $table.phoneTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clockDeltaMs => $composableBuilder(
      column: $table.clockDeltaMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get faceConfidence => $composableBuilder(
      column: $table.faceConfidence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hmacSignature => $composableBuilder(
      column: $table.hmacSignature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSpoofAttempt => $composableBuilder(
      column: $table.isSpoofAttempt,
      builder: (column) => ColumnOrderings(column));
}

class $$GateEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GateEventsTable> {
  $$GateEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get expectedReturnIso => $composableBuilder(
      column: $table.expectedReturnIso, builder: (column) => column);

  GeneratedColumn<int> get expectedDurationMs => $composableBuilder(
      column: $table.expectedDurationMs, builder: (column) => column);

  GeneratedColumn<bool> get requiresApproval => $composableBuilder(
      column: $table.requiresApproval, builder: (column) => column);

  GeneratedColumn<String> get approvalDocPath => $composableBuilder(
      column: $table.approvalDocPath, builder: (column) => column);

  GeneratedColumn<double> get gpsLat =>
      $composableBuilder(column: $table.gpsLat, builder: (column) => column);

  GeneratedColumn<double> get gpsLng =>
      $composableBuilder(column: $table.gpsLng, builder: (column) => column);

  GeneratedColumn<double> get gpsAccuracy => $composableBuilder(
      column: $table.gpsAccuracy, builder: (column) => column);

  GeneratedColumn<String> get gateId =>
      $composableBuilder(column: $table.gateId, builder: (column) => column);

  GeneratedColumn<String> get trueTimestamp => $composableBuilder(
      column: $table.trueTimestamp, builder: (column) => column);

  GeneratedColumn<String> get phoneTimestamp => $composableBuilder(
      column: $table.phoneTimestamp, builder: (column) => column);

  GeneratedColumn<int> get clockDeltaMs => $composableBuilder(
      column: $table.clockDeltaMs, builder: (column) => column);

  GeneratedColumn<double> get faceConfidence => $composableBuilder(
      column: $table.faceConfidence, builder: (column) => column);

  GeneratedColumn<String> get hmacSignature => $composableBuilder(
      column: $table.hmacSignature, builder: (column) => column);

  GeneratedColumn<String> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSpoofAttempt => $composableBuilder(
      column: $table.isSpoofAttempt, builder: (column) => column);
}

class $$GateEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GateEventsTable,
    GateEvent,
    $$GateEventsTableFilterComposer,
    $$GateEventsTableOrderingComposer,
    $$GateEventsTableAnnotationComposer,
    $$GateEventsTableCreateCompanionBuilder,
    $$GateEventsTableUpdateCompanionBuilder,
    (GateEvent, BaseReferences<_$AppDatabase, $GateEventsTable, GateEvent>),
    GateEvent,
    PrefetchHooks Function()> {
  $$GateEventsTableTableManager(_$AppDatabase db, $GateEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GateEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GateEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GateEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> eventId = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> expectedReturnIso = const Value.absent(),
            Value<int?> expectedDurationMs = const Value.absent(),
            Value<bool> requiresApproval = const Value.absent(),
            Value<String?> approvalDocPath = const Value.absent(),
            Value<double> gpsLat = const Value.absent(),
            Value<double> gpsLng = const Value.absent(),
            Value<double> gpsAccuracy = const Value.absent(),
            Value<String> gateId = const Value.absent(),
            Value<String> trueTimestamp = const Value.absent(),
            Value<String> phoneTimestamp = const Value.absent(),
            Value<int> clockDeltaMs = const Value.absent(),
            Value<double> faceConfidence = const Value.absent(),
            Value<String> hmacSignature = const Value.absent(),
            Value<String> nonce = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> syncedAt = const Value.absent(),
            Value<bool> isSpoofAttempt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GateEventsCompanion(
            eventId: eventId,
            studentId: studentId,
            status: status,
            reason: reason,
            expectedReturnIso: expectedReturnIso,
            expectedDurationMs: expectedDurationMs,
            requiresApproval: requiresApproval,
            approvalDocPath: approvalDocPath,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            gpsAccuracy: gpsAccuracy,
            gateId: gateId,
            trueTimestamp: trueTimestamp,
            phoneTimestamp: phoneTimestamp,
            clockDeltaMs: clockDeltaMs,
            faceConfidence: faceConfidence,
            hmacSignature: hmacSignature,
            nonce: nonce,
            syncStatus: syncStatus,
            retryCount: retryCount,
            syncedAt: syncedAt,
            isSpoofAttempt: isSpoofAttempt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String eventId,
            required String studentId,
            required String status,
            required String reason,
            Value<String?> expectedReturnIso = const Value.absent(),
            Value<int?> expectedDurationMs = const Value.absent(),
            Value<bool> requiresApproval = const Value.absent(),
            Value<String?> approvalDocPath = const Value.absent(),
            required double gpsLat,
            required double gpsLng,
            required double gpsAccuracy,
            required String gateId,
            required String trueTimestamp,
            required String phoneTimestamp,
            required int clockDeltaMs,
            required double faceConfidence,
            required String hmacSignature,
            required String nonce,
            Value<String> syncStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> syncedAt = const Value.absent(),
            Value<bool> isSpoofAttempt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GateEventsCompanion.insert(
            eventId: eventId,
            studentId: studentId,
            status: status,
            reason: reason,
            expectedReturnIso: expectedReturnIso,
            expectedDurationMs: expectedDurationMs,
            requiresApproval: requiresApproval,
            approvalDocPath: approvalDocPath,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            gpsAccuracy: gpsAccuracy,
            gateId: gateId,
            trueTimestamp: trueTimestamp,
            phoneTimestamp: phoneTimestamp,
            clockDeltaMs: clockDeltaMs,
            faceConfidence: faceConfidence,
            hmacSignature: hmacSignature,
            nonce: nonce,
            syncStatus: syncStatus,
            retryCount: retryCount,
            syncedAt: syncedAt,
            isSpoofAttempt: isSpoofAttempt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GateEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GateEventsTable,
    GateEvent,
    $$GateEventsTableFilterComposer,
    $$GateEventsTableOrderingComposer,
    $$GateEventsTableAnnotationComposer,
    $$GateEventsTableCreateCompanionBuilder,
    $$GateEventsTableUpdateCompanionBuilder,
    (GateEvent, BaseReferences<_$AppDatabase, $GateEventsTable, GateEvent>),
    GateEvent,
    PrefetchHooks Function()>;
typedef $$SpoofAttemptsTableCreateCompanionBuilder = SpoofAttemptsCompanion
    Function({
  required String attemptId,
  Value<String?> studentId,
  Value<String?> gateId,
  required String failedStep,
  required String failureReason,
  Value<double?> gpsLat,
  Value<double?> gpsLng,
  Value<double?> faceScore,
  required String timestamp,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$SpoofAttemptsTableUpdateCompanionBuilder = SpoofAttemptsCompanion
    Function({
  Value<String> attemptId,
  Value<String?> studentId,
  Value<String?> gateId,
  Value<String> failedStep,
  Value<String> failureReason,
  Value<double?> gpsLat,
  Value<double?> gpsLng,
  Value<double?> faceScore,
  Value<String> timestamp,
  Value<bool> synced,
  Value<int> rowid,
});

class $$SpoofAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $SpoofAttemptsTable> {
  $$SpoofAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attemptId => $composableBuilder(
      column: $table.attemptId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get failedStep => $composableBuilder(
      column: $table.failedStep, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get failureReason => $composableBuilder(
      column: $table.failureReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsLat => $composableBuilder(
      column: $table.gpsLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsLng => $composableBuilder(
      column: $table.gpsLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get faceScore => $composableBuilder(
      column: $table.faceScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$SpoofAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpoofAttemptsTable> {
  $$SpoofAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attemptId => $composableBuilder(
      column: $table.attemptId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get failedStep => $composableBuilder(
      column: $table.failedStep, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get failureReason => $composableBuilder(
      column: $table.failureReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsLat => $composableBuilder(
      column: $table.gpsLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsLng => $composableBuilder(
      column: $table.gpsLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get faceScore => $composableBuilder(
      column: $table.faceScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$SpoofAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpoofAttemptsTable> {
  $$SpoofAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get gateId =>
      $composableBuilder(column: $table.gateId, builder: (column) => column);

  GeneratedColumn<String> get failedStep => $composableBuilder(
      column: $table.failedStep, builder: (column) => column);

  GeneratedColumn<String> get failureReason => $composableBuilder(
      column: $table.failureReason, builder: (column) => column);

  GeneratedColumn<double> get gpsLat =>
      $composableBuilder(column: $table.gpsLat, builder: (column) => column);

  GeneratedColumn<double> get gpsLng =>
      $composableBuilder(column: $table.gpsLng, builder: (column) => column);

  GeneratedColumn<double> get faceScore =>
      $composableBuilder(column: $table.faceScore, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$SpoofAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpoofAttemptsTable,
    SpoofAttempt,
    $$SpoofAttemptsTableFilterComposer,
    $$SpoofAttemptsTableOrderingComposer,
    $$SpoofAttemptsTableAnnotationComposer,
    $$SpoofAttemptsTableCreateCompanionBuilder,
    $$SpoofAttemptsTableUpdateCompanionBuilder,
    (
      SpoofAttempt,
      BaseReferences<_$AppDatabase, $SpoofAttemptsTable, SpoofAttempt>
    ),
    SpoofAttempt,
    PrefetchHooks Function()> {
  $$SpoofAttemptsTableTableManager(_$AppDatabase db, $SpoofAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpoofAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpoofAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpoofAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> attemptId = const Value.absent(),
            Value<String?> studentId = const Value.absent(),
            Value<String?> gateId = const Value.absent(),
            Value<String> failedStep = const Value.absent(),
            Value<String> failureReason = const Value.absent(),
            Value<double?> gpsLat = const Value.absent(),
            Value<double?> gpsLng = const Value.absent(),
            Value<double?> faceScore = const Value.absent(),
            Value<String> timestamp = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpoofAttemptsCompanion(
            attemptId: attemptId,
            studentId: studentId,
            gateId: gateId,
            failedStep: failedStep,
            failureReason: failureReason,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            faceScore: faceScore,
            timestamp: timestamp,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String attemptId,
            Value<String?> studentId = const Value.absent(),
            Value<String?> gateId = const Value.absent(),
            required String failedStep,
            required String failureReason,
            Value<double?> gpsLat = const Value.absent(),
            Value<double?> gpsLng = const Value.absent(),
            Value<double?> faceScore = const Value.absent(),
            required String timestamp,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpoofAttemptsCompanion.insert(
            attemptId: attemptId,
            studentId: studentId,
            gateId: gateId,
            failedStep: failedStep,
            failureReason: failureReason,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            faceScore: faceScore,
            timestamp: timestamp,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpoofAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpoofAttemptsTable,
    SpoofAttempt,
    $$SpoofAttemptsTableFilterComposer,
    $$SpoofAttemptsTableOrderingComposer,
    $$SpoofAttemptsTableAnnotationComposer,
    $$SpoofAttemptsTableCreateCompanionBuilder,
    $$SpoofAttemptsTableUpdateCompanionBuilder,
    (
      SpoofAttempt,
      BaseReferences<_$AppDatabase, $SpoofAttemptsTable, SpoofAttempt>
    ),
    SpoofAttempt,
    PrefetchHooks Function()>;
typedef $$GeofenceZonesTableCreateCompanionBuilder = GeofenceZonesCompanion
    Function({
  required String zoneId,
  required String gateId,
  required String gateName,
  required double centerLat,
  required double centerLng,
  required double radiusMeters,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$GeofenceZonesTableUpdateCompanionBuilder = GeofenceZonesCompanion
    Function({
  Value<String> zoneId,
  Value<String> gateId,
  Value<String> gateName,
  Value<double> centerLat,
  Value<double> centerLng,
  Value<double> radiusMeters,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$GeofenceZonesTableFilterComposer
    extends Composer<_$AppDatabase, $GeofenceZonesTable> {
  $$GeofenceZonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get zoneId => $composableBuilder(
      column: $table.zoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gateName => $composableBuilder(
      column: $table.gateName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get centerLat => $composableBuilder(
      column: $table.centerLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get centerLng => $composableBuilder(
      column: $table.centerLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get radiusMeters => $composableBuilder(
      column: $table.radiusMeters, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$GeofenceZonesTableOrderingComposer
    extends Composer<_$AppDatabase, $GeofenceZonesTable> {
  $$GeofenceZonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get zoneId => $composableBuilder(
      column: $table.zoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gateName => $composableBuilder(
      column: $table.gateName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get centerLat => $composableBuilder(
      column: $table.centerLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get centerLng => $composableBuilder(
      column: $table.centerLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get radiusMeters => $composableBuilder(
      column: $table.radiusMeters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$GeofenceZonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeofenceZonesTable> {
  $$GeofenceZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<String> get gateId =>
      $composableBuilder(column: $table.gateId, builder: (column) => column);

  GeneratedColumn<String> get gateName =>
      $composableBuilder(column: $table.gateName, builder: (column) => column);

  GeneratedColumn<double> get centerLat =>
      $composableBuilder(column: $table.centerLat, builder: (column) => column);

  GeneratedColumn<double> get centerLng =>
      $composableBuilder(column: $table.centerLng, builder: (column) => column);

  GeneratedColumn<double> get radiusMeters => $composableBuilder(
      column: $table.radiusMeters, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GeofenceZonesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GeofenceZonesTable,
    GeofenceZone,
    $$GeofenceZonesTableFilterComposer,
    $$GeofenceZonesTableOrderingComposer,
    $$GeofenceZonesTableAnnotationComposer,
    $$GeofenceZonesTableCreateCompanionBuilder,
    $$GeofenceZonesTableUpdateCompanionBuilder,
    (
      GeofenceZone,
      BaseReferences<_$AppDatabase, $GeofenceZonesTable, GeofenceZone>
    ),
    GeofenceZone,
    PrefetchHooks Function()> {
  $$GeofenceZonesTableTableManager(_$AppDatabase db, $GeofenceZonesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeofenceZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeofenceZonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeofenceZonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> zoneId = const Value.absent(),
            Value<String> gateId = const Value.absent(),
            Value<String> gateName = const Value.absent(),
            Value<double> centerLat = const Value.absent(),
            Value<double> centerLng = const Value.absent(),
            Value<double> radiusMeters = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GeofenceZonesCompanion(
            zoneId: zoneId,
            gateId: gateId,
            gateName: gateName,
            centerLat: centerLat,
            centerLng: centerLng,
            radiusMeters: radiusMeters,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String zoneId,
            required String gateId,
            required String gateName,
            required double centerLat,
            required double centerLng,
            required double radiusMeters,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GeofenceZonesCompanion.insert(
            zoneId: zoneId,
            gateId: gateId,
            gateName: gateName,
            centerLat: centerLat,
            centerLng: centerLng,
            radiusMeters: radiusMeters,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GeofenceZonesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GeofenceZonesTable,
    GeofenceZone,
    $$GeofenceZonesTableFilterComposer,
    $$GeofenceZonesTableOrderingComposer,
    $$GeofenceZonesTableAnnotationComposer,
    $$GeofenceZonesTableCreateCompanionBuilder,
    $$GeofenceZonesTableUpdateCompanionBuilder,
    (
      GeofenceZone,
      BaseReferences<_$AppDatabase, $GeofenceZonesTable, GeofenceZone>
    ),
    GeofenceZone,
    PrefetchHooks Function()>;
typedef $$GateTokensTableCreateCompanionBuilder = GateTokensCompanion Function({
  required String tokenId,
  required String gateId,
  required String tokenHash,
  required String nonce,
  required String expiresAt,
  Value<bool> used,
  Value<int> rowid,
});
typedef $$GateTokensTableUpdateCompanionBuilder = GateTokensCompanion Function({
  Value<String> tokenId,
  Value<String> gateId,
  Value<String> tokenHash,
  Value<String> nonce,
  Value<String> expiresAt,
  Value<bool> used,
  Value<int> rowid,
});

class $$GateTokensTableFilterComposer
    extends Composer<_$AppDatabase, $GateTokensTable> {
  $$GateTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tokenId => $composableBuilder(
      column: $table.tokenId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tokenHash => $composableBuilder(
      column: $table.tokenHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get used => $composableBuilder(
      column: $table.used, builder: (column) => ColumnFilters(column));
}

class $$GateTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $GateTokensTable> {
  $$GateTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tokenId => $composableBuilder(
      column: $table.tokenId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gateId => $composableBuilder(
      column: $table.gateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tokenHash => $composableBuilder(
      column: $table.tokenHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nonce => $composableBuilder(
      column: $table.nonce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get used => $composableBuilder(
      column: $table.used, builder: (column) => ColumnOrderings(column));
}

class $$GateTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $GateTokensTable> {
  $$GateTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tokenId =>
      $composableBuilder(column: $table.tokenId, builder: (column) => column);

  GeneratedColumn<String> get gateId =>
      $composableBuilder(column: $table.gateId, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<String> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<String> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get used =>
      $composableBuilder(column: $table.used, builder: (column) => column);
}

class $$GateTokensTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GateTokensTable,
    GateToken,
    $$GateTokensTableFilterComposer,
    $$GateTokensTableOrderingComposer,
    $$GateTokensTableAnnotationComposer,
    $$GateTokensTableCreateCompanionBuilder,
    $$GateTokensTableUpdateCompanionBuilder,
    (GateToken, BaseReferences<_$AppDatabase, $GateTokensTable, GateToken>),
    GateToken,
    PrefetchHooks Function()> {
  $$GateTokensTableTableManager(_$AppDatabase db, $GateTokensTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GateTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GateTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GateTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> tokenId = const Value.absent(),
            Value<String> gateId = const Value.absent(),
            Value<String> tokenHash = const Value.absent(),
            Value<String> nonce = const Value.absent(),
            Value<String> expiresAt = const Value.absent(),
            Value<bool> used = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GateTokensCompanion(
            tokenId: tokenId,
            gateId: gateId,
            tokenHash: tokenHash,
            nonce: nonce,
            expiresAt: expiresAt,
            used: used,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String tokenId,
            required String gateId,
            required String tokenHash,
            required String nonce,
            required String expiresAt,
            Value<bool> used = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GateTokensCompanion.insert(
            tokenId: tokenId,
            gateId: gateId,
            tokenHash: tokenHash,
            nonce: nonce,
            expiresAt: expiresAt,
            used: used,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GateTokensTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GateTokensTable,
    GateToken,
    $$GateTokensTableFilterComposer,
    $$GateTokensTableOrderingComposer,
    $$GateTokensTableAnnotationComposer,
    $$GateTokensTableCreateCompanionBuilder,
    $$GateTokensTableUpdateCompanionBuilder,
    (GateToken, BaseReferences<_$AppDatabase, $GateTokensTable, GateToken>),
    GateToken,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$GateEventsTableTableManager get gateEvents =>
      $$GateEventsTableTableManager(_db, _db.gateEvents);
  $$SpoofAttemptsTableTableManager get spoofAttempts =>
      $$SpoofAttemptsTableTableManager(_db, _db.spoofAttempts);
  $$GeofenceZonesTableTableManager get geofenceZones =>
      $$GeofenceZonesTableTableManager(_db, _db.geofenceZones);
  $$GateTokensTableTableManager get gateTokens =>
      $$GateTokensTableTableManager(_db, _db.gateTokens);
}
