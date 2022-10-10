import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'my_plugin_platform_interface.dart';

/// An implementation of [MyPluginPlatform] that uses method channels.
class MethodChannelMyPlugin extends MyPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('my_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getAssetsPath(String assets) async {
    return await methodChannel
        .invokeMethod<String>('getAssets', {'assets': assets});
  }

  @override
  Future<String?> getAssetsSubPath(String assets) async {
    return await methodChannel
        .invokeMethod<String>('getSubAssets', {'assets': assets});
  }

  @override
  Future<int?> getAssetsSize(String assets) async {
    return await methodChannel.invokeMethod<int>('getSize', {'assets': assets});
  }
}
