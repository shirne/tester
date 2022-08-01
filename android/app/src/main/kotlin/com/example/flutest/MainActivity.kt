package com.example.flutest


import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant.*

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.shirne.tester/channel"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { methodCall, result ->
            if (methodCall.method == "openOther") {
                // 打开页面
                result.success(true)
                val intent = Intent(this@MainActivity, OtherActivity::class.java)
                startActivity(intent)
            }
        }
    }
}
