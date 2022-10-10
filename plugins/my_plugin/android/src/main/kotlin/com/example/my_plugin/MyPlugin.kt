package com.example.my_plugin

import androidx.annotation.NonNull
import android.content.res.AssetManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MyPlugin */
class MyPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var binding : FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    binding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "my_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }else if(call.method == "getAssets"){
      var assets : String = call.argument("assets")!!
      result.success(binding.getFlutterAssets().getAssetFilePathByName(assets))
    }else if(call.method == "getSubAssets"){
      var assets : String = call.argument("assets")!!
      result.success(binding.getFlutterAssets().getAssetFilePathBySubpath(assets))
    }else if(call.method == "getSize"){
      var assets : String = call.argument("assets")!!
      var path : String = binding.getFlutterAssets().getAssetFilePathBySubpath(assets)
      var assetsManager = binding.getApplicationContext().getAssets()
      result.success(assetsManager.open(path).available())

    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
