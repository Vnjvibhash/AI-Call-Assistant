package `in`.innovateria.aicallassistant.telecom

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import `in`.innovateria.aicallassistant.ai.LocalAiEngine
import `in`.innovateria.aicallassistant.audio.AudioRoutingManager
import `in`.innovateria.aicallassistant.permissions.PermissionManager
import `in`.innovateria.aicallassistant.services.CallMonitorService
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class TelecomBridge(
    private val context: Context,
    private var activity: Activity?,
    messenger: BinaryMessenger
) : MethodChannel.MethodCallHandler {

    companion object {
        const val METHOD_CHANNEL_NAME = "in.innovateria.aicallassistant/telecom"
        const val EVENT_CHANNEL_NAME = "in.innovateria.aicallassistant/telecom_events"
    }

    private val methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
    private val eventChannel = EventChannel(messenger, EVENT_CHANNEL_NAME)
    private val audioRoutingManager = AudioRoutingManager(context)
    private val permissionManager = PermissionManager(context)
    private val localAiEngine = LocalAiEngine()

    init {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(CallStateBroadcaster)
    }

    fun setActivity(act: Activity?) {
        this.activity = act
    }

    fun teardown() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isDefaultDialer" -> {
                result.success(permissionManager.isDefaultDialer())
            }
            "requestDefaultDialer" -> {
                activity?.let {
                    permissionManager.requestDefaultDialer(it)
                    result.success(true)
                } ?: run {
                    result.error("NO_ACTIVITY", "Activity is not available to request default dialer", null)
                }
            }
            "isCallScreeningRoleHeld" -> {
                result.success(permissionManager.isCallScreeningRoleHeld())
            }
            "requestCallScreeningRole" -> {
                activity?.let {
                    permissionManager.requestCallScreeningRole(it)
                    result.success(true)
                } ?: run {
                    result.error("NO_ACTIVITY", "Activity is not available to request call screening role", null)
                }
            }
            "getPermissionStatus" -> {
                result.success(permissionManager.getPermissionStatus())
            }
            "answerCall" -> {
                val callId = call.argument<String>("callId")
                val success = AiInCallService.answerCall(callId)
                if (success) {
                    audioRoutingManager.setCallCommunicationMode()
                }
                result.success(success)
            }
            "endCall" -> {
                val callId = call.argument<String>("callId")
                val success = AiInCallService.disconnectCall(callId)
                audioRoutingManager.resetAudioMode()
                result.success(success)
            }
            "rejectCall" -> {
                val callId = call.argument<String>("callId")
                val success = AiInCallService.rejectCall(callId)
                result.success(success)
            }
            "setSpeakerphone" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                val success = audioRoutingManager.setSpeakerphoneOn(enabled)
                result.success(success)
            }
            "setMute" -> {
                val muted = call.argument<Boolean>("muted") ?: false
                val success = audioRoutingManager.setMicrophoneMute(muted)
                result.success(success)
            }
            "getAudioRoutingCapabilities" -> {
                result.success(audioRoutingManager.getAudioCapabilities())
            }
            "startCallMonitorService" -> {
                CallMonitorService.startService(context)
                result.success(true)
            }
            "stopCallMonitorService" -> {
                CallMonitorService.stopService(context)
                result.success(true)
            }
            "processLocalAiMessage" -> {
                val text = call.argument<String>("text") ?: ""
                val callerName = call.argument<String>("callerName")
                val languageHint = call.argument<String>("languageHint")
                val res = localAiEngine.processMessage(text, callerName, languageHint)
                result.success(
                    mapOf(
                        "intent" to res.intent,
                        "urgency" to res.urgency,
                        "callbackRequired" to res.callbackRequired,
                        "suggestedResponse" to res.suggestedResponse,
                        "detectedLanguage" to res.detectedLanguage
                    )
                )
            }
            "launchCallForwardingDialer" -> {
                val mmiCode = call.argument<String>("mmiCode") ?: ""
                try {
                    // Encode '#' as '%23' for telephony Uri
                    val encoded = Uri.encode(mmiCode)
                    val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:$encoded")).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    context.startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("DIALER_ERROR", e.localizedMessage, null)
                }
            }
            else -> result.notImplemented()
        }
    }
}
