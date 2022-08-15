package com.example.flutest


import android.content.Intent
import androidx.annotation.NonNull
import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant.*

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.shirne.tester/channel"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { methodCall, result ->
            if (methodCall.method == "openOther") {
                // 打开页面
                result.success(true)
                val title:String? = methodCall.argument("title")
                val  data:List<Object?>? = methodCall.argument("data")
                System.out.println(title)
                System.out.println(data)
                if(data!=null){
                    System.out.println(data[3])
                }

                val intent = Intent(this@MainActivity, OtherActivity::class.java)
                intent.putExtra("title",title)
                startActivity(intent)
            }
        }
    }
}
