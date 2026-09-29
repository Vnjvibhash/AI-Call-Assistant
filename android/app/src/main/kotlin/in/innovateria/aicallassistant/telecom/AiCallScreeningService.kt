package `in`.innovateria.aicallassistant.telecom

import android.os.Build
import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log

/**
 * Android CallScreeningService implementation.
 *
 * NOTE ON ANDROID SYSTEM TELEPHONY ARCHITECTURE & FEASIBILITY:
 * CallScreeningService allows an app to inspect incoming calls before the phone rings.
 * The system grants this role via RoleManager (ROLE_CALL_SCREENING) on Android 10+ (API 29+).
 *
 * Supported Capabilities:
 * - Silence ringing: response.setSilenceCall(true)
 * - Block / Disallow spam calls: response.setDisallowCall(true).setRejectCall(true)
 * - Skip notification or call log
 *
 * Architectural Limitation:
 * CallScreeningService CANNOT pick up or route audio to an AI engine by itself;
 * it only passes an allow/disallow/silence verdict to the Android telecom stack.
 * Answering and voice interaction requires InCallService or Call Forwarding.
 */
class AiCallScreeningService : CallScreeningService() {

    companion object {
        private const val TAG = "AiCallScreeningService"
        var blockSpamEnabled: Boolean = true
        var autoSilenceUnknown: Boolean = false
    }

    override fun onScreenCall(callDetails: Call.Details) {
        val handle = callDetails.handle
        val phoneNumber = handle?.schemeSpecificPart ?: "Unknown"
        val callerName = callDetails.callerDisplayName ?: "Unknown Caller"
        val callId = "screen_${System.currentTimeMillis()}"

        Log.i(TAG, "onScreenCall intercepted: number=$phoneNumber, name=$callerName")

        // Broadcast screening event to Flutter layer
        CallStateBroadcaster.emitIncomingCall(
            callId = callId,
            phoneNumber = phoneNumber,
            callerName = callerName,
            isScreened = true
        )

        val responseBuilder = CallResponse.Builder()

        // Check if call should be silenced or disallowed
        if (autoSilenceUnknown && phoneNumber == "Unknown") {
            responseBuilder.setSilenceCall(true)
            Log.d(TAG, "Silencing unknown incoming call")
        }

        respondToCall(callDetails, responseBuilder.build())
    }
}
