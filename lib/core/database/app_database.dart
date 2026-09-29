import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// 1. CALL_RECORDS Table
class CallRecords extends Table {
  TextColumn get id => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get callerName => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get duration => integer().withDefault(const Constant(0))();
  TextColumn get handlingMode => text().withDefault(const Constant('cloud'))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  TextColumn get status => text().withDefault(const Constant('answered_by_ai'))();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. TRANSCRIPT_SEGMENTS Table
class TranscriptSegments extends Table {
  TextColumn get id => text()();
  TextColumn get callId => text()();
  TextColumn get speaker => text()(); // 'ai', 'caller', 'user'
  TextColumn get textContent => text().named('text')();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get language => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. CALL_SUMMARIES Table
class CallSummaries extends Table {
  TextColumn get id => text()();
  TextColumn get callId => text()();
  TextColumn get summary => text()();
  TextColumn get intent => text()();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  BoolColumn get callbackRequired => boolean().withDefault(const Constant(false))();
  DateTimeColumn get callbackTime => dateTime().nullable()();
  TextColumn get actionItems => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. ASSISTANT_SETTINGS Table
class AssistantSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get assistantEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get preferredLanguage => text().withDefault(const Constant('auto'))();
  TextColumn get aiMode => text().withDefault(const Constant('cloud'))();
  TextColumn get greetingMessage => text()();
  TextColumn get workingHours => text().withDefault(const Constant('09:00 - 18:00'))();
}

// 5. CALLBACK_REMINDERS Table
class CallbackReminders extends Table {
  TextColumn get id => text()();
  TextColumn get callId => text()();
  TextColumn get callerName => text()();
  TextColumn get phoneNumber => text()();
  DateTimeColumn get reminderTime => dateTime()();
  TextColumn get reminderStatus => text().withDefault(const Constant('pending'))(); // 'pending', 'completed', 'dismissed'
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    CallRecords,
    TranscriptSegments,
    CallSummaries,
    AssistantSettings,
    CallbackReminders,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'aicallassistant_db');
  }

  // --- Migration Strategy ---
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Schema migrations
        },
        beforeOpen: (details) async {
          // Enable foreign keys
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // --- CRUD: CALL RECORDS ---
  Stream<List<CallRecord>> watchAllCalls() {
    return (select(callRecords)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).watch();
  }

  Future<List<CallRecord>> getRecentCalls({int limit = 10}) {
    return (select(callRecords)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<CallRecord?> getCallById(String id) {
    return (select(callRecords)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCall(CallRecordsCompanion entry) {
    return into(callRecords).insert(entry);
  }

  Future<bool> updateCallRecord(CallRecord entry) {
    return update(callRecords).replace(entry);
  }

  Future<int> deleteCallRecord(String id) {
    return (delete(callRecords)..where((t) => t.id.equals(id))).go();
  }

  // --- CRUD: TRANSCRIPT SEGMENTS ---
  Stream<List<TranscriptSegment>> watchTranscriptForCall(String callId) {
    return (select(transcriptSegments)
          ..where((t) => t.callId.equals(callId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .watch();
  }

  Future<List<TranscriptSegment>> getTranscriptForCall(String callId) {
    return (select(transcriptSegments)
          ..where((t) => t.callId.equals(callId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
  }

  Future<int> insertTranscriptSegment(TranscriptSegmentsCompanion segment) {
    return into(transcriptSegments).insert(segment);
  }

  Future<List<TranscriptSegment>> searchTranscripts(String query) {
    return (select(transcriptSegments)
          ..where((t) => t.textContent.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  // --- CRUD: CALL SUMMARIES ---
  Future<CallSummary?> getSummaryForCall(String callId) {
    return (select(callSummaries)..where((t) => t.callId.equals(callId))).getSingleOrNull();
  }

  Stream<CallSummary?> watchSummaryForCall(String callId) {
    return (select(callSummaries)..where((t) => t.callId.equals(callId))).watchSingleOrNull();
  }

  Future<int> insertOrUpdateSummary(CallSummariesCompanion entry) {
    return into(callSummaries).insertOnConflictUpdate(entry);
  }

  // --- CRUD: CALLBACK REMINDERS ---
  Stream<List<CallbackReminder>> watchPendingReminders() {
    return (select(callbackReminders)
          ..where((t) => t.reminderStatus.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.reminderTime)]))
        .watch();
  }

  Future<List<CallbackReminder>> getAllReminders() {
    return (select(callbackReminders)..orderBy([(t) => OrderingTerm.asc(t.reminderTime)])).get();
  }

  Future<int> insertReminder(CallbackRemindersCompanion entry) {
    return into(callbackReminders).insert(entry);
  }

  Future<int> updateReminderStatus(String id, String status) {
    return (update(callbackReminders)..where((t) => t.id.equals(id))).write(
      CallbackRemindersCompanion(reminderStatus: Value(status)),
    );
  }

  Future<int> deleteReminder(String id) {
    return (delete(callbackReminders)..where((t) => t.id.equals(id))).go();
  }

  // Delete all tables data (for privacy wipe)
  Future<void> clearAllData() async {
    await delete(callbackReminders).go();
    await delete(callSummaries).go();
    await delete(transcriptSegments).go();
    await delete(callRecords).go();
  }
}
