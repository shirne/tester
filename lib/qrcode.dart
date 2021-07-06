import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class QrcodeTest extends StatefulWidget {
  @override
  State<QrcodeTest> createState() => _QrcodeTestState();
}

class _QrcodeTestState extends State<QrcodeTest> {
  FrameInfo? frameInfo;

  @override
  void initState() {
    super.initState();
    rawImage();
  }

  getImage() async {
    Uint8List data =
        await File(Directory.current.absolute.path + "/assets/images/test.png")
            .readAsBytesSync();
    //var descriptor =
    //    ImageDescriptor.encoded(await ImmutableBuffer.fromUint8List(data));
    //print(data);
    instantiateImageCodec(data)
        .then((codec) => codec.getNextFrame().then((frameInfo) {
              frameInfo.image
                  .toByteData(format: ImageByteFormat.rawRgba)
                  .then((data) {
                print(data!.buffer.asUint8List());
              });
            }));
  }

  rawImage() async {
    var buffer = await ImmutableBuffer.fromUint8List(Uint8List.fromList([
      255, 0, 0, 255, 0, 255, 0, 255, //
      0, 0, 255, 255, 255, 0, 255, 255, //
      0, 255, 255, 255, 0, 0, 0, 0
    ]));
    var descriptor = ImageDescriptor.raw(buffer,
        width: 2, height: 3, pixelFormat: PixelFormat.rgba8888);
    descriptor
        .instantiateCodec()
        .then((codec) => codec.getNextFrame().then((fInfo) {
              setState(() {
                frameInfo = fInfo;
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/test.png',
          scale: 0.05,
        ),
        if (frameInfo != null)
          RawImage(
            image: frameInfo!.image,
            scale: 0.05,
          ),
        Image.memory(Uint8List.fromList([
          255, 0, 0, 255, 0, 255, 0, 255, //
          0, 0, 255, 255, 255, 0, 255, 255, //
          0, 255, 255, 255, 0, 0, 0, 0
        ])),
      ],
    )));
  }
}
