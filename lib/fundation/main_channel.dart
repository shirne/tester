import 'package:flutter/services.dart';

class MainChannel {
  // 初始化通信管道
  static const channel = "com.shirne.tester/channel";
  static const platform = MethodChannel(channel);

  static Future<bool> openOther(String title, [List<dynamic>? data]) async {
    try {
      final bool out = await platform.invokeMethod(
        'openOther',
        {'title': title, if (data != null) 'data': data},
      );

      if (out) print('打开新页面');
    } on PlatformException catch (e) {
      print("通信失败(页面打开失败)");
      print(e.toString());
    }
    return Future.value(false);
  }

  static Future<int> test() async {
    try {
      final int out = await platform.invokeMethod(
        'test',
      );

      return out;
    } on PlatformException catch (e) {
      print("通信失败(页面打开失败)");
      print(e.toString());
    }
    return Future.value(0);
  }
}
