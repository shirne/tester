import 'my_plugin_platform_interface.dart';

class MyPlugin {
  Future<String?> getPlatformVersion() {
    return MyPluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> getAssetsPath(String assets) {
    return MyPluginPlatform.instance.getAssetsPath(assets);
  }

  Future<String?> getAssetsSubPath(String assets) {
    return MyPluginPlatform.instance.getAssetsPath(assets);
  }

  Future<int?> getAssetsSize(String assets) {
    return MyPluginPlatform.instance.getAssetsSize(assets);
  }
}
