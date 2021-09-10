import 'dart:isolate';

import 'package:flutter/material.dart';

class TextForm extends StatefulWidget {
  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  late TextEditingController firstController;
  late TextEditingController secondController;

  @override
  void initState() {
    super.initState();
    firstController = TextEditingController();
    secondController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                }, onDone: () {
                  print('iso close');
                }, onError: (error) {
                  print('iso error: $error');
                });
                IsoMessage message = IsoMessage(port.sendPort, ["asd", "dsa"]);
                Isolate.spawn<IsoMessage>(myCaculate, message);
              },
              child: Text('ok'),
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
