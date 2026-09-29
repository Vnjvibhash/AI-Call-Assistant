# AI Call Assistant (Equal AI for Android)

Production-ready, personal AI phone assistant built with Flutter, Riverpod, Drift SQLite, Google Gemini AI, and native Android Kotlin telephony modules (`InCallService`, `CallScreeningService`, and `AudioManager`).

---

## 1. System Architecture

The project follows Clean Architecture with MVVM presentation, Riverpod dependency injection, and native Kotlin platform channels:

```
┌─────────────────────────────────────────────────────────────┐
│                 Flutter UI & Presentation                   │
│   Dashboard • Live Call Screen • AI Concierge • Reminders   │
└──────────────────────────────┬──────────────────────────────┘
                               │ State (Riverpod)
┌──────────────────────────────▼──────────────────────────────┐
│                    Domain & Business Logic                  │
│    CallSessionController • GeminiAiService • Speech/TTS     │
└──────────────┬───────────────────────────────┬──────────────┘
               │                               │
┌──────────────▼──────────────┐ ┌──────────────▼──────────────┐
│      Drift SQLite DB        │ │    Platform Bridge (Kotlin) │
│ Calls • Transcripts • Recap │ │ InCallService • CallScreen  │
└─────────────────────────────┘ └─────────────────────────────┘
```

---

## 2. Android Telephony Feasibility & Reality

### How Cellular Call Answering Works in Android
1. **Default Dialer & InCallService**:
   - For an ordinary third-party app to programmatically answer cellular calls (`call.answer()`) and manage active call states, Android requires the app to be set as the system's **Default Phone App** (`TelecomManager.ACTION_CHANGE_DEFAULT_DIALER`).
   - The native module [`AiInCallService.kt`](android/app/src/main/kotlin/in/innovateria/aicallassistant/telecom/AiInCallService.kt) implements this binding.
2. **Call Screening Service**:
   - Implemented in [`AiCallScreeningService.kt`](android/app/src/main/kotlin/in/innovateria/aicallassistant/telecom/AiCallScreeningService.kt). It inspects calls prior to ringing and allows silencing, blocking, or logging.
3. **In-Call Audio Routing Reality (Why Cloud Forwarding is Used)**:
   - On modern Android (API 29+), direct digital capture of two-way cellular audio streams via `MediaRecorder.AudioSource.VOICE_CALL` is restricted by SELinux and requires `android.permission.CAPTURE_AUDIO_OUTPUT` (a `signature|privileged` OEM system permission).
   - **Production AI Assistants (Equal AI, Truecaller Assistant, Airtel Assistant)** use **Conditional Call Forwarding** (GSM MMI codes such as `*67*<number>#` when busy, `*61*<number>#` when unanswered) to route calls to an AI SIP trunk.
   - For on-device voice processing, the app routes audio through `AudioManager.MODE_IN_COMMUNICATION` and provides an **Interactive Call Simulation Studio** for full voice turn testing.

---

## 3. Directory Structure

```
lib/
├── app/
│   ├── app.dart              # MaterialApp.router configuration
│   ├── providers.dart        # Riverpod Singletons, Notifiers & Streams
│   ├── router.dart           # GoRouter route definitions
│   └── theme.dart            # Material 3 Navy & Electric Blue theme
├── core/
│   ├── constants/            # App constants, carrier MMI codes, telecom keys
│   ├── database/             # Drift SQLite database & generated models
│   ├── errors/               # Domain failure classes
│   ├── services/             # Gemini AI, SpeechToText, TTS, PDF Export, Telecom
│   └── utils/                # Phone number formatting & human date formatters
├── features/
│   ├── onboarding/           # Carousel & System Permission Setup
│   ├── dashboard/            # Master switch, metrics grid, recent calls, hub
│   ├── call_management/      # Live Call Screen, Call Simulator, Forwarding Setup
│   ├── ai_assistant/         # AI Chat Concierge for querying database
│   ├── call_history/         # Searchable call logs & PDF/Text export
│   ├── reminders/            # Pending callback reminders management
│   └── settings/             # AI provider, voice/language, privacy wipe
└── shared/
    └── widgets/              # GlassCard, StatusBadge, WaveAnimation, CustomButton

android/app/src/main/kotlin/in/innovateria/aicallassistant/
├── MainActivity.kt           # Binds TelecomBridge with Flutter engine
├── telecom/
│   ├── AiInCallService.kt    # Android InCallService for answering calls
│   ├── AiCallScreeningService.kt # Spam filtering & call screening
│   ├── CallStateBroadcaster.kt # Thread-safe EventChannel broadcaster
│   └── TelecomBridge.kt      # MethodChannel handler
├── services/
│   └── CallMonitorService.kt # Background call monitoring foreground service
├── ai/
│   └── LocalAiEngine.kt      # On-device offline rule and intent classifier
├── audio/
│   └── AudioRoutingManager.kt # AudioManager routing & capability diagnostics
└── permissions/
    └── PermissionManager.kt  # RoleManager and dialer permission requester
```

---

## 4. Database Schema (Drift SQLite)

The database schema (`aicallassistant_db`) implements:
- `CALL_RECORDS`: id, phoneNumber, callerName, startTime, endTime, duration, handlingMode, language, status.
- `TRANSCRIPT_SEGMENTS`: id, callId, speaker (ai/caller/user), text, timestamp, language.
- `CALL_SUMMARIES`: id, callId, summary, intent, priority, callbackRequired, callbackTime, actionItems.
- `ASSISTANT_SETTINGS`: id, assistantEnabled, preferredLanguage, aiMode, greetingMessage, workingHours.
- `CALLBACK_REMINDERS`: id, callId, callerName, phoneNumber, reminderTime, reminderStatus, note.

---

## 5. Setup & Running

### Requirements
- Flutter SDK 3.24+ / 3.38+
- Android Studio with Android SDK API 34+
- Java 17+

### Running the App
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Build Drift code (already pre-generated)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run on connected Android device or emulator
flutter run
```

### Opening in Android Studio
1. Open Android Studio.
2. Select **Open** and select the `/Users/vivekajee/Documents/Vnj Vibhash` folder.
3. To inspect native Kotlin code, right-click the `android` folder and select **Flutter > Open Android module in Android Studio**.
