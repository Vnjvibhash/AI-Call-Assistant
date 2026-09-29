package `in`.innovateria.aicallassistant.audio

import android.content.Context
import android.media.AudioManager
import android.os.Build
import android.util.Log

/**
 * Native Audio Routing Manager.
 *
 * CRITICAL ANDROID TELECOM & AUDIO REALITY:
 * Since Android 9/10 (API 28/29+), third-party non-OEM apps CANNOT directly tap into
 * cellular in-call two-way audio streams (MediaRecorder.AudioSource.VOICE_CALL) because
 * android.permission.CAPTURE_AUDIO_OUTPUT is a 'signature|privileged' permission reserved
 * strictly for pre-installed system apps / Telecom HAL.
 *
 * How Production Personal AI Phone Assistants Work:
 * 1. Cloud Telephony Forwarding (Equal AI, Truecaller AI, Airtel Assistant):
 *    Incoming calls are forwarded via GSM MMI codes (*67*, *61*, *62*) to a dedicated SIP trunk,
 *    where full digital PCM audio is streamed bidirectional to cloud STT/LLM/TTS engines.
 * 2. On-Device In-Call Mode:
 *    When the app is the Default Dialer (InCallService), the call is answered, audio mode is set to
 *    MODE_IN_COMMUNICATION, and audio can be captured via AudioSource.MIC / VOICE_COMMUNICATION
 *    and output through AudioManager.STREAM_VOICE_CALL or Speakerphone.
 */
class AudioRoutingManager(private val context: Context) {

    companion object {
        private const val TAG = "AudioRoutingManager"
    }

    private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    fun setSpeakerphoneOn(on: Boolean): Boolean {
        return try {
            audioManager.isSpeakerphoneOn = on
            Log.d(TAG, "Speakerphone set to: $on")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to set speakerphone", e)
            false
        }
    }

    fun isSpeakerphoneOn(): Boolean = audioManager.isSpeakerphoneOn

    fun setMicrophoneMute(muted: Boolean): Boolean {
        return try {
            audioManager.isMicrophoneMute = muted
            Log.d(TAG, "Microphone mute set to: $muted")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to set microphone mute", e)
            false
        }
    }

    fun isMicrophoneMuted(): Boolean = audioManager.isMicrophoneMute

    fun setCallCommunicationMode(): Boolean {
        return try {
            audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
            Log.d(TAG, "Audio mode set to MODE_IN_COMMUNICATION")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to set communication mode", e)
            false
        }
    }

    fun resetAudioMode(): Boolean {
        return try {
            audioManager.mode = AudioManager.MODE_NORMAL
            Log.d(TAG, "Audio mode reset to MODE_NORMAL")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to reset audio mode", e)
            false
        }
    }

    fun getAudioCapabilities(): Map<String, Any> {
        return mapOf(
            "directCellularPcmCaptureSupported" to false, // By Android OS security policy
            "inCommunicationModeSupported" to true,
            "speakerphoneSupported" to true,
            "microphoneMuteSupported" to true,
            "requiresCallForwardingOrInCommunication" to true,
            "androidVersion" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "supportedTelephonyPaths" to listOf(
                "DEFAULT_DIALER_IN_CALL_SERVICE",
                "CONDITIONAL_CALL_FORWARDING_MMI",
                "VOIP_IN_COMMUNICATION_LOOPBACK",
                "INTERACTIVE_CALL_SIMULATOR"
            )
        )
    }
}
