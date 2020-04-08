package com.example.e_doctor

import androidx.annotation.NonNull;
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.video.sdk/opentok"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "openVideoChat") {
                val intent = Intent(this, VideoActivity::class.java)
                startActivity(intent)
                // result.error("UNAVAILABLE", "Battery level not available.", null)

            } else {
                result.notImplemented()
            }
        }
    }
}
