import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateTest extends StatefulWidget {
  const IsolateTest({Key? key}) : super(key: key);

  @override
  State<IsolateTest> createState() => _IsolateTestState();
}

class _IsolateTestState extends State<IsolateTest> {
  late TextEditingController firstController;
  late TextEditingController secondController;

  String result = '';

  @override
  void initState() {
    super.initState();
    firstController = TextEditingController();
    secondController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('isolate')),
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              controller: firstController,
            ),
            TextFormField(
              controller: secondController,
            ),
            ElevatedButton(
              onPressed: () {
                var port = ReceivePort();
                port.listen((message) {
                  print("onData: $message");
                  setState(() {
                    result = message;
                  });
                }, onDone: () {
                  print('iso close');
                }, onError: (error) {
                  print('iso error: $error');
                });
                IsoMessage message = IsoMessage(port.sendPort, ["asd", "dsa"]);
                Isolate.spawn<IsoMessage>(myCaculate, message);
              },
              child: const Text('ok'),
            ),
            Center(
              child: Text('首字母：$result'),
            )
          ],
        ),
      ),
    );
  }
}

class IsoMessage {
  final SendPort? sendPort;
  final List<String> args;

  IsoMessage(this.sendPort, this.args);
}

String myCaculate(IsoMessage message) {
  String result = message.args[0][0] + message.args[1][1];
  message.sendPort?.send(result);

  return result;
}
