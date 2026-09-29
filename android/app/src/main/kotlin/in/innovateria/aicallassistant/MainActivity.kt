package `in`.innovateria.aicallassistant

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import `in`.innovateria.aicallassistant.telecom.TelecomBridge

class MainActivity : FlutterActivity() {

    private var telecomBridge: TelecomBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        telecomBridge = TelecomBridge(
            context = applicationContext,
            activity = this,
            messenger = flutterEngine.dartExecutor.binaryMessenger
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        telecomBridge?.teardown()
        telecomBridge = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onResume() {
        super.onResume()
        telecomBridge?.setActivity(this)
    }

    override fun onPause() {
        telecomBridge?.setActivity(null)
        super.onPause()
    }
}
