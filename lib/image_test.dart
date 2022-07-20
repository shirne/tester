import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class ImageTest extends StatefulWidget {
  const ImageTest({Key? key}) : super(key: key);

  @override
  State<ImageTest> createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  FrameInfo? frameInfo;

  @override
  void initState() {
    super.initState();
    rawImage();
  }

  getImage() async {
    Uint8List data =
        File(Directory.current.absolute.path + "/assets/images/test.png")
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
    return Scaffold(
      appBar: AppBar(title: const Text('Qrcode')),
      body: Center(
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
          Image.memory(
            Uint8List.fromList([
              137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82,
              0, //
              0, 0, 2, 0, 0, 0, 3, 8, 6, 0, 0, 0, 185, 234, 222, 129, 0, 0, 0,
              1, 115, 82, 71, 66, 0, 174, 206, 28, 233, 0, 0, 0, 4, 115, 66, 73,
              84, 8, 8, 8, 8, 124, 8, 100, 136, 0, 0, 0, 26, 73, 68, 65, 84, 8,
              153, 61, 197, 177, 1, 0, 0, 8, 195, 32, 252, 255, 232, 116, 147,
              5,
              145, 116, 84, 248, 7, 148, 152, 9, 248, 20, 202, 68, 8, 0, 0, 0,
              0,
              73, 69, 78, 68, 174, 66, 96, 130
            ]),
            scale: 0.05,
          ),
        ],
      )),
    );
  }
}
