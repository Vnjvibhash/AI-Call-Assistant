package `in`.innovateria.aicallassistant.telecom

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.telecom.Call
import android.telecom.InCallService
import android.telecom.VideoProfile
import android.util.Log

/**
 * Android InCallService implementation.
 *
 * NOTE ON ANDROID SYSTEM TELEPHONY ARCHITECTURE & FEASIBILITY:
 * InCallService is the official Android Telecom framework service for call handling.
 * To be bound by Android OS for incoming/outgoing cellular calls, the application
 * must be designated as the system's Default Phone / Dialer App.
 *
 * Once designated as Default Dialer, this service receives onCallAdded() and can:
 * - Answer incoming calls programmatically: call.answer(VideoProfile.STATE_AUDIO_ONLY)
 * - Disconnect/reject calls: call.disconnect() / call.reject()
 * - Hold/unhold calls: call.hold() / call.unhold()
 * - Monitor call states and duration
 */
class AiInCallService : InCallService() {

    companion object {
        private const val TAG = "AiInCallService"
        private var instance: AiInCallService? = null
        private val activeCalls = mutableMapOf<String, Call>()

        fun getInstance(): AiInCallService? = instance

        fun getActiveCall(callId: String): Call? = activeCalls[callId]

        fun getPrimaryCall(): Call? = activeCalls.values.firstOrNull()

        fun answerCall(callId: String?): Boolean {
            val call = if (callId != null) activeCalls[callId] else getPrimaryCall()
            return if (call != null) {
                try {
                    call.answer(VideoProfile.STATE_AUDIO_ONLY)
                    Log.d(TAG, "Call answered successfully: ${call.details.handle}")
                    true
                } catch (e: Exception) {
                    Log.e(TAG, "Error answering call", e)
                    false
                }
            } else {
                Log.w(TAG, "No active call found to answer")
                false
            }
        }

        fun disconnectCall(callId: String?): Boolean {
            val call = if (callId != null) activeCalls[callId] else getPrimaryCall()
            return if (call != null) {
                try {
                    call.disconnect()
                    Log.d(TAG, "Call disconnected")
                    true
                } catch (e: Exception) {
                    Log.e(TAG, "Error disconnecting call", e)
                    false
                }
            } else {
                false
            }
        }

        fun rejectCall(callId: String?): Boolean {
            val call = if (callId != null) activeCalls[callId] else getPrimaryCall()
            return if (call != null) {
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        call.reject(Call.REJECT_REASON_DECLINED)
                    } else {
                        @Suppress("DEPRECATION")
                        call.reject(false, null)
                    }
                    true
                } catch (e: Exception) {
                    Log.e(TAG, "Error rejecting call", e)
                    false
                }
            } else {
                false
            }
        }
    }

    private val callCallbacks = mutableMapOf<Call, Call.Callback>()

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.i(TAG, "AiInCallService created and bound by Telecom subsystem")
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
        activeCalls.clear()
        Log.i(TAG, "AiInCallService destroyed")
    }

    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        val callId = getCallIdentifier(call)
        activeCalls[callId] = call
        Log.i(TAG, "onCallAdded: callId=$callId, state=${call.state}")

        val callback = object : Call.Callback() {
            override fun onStateChanged(targetCall: Call, state: Int) {
                super.onStateChanged(targetCall, state)
                handleStateChange(targetCall, state)
            }

            override fun onDetailsChanged(targetCall: Call, details: Call.Details) {
                super.onDetailsChanged(targetCall, details)
                Log.d(TAG, "onDetailsChanged: ${details.handle}")
            }
        }

        callCallbacks[call] = callback
        call.registerCallback(callback)

        val handle = call.details.handle
        val phoneNumber = handle?.schemeSpecificPart ?: "Unknown"
        val callerName = call.details.callerDisplayName ?: "Unknown Caller"

        CallStateBroadcaster.emitIncomingCall(
            callId = callId,
            phoneNumber = phoneNumber,
            callerName = callerName,
            isScreened = false
        )
    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        val callId = getCallIdentifier(call)
        activeCalls.remove(callId)
        val callback = callCallbacks.remove(call)
        if (callback != null) {
            call.unregisterCallback(callback)
        }

        val duration = call.details.connectTimeMillis.let { connectTime ->
            if (connectTime > 0) (System.currentTimeMillis() - connectTime) / 1000 else 0L
        }

        CallStateBroadcaster.emitCallEnded(
            callId = callId,
            durationSeconds = duration,
            reason = "Call disconnected"
        )
        Log.i(TAG, "onCallRemoved: callId=$callId, duration=${duration}s")
    }

    private fun handleStateChange(call: Call, state: Int) {
        val callId = getCallIdentifier(call)
        val stateName = when (state) {
            Call.STATE_RINGING -> "RINGING"
            Call.STATE_DIALING -> "DIALING"
            Call.STATE_ACTIVE -> "ACTIVE"
            Call.STATE_HOLDING -> "HOLDING"
            Call.STATE_DISCONNECTED -> "DISCONNECTED"
            Call.STATE_CONNECTING -> "CONNECTING"
            Call.STATE_SELECT_PHONE_ACCOUNT -> "SELECT_ACCOUNT"
            else -> "UNKNOWN"
        }

        Log.d(TAG, "Call $callId changed state to: $stateName")

        if (state == Call.STATE_ACTIVE) {
            CallStateBroadcaster.emitCallAnswered(callId, "AI_ASSISTANT")
        } else {
            CallStateBroadcaster.emitCallStateChanged(callId, stateName)
        }
    }

    private fun getCallIdentifier(call: Call): String {
        return call.details?.handle?.schemeSpecificPart?.takeIf { it.isNotEmpty() }
            ?: "call_${System.identityHashCode(call)}"
    }
}
