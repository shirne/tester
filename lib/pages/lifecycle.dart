import 'dart:async';

import 'package:flutter/material.dart';

import '../fundation/main_channel.dart';

class LifecycleTest extends StatefulWidget {
  const LifecycleTest({Key? key}) : super(key: key);
  @override
  State<LifecycleTest> createState() => _LifecycleTestState();
}

class _LifecycleTestState extends State<LifecycleTest>
    with WidgetsBindingObserver {
  Future<int>? future;
  Completer<int>? completer;
  String startAt = '';
  String endAt = '';
  int futureVal = 0;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        completer?.complete(3);
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }

  _startFuture() {
    setState(() {
      startAt = DateTime.now().toIso8601String();
      endAt = '';
      futureVal = 0;
    });
    completer = Completer();
    future = Future.any<int>([_getFuture(), completer!.future]);

    future!.then((value) => _showResult(value));
  }

  Future<int> _getFuture() {
    return Future.delayed(const Duration(seconds: 5), () => 1);
  }

  _showResult(int val) {
    setState(() {
      endAt = DateTime.now().toIso8601String();
      futureVal = val;
      if (completer != null) {
        if (!completer!.isCompleted) {
          completer!.completeError(0);
        }
        completer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: SizedBox(width: 300, child: Text('future: $futureVal'))),
          Center(child: SizedBox(width: 300, child: Text('start at:$startAt'))),
          Center(child: SizedBox(width: 300, child: Text('timeout:$endAt'))),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _startFuture();
                  },
                  child: const Text('start'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    MainChannel.openOther();
                  },
                  child: const Text('Open other page'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
