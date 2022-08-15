import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class ShotScreen extends StatefulWidget {
  const ShotScreen({Key? key}) : super(key: key);

  @override
  State<ShotScreen> createState() => ShotScreenState();
}

class ShotScreenState extends State<ShotScreen> {
  Widget? container;
  Completer<Uint8List> completer = Completer<Uint8List>();

  Future<Uint8List> loadTemplateImage(double width, double height) {
    if (completer.isCompleted) {
      completer = Completer<Uint8List>();
    }

    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      container = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.withAlpha(100), Colors.red.withAlpha(200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final result = await ScreenshotController().captureFromWidget(
          container!,
        );
        completer.complete(result);
      });
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 400,
            height: 400,
            color: Colors.yellow,
            child: Center(
              child: FittedBox(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 1242,
                  height: 1242,
                  child: FutureBuilder<Uint8List>(
                    future: completer.future,
                    builder: (context, snapshot) {
                      Uint8List? result = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done &&
                          result != null) {
                        return Image.memory(result);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                loadTemplateImage(300, 300);
              },
              child: Text('shot')),
          if (container != null)
            SizedBox(
              width: 0,
              height: 0,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: 2000,
                maxWidth: 2000,
                child: widget,
              ),
            ),
        ],
      ),
    );
  }
}
