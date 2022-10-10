import 'dart:async';

import 'main_channel.dart';

FutureOr methodTest(a) {
  MainChannel.test().then((value) => print(value)).catchError((e) => print(e));
}
