package `in`.innovateria.aicallassistant.telecom

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

/**
 * Thread-safe singleton broadcaster bridging native Android Telephony
 * events to Flutter's EventChannel ("in.innovateria.aicallassistant/telecom_events").
 */
object CallStateBroadcaster : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun sendEvent(eventType: String, data: Map<String, Any?>) {
        val payload = HashMap<String, Any?>()
        payload["type"] = eventType
        payload["timestamp"] = System.currentTimeMillis()
        payload["data"] = data

        mainHandler.post {
            try {
                eventSink?.success(payload)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun emitIncomingCall(callId: String, phoneNumber: String?, callerName: String?, isScreened: Boolean) {
        val data = mapOf(
            "callId" to callId,
            "phoneNumber" to (phoneNumber ?: "Unknown"),
            "callerName" to (callerName ?: "Unknown Caller"),
            "isScreened" to isScreened,
            "state" to "RINGING"
        )
        sendEvent("INCOMING_CALL", data)
    }

    fun emitCallStateChanged(callId: String, state: String, details: Map<String, Any?> = emptyMap()) {
        val data = mutableMapOf<String, Any?>(
            "callId" to callId,
            "state" to state
        )
        data.putAll(details)
        sendEvent("CALL_STATE_CHANGED", data)
    }

    fun emitCallAnswered(callId: String, answerMode: String) {
        val data = mapOf(
            "callId" to callId,
            "answerMode" to answerMode,
            "state" to "ACTIVE"
        )
        sendEvent("CALL_ANSWERED", data)
    }

    fun emitCallEnded(callId: String, durationSeconds: Long, reason: String) {
        val data = mapOf(
            "callId" to callId,
            "durationSeconds" to durationSeconds,
            "reason" to reason,
            "state" to "DISCONNECTED"
        )
        sendEvent("CALL_ENDED", data)
    }

    fun emitAudioRouteChange(route: String, isMuted: Boolean, isSpeakerOn: Boolean) {
        val data = mapOf(
            "route" to route,
            "isMuted" to isMuted,
            "isSpeakerOn" to isSpeakerOn
        )
        sendEvent("AUDIO_ROUTE_CHANGED", data)
    }
}
