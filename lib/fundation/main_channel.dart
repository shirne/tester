import 'package:flutter/services.dart';

class MainChannel {
  // 初始化通信管道
  static const channel = "com.shirne.tester/channel";

  static Future<bool> openOther(String title, [List<dynamic>? data]) async {
    const platform = MethodChannel(channel);

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
}
