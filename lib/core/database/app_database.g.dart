// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CallRecordsTable extends CallRecords
    with TableInfo<$CallRecordsTable, CallRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _callerNameMeta =
      const VerificationMeta('callerName');
  @override
  late final GeneratedColumn<String> callerName = GeneratedColumn<String>(
      'caller_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _handlingModeMeta =
      const VerificationMeta('handlingMode');
  @override
  late final GeneratedColumn<String> handlingMode = GeneratedColumn<String>(
      'handling_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cloud'));
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('en'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('answered_by_ai'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phoneNumber,
        callerName,
        startTime,
        endTime,
        duration,
        handlingMode,
        language,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'call_records';
  @override
  VerificationContext validateIntegrity(Insertable<CallRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('caller_name')) {
      context.handle(
          _callerNameMeta,
          callerName.isAcceptableOrUnknown(
              data['caller_name']!, _callerNameMeta));
    } else if (isInserting) {
      context.missing(_callerNameMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('handling_mode')) {
      context.handle(
          _handlingModeMeta,
          handlingMode.isAcceptableOrUnknown(
              data['handling_mode']!, _handlingModeMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number'])!,
      callerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caller_name'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      handlingMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}handling_mode'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $CallRecordsTable createAlias(String alias) {
    return $CallRecordsTable(attachedDatabase, alias);
  }
}

class CallRecord extends DataClass implements Insertable<CallRecord> {
  final String id;
  final String phoneNumber;
  final String callerName;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration;
  final String handlingMode;
  final String language;
  final String status;
  const CallRecord(
      {required this.id,
      required this.phoneNumber,
      required this.callerName,
      required this.startTime,
      this.endTime,
      required this.duration,
      required this.handlingMode,
      required this.language,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['caller_name'] = Variable<String>(callerName);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['duration'] = Variable<int>(duration);
    map['handling_mode'] = Variable<String>(handlingMode);
    map['language'] = Variable<String>(language);
    map['status'] = Variable<String>(status);
    return map;
  }

  CallRecordsCompanion toCompanion(bool nullToAbsent) {
    return CallRecordsCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      callerName: Value(callerName),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      duration: Value(duration),
      handlingMode: Value(handlingMode),
      language: Value(language),
      status: Value(status),
    );
  }

  factory CallRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallRecord(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      callerName: serializer.fromJson<String>(json['callerName']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      duration: serializer.fromJson<int>(json['duration']),
      handlingMode: serializer.fromJson<String>(json['handlingMode']),
      language: serializer.fromJson<String>(json['language']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'callerName': serializer.toJson<String>(callerName),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'duration': serializer.toJson<int>(duration),
      'handlingMode': serializer.toJson<String>(handlingMode),
      'language': serializer.toJson<String>(language),
      'status': serializer.toJson<String>(status),
    };
  }

  CallRecord copyWith(
          {String? id,
          String? phoneNumber,
          String? callerName,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          int? duration,
          String? handlingMode,
          String? language,
          String? status}) =>
      CallRecord(
        id: id ?? this.id,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        callerName: callerName ?? this.callerName,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        duration: duration ?? this.duration,
        handlingMode: handlingMode ?? this.handlingMode,
        language: language ?? this.language,
        status: status ?? this.status,
      );
  CallRecord copyWithCompanion(CallRecordsCompanion data) {
    return CallRecord(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      callerName:
          data.callerName.present ? data.callerName.value : this.callerName,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      handlingMode: data.handlingMode.present
          ? data.handlingMode.value
          : this.handlingMode,
      language: data.language.present ? data.language.value : this.language,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallRecord(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('callerName: $callerName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('handlingMode: $handlingMode, ')
          ..write('language: $language, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phoneNumber, callerName, startTime,
      endTime, duration, handlingMode, language, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallRecord &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.callerName == this.callerName &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.duration == this.duration &&
          other.handlingMode == this.handlingMode &&
          other.language == this.language &&
          other.status == this.status);
}

class CallRecordsCompanion extends UpdateCompanion<CallRecord> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String> callerName;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> duration;
  final Value<String> handlingMode;
  final Value<String> language;
  final Value<String> status;
  final Value<int> rowid;
  const CallRecordsCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.callerName = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.handlingMode = const Value.absent(),
    this.language = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallRecordsCompanion.insert({
    required String id,
    required String phoneNumber,
    required String callerName,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.handlingMode = const Value.absent(),
    this.language = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        phoneNumber = Value(phoneNumber),
        callerName = Value(callerName),
        startTime = Value(startTime);
  static Insertable<CallRecord> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? callerName,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? duration,
    Expression<String>? handlingMode,
    Expression<String>? language,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (callerName != null) 'caller_name': callerName,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'duration': duration,
      if (handlingMode != null) 'handling_mode': handlingMode,
      if (language != null) 'language': language,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? phoneNumber,
      Value<String>? callerName,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<int>? duration,
      Value<String>? handlingMode,
      Value<String>? language,
      Value<String>? status,
      Value<int>? rowid}) {
    return CallRecordsCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      callerName: callerName ?? this.callerName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      handlingMode: handlingMode ?? this.handlingMode,
      language: language ?? this.language,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (callerName.present) {
      map['caller_name'] = Variable<String>(callerName.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (handlingMode.present) {
      map['handling_mode'] = Variable<String>(handlingMode.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallRecordsCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('callerName: $callerName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('handlingMode: $handlingMode, ')
          ..write('language: $language, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TranscriptSegmentsTable extends TranscriptSegments
    with TableInfo<$TranscriptSegmentsTable, TranscriptSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranscriptSegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _callIdMeta = const VerificationMeta('callId');
  @override
  late final GeneratedColumn<String> callId = GeneratedColumn<String>(
      'call_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speakerMeta =
      const VerificationMeta('speaker');
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
      'speaker', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, callId, speaker, textContent, timestamp, language];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transcript_segments';
  @override
  VerificationContext validateIntegrity(Insertable<TranscriptSegment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('call_id')) {
      context.handle(_callIdMeta,
          callId.isAcceptableOrUnknown(data['call_id']!, _callIdMeta));
    } else if (isInserting) {
      context.missing(_callIdMeta);
    }
    if (data.containsKey('speaker')) {
      context.handle(_speakerMeta,
          speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta));
    } else if (isInserting) {
      context.missing(_speakerMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_textContentMeta,
          textContent.isAcceptableOrUnknown(data['text']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranscriptSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranscriptSegment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      callId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}call_id'])!,
      speaker: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}speaker'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
    );
  }

  @override
  $TranscriptSegmentsTable createAlias(String alias) {
    return $TranscriptSegmentsTable(attachedDatabase, alias);
  }
}

class TranscriptSegment extends DataClass
    implements Insertable<TranscriptSegment> {
  final String id;
  final String callId;
  final String speaker;
  final String textContent;
  final DateTime timestamp;
  final String language;
  const TranscriptSegment(
      {required this.id,
      required this.callId,
      required this.speaker,
      required this.textContent,
      required this.timestamp,
      required this.language});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['call_id'] = Variable<String>(callId);
    map['speaker'] = Variable<String>(speaker);
    map['text'] = Variable<String>(textContent);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['language'] = Variable<String>(language);
    return map;
  }

  TranscriptSegmentsCompanion toCompanion(bool nullToAbsent) {
    return TranscriptSegmentsCompanion(
      id: Value(id),
      callId: Value(callId),
      speaker: Value(speaker),
      textContent: Value(textContent),
      timestamp: Value(timestamp),
      language: Value(language),
    );
  }

  factory TranscriptSegment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranscriptSegment(
      id: serializer.fromJson<String>(json['id']),
      callId: serializer.fromJson<String>(json['callId']),
      speaker: serializer.fromJson<String>(json['speaker']),
      textContent: serializer.fromJson<String>(json['textContent']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      language: serializer.fromJson<String>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'callId': serializer.toJson<String>(callId),
      'speaker': serializer.toJson<String>(speaker),
      'textContent': serializer.toJson<String>(textContent),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'language': serializer.toJson<String>(language),
    };
  }

  TranscriptSegment copyWith(
          {String? id,
          String? callId,
          String? speaker,
          String? textContent,
          DateTime? timestamp,
          String? language}) =>
      TranscriptSegment(
        id: id ?? this.id,
        callId: callId ?? this.callId,
        speaker: speaker ?? this.speaker,
        textContent: textContent ?? this.textContent,
        timestamp: timestamp ?? this.timestamp,
        language: language ?? this.language,
      );
  TranscriptSegment copyWithCompanion(TranscriptSegmentsCompanion data) {
    return TranscriptSegment(
      id: data.id.present ? data.id.value : this.id,
      callId: data.callId.present ? data.callId.value : this.callId,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptSegment(')
          ..write('id: $id, ')
          ..write('callId: $callId, ')
          ..write('speaker: $speaker, ')
          ..write('textContent: $textContent, ')
          ..write('timestamp: $timestamp, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, callId, speaker, textContent, timestamp, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranscriptSegment &&
          other.id == this.id &&
          other.callId == this.callId &&
          other.speaker == this.speaker &&
          other.textContent == this.textContent &&
          other.timestamp == this.timestamp &&
          other.language == this.language);
}

class TranscriptSegmentsCompanion extends UpdateCompanion<TranscriptSegment> {
  final Value<String> id;
  final Value<String> callId;
  final Value<String> speaker;
  final Value<String> textContent;
  final Value<DateTime> timestamp;
  final Value<String> language;
  final Value<int> rowid;
  const TranscriptSegmentsCompanion({
    this.id = const Value.absent(),
    this.callId = const Value.absent(),
    this.speaker = const Value.absent(),
    this.textContent = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.language = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranscriptSegmentsCompanion.insert({
    required String id,
    required String callId,
    required String speaker,
    required String textContent,
    required DateTime timestamp,
    required String language,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        callId = Value(callId),
        speaker = Value(speaker),
        textContent = Value(textContent),
        timestamp = Value(timestamp),
        language = Value(language);
  static Insertable<TranscriptSegment> custom({
    Expression<String>? id,
    Expression<String>? callId,
    Expression<String>? speaker,
    Expression<String>? textContent,
    Expression<DateTime>? timestamp,
    Expression<String>? language,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (callId != null) 'call_id': callId,
      if (speaker != null) 'speaker': speaker,
      if (textContent != null) 'text': textContent,
      if (timestamp != null) 'timestamp': timestamp,
      if (language != null) 'language': language,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranscriptSegmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? callId,
      Value<String>? speaker,
      Value<String>? textContent,
      Value<DateTime>? timestamp,
      Value<String>? language,
      Value<int>? rowid}) {
    return TranscriptSegmentsCompanion(
      id: id ?? this.id,
      callId: callId ?? this.callId,
      speaker: speaker ?? this.speaker,
      textContent: textContent ?? this.textContent,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (callId.present) {
      map['call_id'] = Variable<String>(callId.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (textContent.present) {
      map['text'] = Variable<String>(textContent.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptSegmentsCompanion(')
          ..write('id: $id, ')
          ..write('callId: $callId, ')
          ..write('speaker: $speaker, ')
          ..write('textContent: $textContent, ')
          ..write('timestamp: $timestamp, ')
          ..write('language: $language, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CallSummariesTable extends CallSummaries
    with TableInfo<$CallSummariesTable, CallSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _callIdMeta = const VerificationMeta('callId');
  @override
  late final GeneratedColumn<String> callId = GeneratedColumn<String>(
      'call_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intentMeta = const VerificationMeta('intent');
  @override
  late final GeneratedColumn<String> intent = GeneratedColumn<String>(
      'intent', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  static const VerificationMeta _callbackRequiredMeta =
      const VerificationMeta('callbackRequired');
  @override
  late final GeneratedColumn<bool> callbackRequired = GeneratedColumn<bool>(
      'callback_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("callback_required" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _callbackTimeMeta =
      const VerificationMeta('callbackTime');
  @override
  late final GeneratedColumn<DateTime> callbackTime = GeneratedColumn<DateTime>(
      'callback_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _actionItemsMeta =
      const VerificationMeta('actionItems');
  @override
  late final GeneratedColumn<String> actionItems = GeneratedColumn<String>(
      'action_items', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        callId,
        summary,
        intent,
        priority,
        callbackRequired,
        callbackTime,
        actionItems
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'call_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<CallSummary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('call_id')) {
      context.handle(_callIdMeta,
          callId.isAcceptableOrUnknown(data['call_id']!, _callIdMeta));
    } else if (isInserting) {
      context.missing(_callIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('intent')) {
      context.handle(_intentMeta,
          intent.isAcceptableOrUnknown(data['intent']!, _intentMeta));
    } else if (isInserting) {
      context.missing(_intentMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('callback_required')) {
      context.handle(
          _callbackRequiredMeta,
          callbackRequired.isAcceptableOrUnknown(
              data['callback_required']!, _callbackRequiredMeta));
    }
    if (data.containsKey('callback_time')) {
      context.handle(
          _callbackTimeMeta,
          callbackTime.isAcceptableOrUnknown(
              data['callback_time']!, _callbackTimeMeta));
    }
    if (data.containsKey('action_items')) {
      context.handle(
          _actionItemsMeta,
          actionItems.isAcceptableOrUnknown(
              data['action_items']!, _actionItemsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallSummary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      callId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}call_id'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      intent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intent'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      callbackRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}callback_required'])!,
      callbackTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}callback_time']),
      actionItems: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_items']),
    );
  }

  @override
  $CallSummariesTable createAlias(String alias) {
    return $CallSummariesTable(attachedDatabase, alias);
  }
}

class CallSummary extends DataClass implements Insertable<CallSummary> {
  final String id;
  final String callId;
  final String summary;
  final String intent;
  final String priority;
  final bool callbackRequired;
  final DateTime? callbackTime;
  final String? actionItems;
  const CallSummary(
      {required this.id,
      required this.callId,
      required this.summary,
      required this.intent,
      required this.priority,
      required this.callbackRequired,
      this.callbackTime,
      this.actionItems});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['call_id'] = Variable<String>(callId);
    map['summary'] = Variable<String>(summary);
    map['intent'] = Variable<String>(intent);
    map['priority'] = Variable<String>(priority);
    map['callback_required'] = Variable<bool>(callbackRequired);
    if (!nullToAbsent || callbackTime != null) {
      map['callback_time'] = Variable<DateTime>(callbackTime);
    }
    if (!nullToAbsent || actionItems != null) {
      map['action_items'] = Variable<String>(actionItems);
    }
    return map;
  }

  CallSummariesCompanion toCompanion(bool nullToAbsent) {
    return CallSummariesCompanion(
      id: Value(id),
      callId: Value(callId),
      summary: Value(summary),
      intent: Value(intent),
      priority: Value(priority),
      callbackRequired: Value(callbackRequired),
      callbackTime: callbackTime == null && nullToAbsent
          ? const Value.absent()
          : Value(callbackTime),
      actionItems: actionItems == null && nullToAbsent
          ? const Value.absent()
          : Value(actionItems),
    );
  }

  factory CallSummary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallSummary(
      id: serializer.fromJson<String>(json['id']),
      callId: serializer.fromJson<String>(json['callId']),
      summary: serializer.fromJson<String>(json['summary']),
      intent: serializer.fromJson<String>(json['intent']),
      priority: serializer.fromJson<String>(json['priority']),
      callbackRequired: serializer.fromJson<bool>(json['callbackRequired']),
      callbackTime: serializer.fromJson<DateTime?>(json['callbackTime']),
      actionItems: serializer.fromJson<String?>(json['actionItems']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'callId': serializer.toJson<String>(callId),
      'summary': serializer.toJson<String>(summary),
      'intent': serializer.toJson<String>(intent),
      'priority': serializer.toJson<String>(priority),
      'callbackRequired': serializer.toJson<bool>(callbackRequired),
      'callbackTime': serializer.toJson<DateTime?>(callbackTime),
      'actionItems': serializer.toJson<String?>(actionItems),
    };
  }

  CallSummary copyWith(
          {String? id,
          String? callId,
          String? summary,
          String? intent,
          String? priority,
          bool? callbackRequired,
          Value<DateTime?> callbackTime = const Value.absent(),
          Value<String?> actionItems = const Value.absent()}) =>
      CallSummary(
        id: id ?? this.id,
        callId: callId ?? this.callId,
        summary: summary ?? this.summary,
        intent: intent ?? this.intent,
        priority: priority ?? this.priority,
        callbackRequired: callbackRequired ?? this.callbackRequired,
        callbackTime:
            callbackTime.present ? callbackTime.value : this.callbackTime,
        actionItems: actionItems.present ? actionItems.value : this.actionItems,
      );
  CallSummary copyWithCompanion(CallSummariesCompanion data) {
    return CallSummary(
      id: data.id.present ? data.id.value : this.id,
      callId: data.callId.present ? data.callId.value : this.callId,
      summary: data.summary.present ? data.summary.value : this.summary,
      intent: data.intent.present ? data.intent.value : this.intent,
      priority: data.priority.present ? data.priority.value : this.priority,
      callbackRequired: data.callbackRequired.present
          ? data.callbackRequired.value
          : this.callbackRequired,
      callbackTime: data.callbackTime.present
          ? data.callbackTime.value
          : this.callbackTime,
      actionItems:
          data.actionItems.present ? data.actionItems.value : this.actionItems,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallSummary(')
          ..write('id: $id, ')
          ..write('callId: $callId, ')
          ..write('summary: $summary, ')
          ..write('intent: $intent, ')
          ..write('priority: $priority, ')
          ..write('callbackRequired: $callbackRequired, ')
          ..write('callbackTime: $callbackTime, ')
          ..write('actionItems: $actionItems')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, callId, summary, intent, priority,
      callbackRequired, callbackTime, actionItems);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallSummary &&
          other.id == this.id &&
          other.callId == this.callId &&
          other.summary == this.summary &&
          other.intent == this.intent &&
          other.priority == this.priority &&
          other.callbackRequired == this.callbackRequired &&
          other.callbackTime == this.callbackTime &&
          other.actionItems == this.actionItems);
}

class CallSummariesCompanion extends UpdateCompanion<CallSummary> {
  final Value<String> id;
  final Value<String> callId;
  final Value<String> summary;
  final Value<String> intent;
  final Value<String> priority;
  final Value<bool> callbackRequired;
  final Value<DateTime?> callbackTime;
  final Value<String?> actionItems;
  final Value<int> rowid;
  const CallSummariesCompanion({
    this.id = const Value.absent(),
    this.callId = const Value.absent(),
    this.summary = const Value.absent(),
    this.intent = const Value.absent(),
    this.priority = const Value.absent(),
    this.callbackRequired = const Value.absent(),
    this.callbackTime = const Value.absent(),
    this.actionItems = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallSummariesCompanion.insert({
    required String id,
    required String callId,
    required String summary,
    required String intent,
    this.priority = const Value.absent(),
    this.callbackRequired = const Value.absent(),
    this.callbackTime = const Value.absent(),
    this.actionItems = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        callId = Value(callId),
        summary = Value(summary),
        intent = Value(intent);
  static Insertable<CallSummary> custom({
    Expression<String>? id,
    Expression<String>? callId,
    Expression<String>? summary,
    Expression<String>? intent,
    Expression<String>? priority,
    Expression<bool>? callbackRequired,
    Expression<DateTime>? callbackTime,
    Expression<String>? actionItems,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (callId != null) 'call_id': callId,
      if (summary != null) 'summary': summary,
      if (intent != null) 'intent': intent,
      if (priority != null) 'priority': priority,
      if (callbackRequired != null) 'callback_required': callbackRequired,
      if (callbackTime != null) 'callback_time': callbackTime,
      if (actionItems != null) 'action_items': actionItems,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallSummariesCompanion copyWith(
      {Value<String>? id,
      Value<String>? callId,
      Value<String>? summary,
      Value<String>? intent,
      Value<String>? priority,
      Value<bool>? callbackRequired,
      Value<DateTime?>? callbackTime,
      Value<String?>? actionItems,
      Value<int>? rowid}) {
    return CallSummariesCompanion(
      id: id ?? this.id,
      callId: callId ?? this.callId,
      summary: summary ?? this.summary,
      intent: intent ?? this.intent,
      priority: priority ?? this.priority,
      callbackRequired: callbackRequired ?? this.callbackRequired,
      callbackTime: callbackTime ?? this.callbackTime,
      actionItems: actionItems ?? this.actionItems,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (callId.present) {
      map['call_id'] = Variable<String>(callId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (intent.present) {
      map['intent'] = Variable<String>(intent.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (callbackRequired.present) {
      map['callback_required'] = Variable<bool>(callbackRequired.value);
    }
    if (callbackTime.present) {
      map['callback_time'] = Variable<DateTime>(callbackTime.value);
    }
    if (actionItems.present) {
      map['action_items'] = Variable<String>(actionItems.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallSummariesCompanion(')
          ..write('id: $id, ')
          ..write('callId: $callId, ')
          ..write('summary: $summary, ')
          ..write('intent: $intent, ')
          ..write('priority: $priority, ')
          ..write('callbackRequired: $callbackRequired, ')
          ..write('callbackTime: $callbackTime, ')
          ..write('actionItems: $actionItems, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssistantSettingsTable extends AssistantSettings
    with TableInfo<$AssistantSettingsTable, AssistantSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssistantSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _assistantEnabledMeta =
      const VerificationMeta('assistantEnabled');
  @override
  late final GeneratedColumn<bool> assistantEnabled = GeneratedColumn<bool>(
      'assistant_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("assistant_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _preferredLanguageMeta =
      const VerificationMeta('preferredLanguage');
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>('preferred_language', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('auto'));
  static const VerificationMeta _aiModeMeta = const VerificationMeta('aiMode');
  @override
  late final GeneratedColumn<String> aiMode = GeneratedColumn<String>(
      'ai_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cloud'));
  static const VerificationMeta _greetingMessageMeta =
      const VerificationMeta('greetingMessage');
  @override
  late final GeneratedColumn<String> greetingMessage = GeneratedColumn<String>(
      'greeting_message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workingHoursMeta =
      const VerificationMeta('workingHours');
  @override
  late final GeneratedColumn<String> workingHours = GeneratedColumn<String>(
      'working_hours', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('09:00 - 18:00'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        assistantEnabled,
        preferredLanguage,
        aiMode,
        greetingMessage,
        workingHours
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assistant_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AssistantSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('assistant_enabled')) {
      context.handle(
          _assistantEnabledMeta,
          assistantEnabled.isAcceptableOrUnknown(
              data['assistant_enabled']!, _assistantEnabledMeta));
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
          _preferredLanguageMeta,
          preferredLanguage.isAcceptableOrUnknown(
              data['preferred_language']!, _preferredLanguageMeta));
    }
    if (data.containsKey('ai_mode')) {
      context.handle(_aiModeMeta,
          aiMode.isAcceptableOrUnknown(data['ai_mode']!, _aiModeMeta));
    }
    if (data.containsKey('greeting_message')) {
      context.handle(
          _greetingMessageMeta,
          greetingMessage.isAcceptableOrUnknown(
              data['greeting_message']!, _greetingMessageMeta));
    } else if (isInserting) {
      context.missing(_greetingMessageMeta);
    }
    if (data.containsKey('working_hours')) {
      context.handle(
          _workingHoursMeta,
          workingHours.isAcceptableOrUnknown(
              data['working_hours']!, _workingHoursMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssistantSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssistantSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      assistantEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}assistant_enabled'])!,
      preferredLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_language'])!,
      aiMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ai_mode'])!,
      greetingMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}greeting_message'])!,
      workingHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}working_hours'])!,
    );
  }

  @override
  $AssistantSettingsTable createAlias(String alias) {
    return $AssistantSettingsTable(attachedDatabase, alias);
  }
}

class AssistantSetting extends DataClass
    implements Insertable<AssistantSetting> {
  final int id;
  final bool assistantEnabled;
  final String preferredLanguage;
  final String aiMode;
  final String greetingMessage;
  final String workingHours;
  const AssistantSetting(
      {required this.id,
      required this.assistantEnabled,
      required this.preferredLanguage,
      required this.aiMode,
      required this.greetingMessage,
      required this.workingHours});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['assistant_enabled'] = Variable<bool>(assistantEnabled);
    map['preferred_language'] = Variable<String>(preferredLanguage);
    map['ai_mode'] = Variable<String>(aiMode);
    map['greeting_message'] = Variable<String>(greetingMessage);
    map['working_hours'] = Variable<String>(workingHours);
    return map;
  }

  AssistantSettingsCompanion toCompanion(bool nullToAbsent) {
    return AssistantSettingsCompanion(
      id: Value(id),
      assistantEnabled: Value(assistantEnabled),
      preferredLanguage: Value(preferredLanguage),
      aiMode: Value(aiMode),
      greetingMessage: Value(greetingMessage),
      workingHours: Value(workingHours),
    );
  }

  factory AssistantSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssistantSetting(
      id: serializer.fromJson<int>(json['id']),
      assistantEnabled: serializer.fromJson<bool>(json['assistantEnabled']),
      preferredLanguage: serializer.fromJson<String>(json['preferredLanguage']),
      aiMode: serializer.fromJson<String>(json['aiMode']),
      greetingMessage: serializer.fromJson<String>(json['greetingMessage']),
      workingHours: serializer.fromJson<String>(json['workingHours']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assistantEnabled': serializer.toJson<bool>(assistantEnabled),
      'preferredLanguage': serializer.toJson<String>(preferredLanguage),
      'aiMode': serializer.toJson<String>(aiMode),
      'greetingMessage': serializer.toJson<String>(greetingMessage),
      'workingHours': serializer.toJson<String>(workingHours),
    };
  }

  AssistantSetting copyWith(
          {int? id,
          bool? assistantEnabled,
          String? preferredLanguage,
          String? aiMode,
          String? greetingMessage,
          String? workingHours}) =>
      AssistantSetting(
        id: id ?? this.id,
        assistantEnabled: assistantEnabled ?? this.assistantEnabled,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        aiMode: aiMode ?? this.aiMode,
        greetingMessage: greetingMessage ?? this.greetingMessage,
        workingHours: workingHours ?? this.workingHours,
      );
  AssistantSetting copyWithCompanion(AssistantSettingsCompanion data) {
    return AssistantSetting(
      id: data.id.present ? data.id.value : this.id,
      assistantEnabled: data.assistantEnabled.present
          ? data.assistantEnabled.value
          : this.assistantEnabled,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      aiMode: data.aiMode.present ? data.aiMode.value : this.aiMode,
      greetingMessage: data.greetingMessage.present
          ? data.greetingMessage.value
          : this.greetingMessage,
      workingHours: data.workingHours.present
          ? data.workingHours.value
          : this.workingHours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssistantSetting(')
          ..write('id: $id, ')
          ..write('assistantEnabled: $assistantEnabled, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('aiMode: $aiMode, ')
          ..write('greetingMessage: $greetingMessage, ')
          ..write('workingHours: $workingHours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assistantEnabled, preferredLanguage,
      aiMode, greetingMessage, workingHours);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssistantSetting &&
          other.id == this.id &&
          other.assistantEnabled == this.assistantEnabled &&
          other.preferredLanguage == this.preferredLanguage &&
          other.aiMode == this.aiMode &&
          other.greetingMessage == this.greetingMessage &&
          other.workingHours == this.workingHours);
}

class AssistantSettingsCompanion extends UpdateCompanion<AssistantSetting> {
  final Value<int> id;
  final Value<bool> assistantEnabled;
  final Value<String> preferredLanguage;
  final Value<String> aiMode;
  final Value<String> greetingMessage;
  final Value<String> workingHours;
  const AssistantSettingsCompanion({
    this.id = const Value.absent(),
    this.assistantEnabled = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.aiMode = const Value.absent(),
    this.greetingMessage = const Value.absent(),
    this.workingHours = const Value.absent(),
  });
  AssistantSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.assistantEnabled = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.aiMode = const Value.absent(),
    required String greetingMessage,
    this.workingHours = const Value.absent(),
  }) : greetingMessage = Value(greetingMessage);
  static Insertable<AssistantSetting> custom({
    Expression<int>? id,
    Expression<bool>? assistantEnabled,
    Expression<String>? preferredLanguage,
    Expression<String>? aiMode,
    Expression<String>? greetingMessage,
    Expression<String>? workingHours,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assistantEnabled != null) 'assistant_enabled': assistantEnabled,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (aiMode != null) 'ai_mode': aiMode,
      if (greetingMessage != null) 'greeting_message': greetingMessage,
      if (workingHours != null) 'working_hours': workingHours,
    });
  }

  AssistantSettingsCompanion copyWith(
      {Value<int>? id,
      Value<bool>? assistantEnabled,
      Value<String>? preferredLanguage,
      Value<String>? aiMode,
      Value<String>? greetingMessage,
      Value<String>? workingHours}) {
    return AssistantSettingsCompanion(
      id: id ?? this.id,
      assistantEnabled: assistantEnabled ?? this.assistantEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      aiMode: aiMode ?? this.aiMode,
      greetingMessage: greetingMessage ?? this.greetingMessage,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assistantEnabled.present) {
      map['assistant_enabled'] = Variable<bool>(assistantEnabled.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (aiMode.present) {
      map['ai_mode'] = Variable<String>(aiMode.value);
    }
    if (greetingMessage.present) {
      map['greeting_message'] = Variable<String>(greetingMessage.value);
    }
    if (workingHours.present) {
      map['working_hours'] = Variable<String>(workingHours.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssistantSettingsCompanion(')
          ..write('id: $id, ')
          ..write('assistantEnabled: $assistantEnabled, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('aiMode: $aiMode, ')
          ..write('greetingMessage: $greetingMessage, ')
          ..write('workingHours: $workingHours')
          ..write(')'))
        .toString();
  }
}

class $CallbackRemindersTable extends CallbackReminders
    with TableInfo<$CallbackRemindersTable, CallbackReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallbackRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _callIdMeta = const VerificationMeta('callId');
  @override
  late final GeneratedColumn<String> callId = GeneratedColumn<String>(
      'call_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _callerNameMeta =
      const VerificationMeta('callerName');
  @override
  late final GeneratedColumn<String> callerName = GeneratedColumn<String>(
      'caller_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
      'reminder_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reminderStatusMeta =
      const VerificationMeta('reminderStatus');
  @override
  late final GeneratedColumn<String> reminderStatus = GeneratedColumn<String>(
      'reminder_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, callId, callerName, phoneNumber, reminderTime, reminderStatus, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'callback_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<CallbackReminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('call_id')) {
      context.handle(_callIdMeta,
          callId.isAcceptableOrUnknown(data['call_id']!, _callIdMeta));
    } else if (isInserting) {
      context.missing(_callIdMeta);
    }
    if (data.containsKey('caller_name')) {
      context.handle(
          _callerNameMeta,
          callerName.isAcceptableOrUnknown(
              data['caller_name']!, _callerNameMeta));
    } else if (isInserting) {
      context.missing(_callerNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    } else if (isInserting) {
      context.missing(_reminderTimeMeta);
    }
    if (data.containsKey('reminder_status')) {
      context.handle(
          _reminderStatusMeta,
          reminderStatus.isAcceptableOrUnknown(
              data['reminder_status']!, _reminderStatusMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallbackReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallbackReminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      callId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}call_id'])!,
      callerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caller_name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number'])!,
      reminderTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}reminder_time'])!,
      reminderStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reminder_status'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $CallbackRemindersTable createAlias(String alias) {
    return $CallbackRemindersTable(attachedDatabase, alias);
  }
}

class CallbackReminder extends DataClass
    implements Insertable<CallbackReminder> {
  final String id;
  final String callId;
  final String callerName;
  final String phoneNumber;
  final DateTime reminderTime;
  final String reminderStatus;
  final String? note;
  const CallbackReminder(
      {required this.id,
      required this.callId,
      required this.callerName,
      required this.phoneNumber,
      required this.reminderTime,
      required this.reminderStatus,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['call_id'] = Variable<String>(callId);
    map['caller_name'] = Variable<String>(callerName);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['reminder_time'] = Variable<DateTime>(reminderTime);
    map['reminder_status'] = Variable<String>(reminderStatus);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CallbackRemindersCompanion toCompanion(bool nullToAbsent) {
    return CallbackRemindersCompanion(
      id: Value(id),
      callId: Value(callId),
      callerName: Value(callerName),
      phoneNumber: Value(phoneNumber),
      reminderTime: Value(reminderTime),
      reminderStatus: Value(reminderStatus),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CallbackReminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallbackReminder(
      id: serializer.fromJson<String>(json['id']),
      callId: serializer.fromJson<String>(json['callId']),
      callerName: serializer.fromJson<String>(json['callerName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      reminderTime: serializer.fromJson<DateTime>(json['reminderTime']),
      reminderStatus: serializer.fromJson<String>(json['reminderStatus']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'callId': serializer.toJson<String>(callId),
      'callerName': serializer.toJson<String>(callerName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'reminderTime': serializer.toJson<DateTime>(reminderTime),
      'reminderStatus': serializer.toJson<String>(reminderStatus),
      'note': serializer.toJson<String?>(note),
    };
  }

  CallbackReminder copyWith(
          {String? id,
          String? callId,
          String? callerName,
          String? phoneNumber,
          DateTime? reminderTime,
          String? reminderStatus,
          Value<String?> note = const Value.absent()}) =>
      CallbackReminder(
        id: id ?? this.id,
        callId: callId ?? this.callId,
        callerName: callerName ?? this.callerName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        reminderTime: reminderTime ?? this.reminderTime,
        reminderStatus: reminderStatus ?? this.reminderStatus,
        note: note.present ? note.value : this.note,
      );
  CallbackReminder copyWithCompanion(CallbackRemindersCompanion data) {
    return CallbackReminder(
      id: data.id.present ? data.id.value : this.id,
      callId: data.callId.present ? data.callId.value : this.callId,
      callerName:
          data.callerName.present ? data.callerName.value : this.callerName,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      reminderStatus: data.reminderStatus.present
          ? data.reminderStatus.value
          : this.reminderStatus,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallbackReminder(')
          ..write('id: $id, ')
          ..write('callId: $callId, ')
          ..write('callerName: $callerName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderStatus: $reminderStatus, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, callId, callerName, phoneNumber, reminderTime, reminderStatus, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallbackReminder &&
          other.id == this.id &&
          other.callId == this.callId &&
          other.callerName == this.callerName &&
          other.phoneNumber == this.phoneNumber &&
          other.reminderTime == this.reminderTime &&
          other.reminderStatus == this.reminderStatus &&
          other.note == this.note);
}

class CallbackRemindersCompanion extends UpdateCompanion<CallbackReminder> {
  final Value<String> id;
  final Value<String> callId;
  final Value<String> callerName;
  final Value<String> phoneNumber;
  final Value<DateTime> reminderTime;
  final Value<String> reminderStatus;
  final Value<String?> note;
  final Value<int> rowid;
  const CallbackRemindersCompanion({
    this.id = const Value.absent(),
    this.callId = const Value.absent(),
    this.callerName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderStatus = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallbackRemindersCompanion.insert({
    required String id,
    required String callId,
    required String callerName,
    required String phoneNumber,
    required DateTime reminderTime,
    this.reminderStatus = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        callId = Value(callId),
        callerName = Value(callerName),
        phoneNumber = Value(phoneNumber),
        reminderTime = Value(reminderTime);
  static Insertable<CallbackReminder> custom({
    Expression<String>? id,
    Expression<String>? callId,
    Expression<String>? callerName,
    Expression<String>? phoneNumber,
    Expression<DateTime>? reminderTime,
    Expression<String>? reminderStatus,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (callId != null) 'call_id': callId,
      if (callerName != null) 'caller_name': callerName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (reminderStatus != null) 'reminder_status': reminderStatus,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallbackRemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? callId,
      Value<String>? callerName,
      Value<String>? phoneNumber,
      Value<DateTime>? reminderTime,
      Value<String>? reminderStatus,
      Value<String?>? note,
      Value<int>? rowid}) {
    return CallbackRemindersCompanion(
      id: id ?? this.id,
      callId: callId ?? this.callId,
      callerName: callerName ?? this.callerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderStatus: reminderStatus ?? this.reminderStatus,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (callId.present) {
      map['call_id'] = Variable<String>(callId.value);
    }
    if (callerName.present) {
      map['caller_name'] = Variable<String>(callerName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (reminderStatus.present) {
      map['reminder_status'] = Variable<String>(reminderStatus.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallbackRemindersCompanion(')
          ..write('id: $id, ')
          ..write('callId: $callId, ')
          ..write('callerName: $callerName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderStatus: $reminderStatus, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CallRecordsTable callRecords = $CallRecordsTable(this);
  late final $TranscriptSegmentsTable transcriptSegments =
      $TranscriptSegmentsTable(this);
  late final $CallSummariesTable callSummaries = $CallSummariesTable(this);
  late final $AssistantSettingsTable assistantSettings =
      $AssistantSettingsTable(this);
  late final $CallbackRemindersTable callbackReminders =
      $CallbackRemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        callRecords,
        transcriptSegments,
        callSummaries,
        assistantSettings,
        callbackReminders
      ];
}

typedef $$CallRecordsTableCreateCompanionBuilder = CallRecordsCompanion
    Function({
  required String id,
  required String phoneNumber,
  required String callerName,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<int> duration,
  Value<String> handlingMode,
  Value<String> language,
  Value<String> status,
  Value<int> rowid,
});
typedef $$CallRecordsTableUpdateCompanionBuilder = CallRecordsCompanion
    Function({
  Value<String> id,
  Value<String> phoneNumber,
  Value<String> callerName,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<int> duration,
  Value<String> handlingMode,
  Value<String> language,
  Value<String> status,
  Value<int> rowid,
});

class $$CallRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CallRecordsTable> {
  $$CallRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get callerName => $composableBuilder(
      column: $table.callerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get handlingMode => $composableBuilder(
      column: $table.handlingMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$CallRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CallRecordsTable> {
  $$CallRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get callerName => $composableBuilder(
      column: $table.callerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get handlingMode => $composableBuilder(
      column: $table.handlingMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$CallRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallRecordsTable> {
  $$CallRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get callerName => $composableBuilder(
      column: $table.callerName, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get handlingMode => $composableBuilder(
      column: $table.handlingMode, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$CallRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CallRecordsTable,
    CallRecord,
    $$CallRecordsTableFilterComposer,
    $$CallRecordsTableOrderingComposer,
    $$CallRecordsTableAnnotationComposer,
    $$CallRecordsTableCreateCompanionBuilder,
    $$CallRecordsTableUpdateCompanionBuilder,
    (CallRecord, BaseReferences<_$AppDatabase, $CallRecordsTable, CallRecord>),
    CallRecord,
    PrefetchHooks Function()> {
  $$CallRecordsTableTableManager(_$AppDatabase db, $CallRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> phoneNumber = const Value.absent(),
            Value<String> callerName = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<String> handlingMode = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CallRecordsCompanion(
            id: id,
            phoneNumber: phoneNumber,
            callerName: callerName,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            handlingMode: handlingMode,
            language: language,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String phoneNumber,
            required String callerName,
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<String> handlingMode = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CallRecordsCompanion.insert(
            id: id,
            phoneNumber: phoneNumber,
            callerName: callerName,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            handlingMode: handlingMode,
            language: language,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CallRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CallRecordsTable,
    CallRecord,
    $$CallRecordsTableFilterComposer,
    $$CallRecordsTableOrderingComposer,
    $$CallRecordsTableAnnotationComposer,
    $$CallRecordsTableCreateCompanionBuilder,
    $$CallRecordsTableUpdateCompanionBuilder,
    (CallRecord, BaseReferences<_$AppDatabase, $CallRecordsTable, CallRecord>),
    CallRecord,
    PrefetchHooks Function()>;
typedef $$TranscriptSegmentsTableCreateCompanionBuilder
    = TranscriptSegmentsCompanion Function({
  required String id,
  required String callId,
  required String speaker,
  required String textContent,
  required DateTime timestamp,
  required String language,
  Value<int> rowid,
});
typedef $$TranscriptSegmentsTableUpdateCompanionBuilder
    = TranscriptSegmentsCompanion Function({
  Value<String> id,
  Value<String> callId,
  Value<String> speaker,
  Value<String> textContent,
  Value<DateTime> timestamp,
  Value<String> language,
  Value<int> rowid,
});

class $$TranscriptSegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TranscriptSegmentsTable> {
  $$TranscriptSegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get callId => $composableBuilder(
      column: $table.callId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speaker => $composableBuilder(
      column: $table.speaker, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));
}

class $$TranscriptSegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranscriptSegmentsTable> {
  $$TranscriptSegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get callId => $composableBuilder(
      column: $table.callId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speaker => $composableBuilder(
      column: $table.speaker, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));
}

class $$TranscriptSegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranscriptSegmentsTable> {
  $$TranscriptSegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get callId =>
      $composableBuilder(column: $table.callId, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);
}

class $$TranscriptSegmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranscriptSegmentsTable,
    TranscriptSegment,
    $$TranscriptSegmentsTableFilterComposer,
    $$TranscriptSegmentsTableOrderingComposer,
    $$TranscriptSegmentsTableAnnotationComposer,
    $$TranscriptSegmentsTableCreateCompanionBuilder,
    $$TranscriptSegmentsTableUpdateCompanionBuilder,
    (
      TranscriptSegment,
      BaseReferences<_$AppDatabase, $TranscriptSegmentsTable, TranscriptSegment>
    ),
    TranscriptSegment,
    PrefetchHooks Function()> {
  $$TranscriptSegmentsTableTableManager(
      _$AppDatabase db, $TranscriptSegmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranscriptSegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranscriptSegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranscriptSegmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> callId = const Value.absent(),
            Value<String> speaker = const Value.absent(),
            Value<String> textContent = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptSegmentsCompanion(
            id: id,
            callId: callId,
            speaker: speaker,
            textContent: textContent,
            timestamp: timestamp,
            language: language,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String callId,
            required String speaker,
            required String textContent,
            required DateTime timestamp,
            required String language,
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptSegmentsCompanion.insert(
            id: id,
            callId: callId,
            speaker: speaker,
            textContent: textContent,
            timestamp: timestamp,
            language: language,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranscriptSegmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranscriptSegmentsTable,
    TranscriptSegment,
    $$TranscriptSegmentsTableFilterComposer,
    $$TranscriptSegmentsTableOrderingComposer,
    $$TranscriptSegmentsTableAnnotationComposer,
    $$TranscriptSegmentsTableCreateCompanionBuilder,
    $$TranscriptSegmentsTableUpdateCompanionBuilder,
    (
      TranscriptSegment,
      BaseReferences<_$AppDatabase, $TranscriptSegmentsTable, TranscriptSegment>
    ),
    TranscriptSegment,
    PrefetchHooks Function()>;
typedef $$CallSummariesTableCreateCompanionBuilder = CallSummariesCompanion
    Function({
  required String id,
  required String callId,
  required String summary,
  required String intent,
  Value<String> priority,
  Value<bool> callbackRequired,
  Value<DateTime?> callbackTime,
  Value<String?> actionItems,
  Value<int> rowid,
});
typedef $$CallSummariesTableUpdateCompanionBuilder = CallSummariesCompanion
    Function({
  Value<String> id,
  Value<String> callId,
  Value<String> summary,
  Value<String> intent,
  Value<String> priority,
  Value<bool> callbackRequired,
  Value<DateTime?> callbackTime,
  Value<String?> actionItems,
  Value<int> rowid,
});

class $$CallSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $CallSummariesTable> {
  $$CallSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get callId => $composableBuilder(
      column: $table.callId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get intent => $composableBuilder(
      column: $table.intent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get callbackRequired => $composableBuilder(
      column: $table.callbackRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get callbackTime => $composableBuilder(
      column: $table.callbackTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionItems => $composableBuilder(
      column: $table.actionItems, builder: (column) => ColumnFilters(column));
}

class $$CallSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $CallSummariesTable> {
  $$CallSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get callId => $composableBuilder(
      column: $table.callId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intent => $composableBuilder(
      column: $table.intent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get callbackRequired => $composableBuilder(
      column: $table.callbackRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get callbackTime => $composableBuilder(
      column: $table.callbackTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionItems => $composableBuilder(
      column: $table.actionItems, builder: (column) => ColumnOrderings(column));
}

class $$CallSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallSummariesTable> {
  $$CallSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get callId =>
      $composableBuilder(column: $table.callId, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get intent =>
      $composableBuilder(column: $table.intent, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get callbackRequired => $composableBuilder(
      column: $table.callbackRequired, builder: (column) => column);

  GeneratedColumn<DateTime> get callbackTime => $composableBuilder(
      column: $table.callbackTime, builder: (column) => column);

  GeneratedColumn<String> get actionItems => $composableBuilder(
      column: $table.actionItems, builder: (column) => column);
}

class $$CallSummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CallSummariesTable,
    CallSummary,
    $$CallSummariesTableFilterComposer,
    $$CallSummariesTableOrderingComposer,
    $$CallSummariesTableAnnotationComposer,
    $$CallSummariesTableCreateCompanionBuilder,
    $$CallSummariesTableUpdateCompanionBuilder,
    (
      CallSummary,
      BaseReferences<_$AppDatabase, $CallSummariesTable, CallSummary>
    ),
    CallSummary,
    PrefetchHooks Function()> {
  $$CallSummariesTableTableManager(_$AppDatabase db, $CallSummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> callId = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String> intent = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<bool> callbackRequired = const Value.absent(),
            Value<DateTime?> callbackTime = const Value.absent(),
            Value<String?> actionItems = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CallSummariesCompanion(
            id: id,
            callId: callId,
            summary: summary,
            intent: intent,
            priority: priority,
            callbackRequired: callbackRequired,
            callbackTime: callbackTime,
            actionItems: actionItems,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String callId,
            required String summary,
            required String intent,
            Value<String> priority = const Value.absent(),
            Value<bool> callbackRequired = const Value.absent(),
            Value<DateTime?> callbackTime = const Value.absent(),
            Value<String?> actionItems = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CallSummariesCompanion.insert(
            id: id,
            callId: callId,
            summary: summary,
            intent: intent,
            priority: priority,
            callbackRequired: callbackRequired,
            callbackTime: callbackTime,
            actionItems: actionItems,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CallSummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CallSummariesTable,
    CallSummary,
    $$CallSummariesTableFilterComposer,
    $$CallSummariesTableOrderingComposer,
    $$CallSummariesTableAnnotationComposer,
    $$CallSummariesTableCreateCompanionBuilder,
    $$CallSummariesTableUpdateCompanionBuilder,
    (
      CallSummary,
      BaseReferences<_$AppDatabase, $CallSummariesTable, CallSummary>
    ),
    CallSummary,
    PrefetchHooks Function()>;
typedef $$AssistantSettingsTableCreateCompanionBuilder
    = AssistantSettingsCompanion Function({
  Value<int> id,
  Value<bool> assistantEnabled,
  Value<String> preferredLanguage,
  Value<String> aiMode,
  required String greetingMessage,
  Value<String> workingHours,
});
typedef $$AssistantSettingsTableUpdateCompanionBuilder
    = AssistantSettingsCompanion Function({
  Value<int> id,
  Value<bool> assistantEnabled,
  Value<String> preferredLanguage,
  Value<String> aiMode,
  Value<String> greetingMessage,
  Value<String> workingHours,
});

class $$AssistantSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AssistantSettingsTable> {
  $$AssistantSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get assistantEnabled => $composableBuilder(
      column: $table.assistantEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aiMode => $composableBuilder(
      column: $table.aiMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get greetingMessage => $composableBuilder(
      column: $table.greetingMessage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workingHours => $composableBuilder(
      column: $table.workingHours, builder: (column) => ColumnFilters(column));
}

class $$AssistantSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssistantSettingsTable> {
  $$AssistantSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get assistantEnabled => $composableBuilder(
      column: $table.assistantEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aiMode => $composableBuilder(
      column: $table.aiMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get greetingMessage => $composableBuilder(
      column: $table.greetingMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workingHours => $composableBuilder(
      column: $table.workingHours,
      builder: (column) => ColumnOrderings(column));
}

class $$AssistantSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssistantSettingsTable> {
  $$AssistantSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get assistantEnabled => $composableBuilder(
      column: $table.assistantEnabled, builder: (column) => column);

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage, builder: (column) => column);

  GeneratedColumn<String> get aiMode =>
      $composableBuilder(column: $table.aiMode, builder: (column) => column);

  GeneratedColumn<String> get greetingMessage => $composableBuilder(
      column: $table.greetingMessage, builder: (column) => column);

  GeneratedColumn<String> get workingHours => $composableBuilder(
      column: $table.workingHours, builder: (column) => column);
}

class $$AssistantSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssistantSettingsTable,
    AssistantSetting,
    $$AssistantSettingsTableFilterComposer,
    $$AssistantSettingsTableOrderingComposer,
    $$AssistantSettingsTableAnnotationComposer,
    $$AssistantSettingsTableCreateCompanionBuilder,
    $$AssistantSettingsTableUpdateCompanionBuilder,
    (
      AssistantSetting,
      BaseReferences<_$AppDatabase, $AssistantSettingsTable, AssistantSetting>
    ),
    AssistantSetting,
    PrefetchHooks Function()> {
  $$AssistantSettingsTableTableManager(
      _$AppDatabase db, $AssistantSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssistantSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssistantSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssistantSettingsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> assistantEnabled = const Value.absent(),
            Value<String> preferredLanguage = const Value.absent(),
            Value<String> aiMode = const Value.absent(),
            Value<String> greetingMessage = const Value.absent(),
            Value<String> workingHours = const Value.absent(),
          }) =>
              AssistantSettingsCompanion(
            id: id,
            assistantEnabled: assistantEnabled,
            preferredLanguage: preferredLanguage,
            aiMode: aiMode,
            greetingMessage: greetingMessage,
            workingHours: workingHours,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> assistantEnabled = const Value.absent(),
            Value<String> preferredLanguage = const Value.absent(),
            Value<String> aiMode = const Value.absent(),
            required String greetingMessage,
            Value<String> workingHours = const Value.absent(),
          }) =>
              AssistantSettingsCompanion.insert(
            id: id,
            assistantEnabled: assistantEnabled,
            preferredLanguage: preferredLanguage,
            aiMode: aiMode,
            greetingMessage: greetingMessage,
            workingHours: workingHours,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AssistantSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssistantSettingsTable,
    AssistantSetting,
    $$AssistantSettingsTableFilterComposer,
    $$AssistantSettingsTableOrderingComposer,
    $$AssistantSettingsTableAnnotationComposer,
    $$AssistantSettingsTableCreateCompanionBuilder,
    $$AssistantSettingsTableUpdateCompanionBuilder,
    (
      AssistantSetting,
      BaseReferences<_$AppDatabase, $AssistantSettingsTable, AssistantSetting>
    ),
    AssistantSetting,
    PrefetchHooks Function()>;
typedef $$CallbackRemindersTableCreateCompanionBuilder
    = CallbackRemindersCompanion Function({
  required String id,
  required String callId,
  required String callerName,
  required String phoneNumber,
  required DateTime reminderTime,
  Value<String> reminderStatus,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$CallbackRemindersTableUpdateCompanionBuilder
    = CallbackRemindersCompanion Function({
  Value<String> id,
  Value<String> callId,
  Value<String> callerName,
  Value<String> phoneNumber,
  Value<DateTime> reminderTime,
  Value<String> reminderStatus,
  Value<String?> note,
  Value<int> rowid,
});

class $$CallbackRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $CallbackRemindersTable> {
  $$CallbackRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get callId => $composableBuilder(
      column: $table.callId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get callerName => $composableBuilder(
      column: $table.callerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderStatus => $composableBuilder(
      column: $table.reminderStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$CallbackRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $CallbackRemindersTable> {
  $$CallbackRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get callId => $composableBuilder(
      column: $table.callId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get callerName => $composableBuilder(
      column: $table.callerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderStatus => $composableBuilder(
      column: $table.reminderStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$CallbackRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallbackRemindersTable> {
  $$CallbackRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get callId =>
      $composableBuilder(column: $table.callId, builder: (column) => column);

  GeneratedColumn<String> get callerName => $composableBuilder(
      column: $table.callerName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<String> get reminderStatus => $composableBuilder(
      column: $table.reminderStatus, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$CallbackRemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CallbackRemindersTable,
    CallbackReminder,
    $$CallbackRemindersTableFilterComposer,
    $$CallbackRemindersTableOrderingComposer,
    $$CallbackRemindersTableAnnotationComposer,
    $$CallbackRemindersTableCreateCompanionBuilder,
    $$CallbackRemindersTableUpdateCompanionBuilder,
    (
      CallbackReminder,
      BaseReferences<_$AppDatabase, $CallbackRemindersTable, CallbackReminder>
    ),
    CallbackReminder,
    PrefetchHooks Function()> {
  $$CallbackRemindersTableTableManager(
      _$AppDatabase db, $CallbackRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallbackRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallbackRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallbackRemindersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> callId = const Value.absent(),
            Value<String> callerName = const Value.absent(),
            Value<String> phoneNumber = const Value.absent(),
            Value<DateTime> reminderTime = const Value.absent(),
            Value<String> reminderStatus = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CallbackRemindersCompanion(
            id: id,
            callId: callId,
            callerName: callerName,
            phoneNumber: phoneNumber,
            reminderTime: reminderTime,
            reminderStatus: reminderStatus,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String callId,
            required String callerName,
            required String phoneNumber,
            required DateTime reminderTime,
            Value<String> reminderStatus = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CallbackRemindersCompanion.insert(
            id: id,
            callId: callId,
            callerName: callerName,
            phoneNumber: phoneNumber,
            reminderTime: reminderTime,
            reminderStatus: reminderStatus,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CallbackRemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CallbackRemindersTable,
    CallbackReminder,
    $$CallbackRemindersTableFilterComposer,
    $$CallbackRemindersTableOrderingComposer,
    $$CallbackRemindersTableAnnotationComposer,
    $$CallbackRemindersTableCreateCompanionBuilder,
    $$CallbackRemindersTableUpdateCompanionBuilder,
    (
      CallbackReminder,
      BaseReferences<_$AppDatabase, $CallbackRemindersTable, CallbackReminder>
    ),
    CallbackReminder,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CallRecordsTableTableManager get callRecords =>
      $$CallRecordsTableTableManager(_db, _db.callRecords);
  $$TranscriptSegmentsTableTableManager get transcriptSegments =>
      $$TranscriptSegmentsTableTableManager(_db, _db.transcriptSegments);
  $$CallSummariesTableTableManager get callSummaries =>
      $$CallSummariesTableTableManager(_db, _db.callSummaries);
  $$AssistantSettingsTableTableManager get assistantSettings =>
      $$AssistantSettingsTableTableManager(_db, _db.assistantSettings);
  $$CallbackRemindersTableTableManager get callbackReminders =>
      $$CallbackRemindersTableTableManager(_db, _db.callbackReminders);
}
