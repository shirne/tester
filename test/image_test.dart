import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  setUp(() async {});

  test('gif image', () async {
    const dir = r'path/to/gif/dir';
    final bytes = File('$dir\\img-4.gif').readAsBytesSync();

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    var count = 0;
    for (;;) {
      final frame = await codec.getNextFrame();
      var imageData =
          (await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba))!
              .buffer
              .asUint8List();
      var width = frame.image.width;
      var height = 446;
      var size = width * height * 4;
      var imageData2 = Uint8List(size);
      List.copyRange(imageData2, 0, imageData, 0, size);
      Color color = Color.fromARGB(
        imageData2[size - 1],
        imageData2[size - 4],
        imageData2[size - 3],
        imageData2[size - 2],
      );
      for (var x = 0; x < width; x++) {
        for (var y = height;; y--) {
          var pos = (width * (y - 1) + x) * 4;
          var c = Color.fromARGB(
            imageData2[pos + 3],
            imageData2[pos],
            imageData2[pos + 1],
            imageData2[pos + 2],
          );

          if (compareColor(c, color)) {
            imageData2[pos + 3] = 0;
          } else {
            break;
          }
        }
      }
      Completer com = Completer();
      ui.decodeImageFromPixels(
          imageData2, width, height, ui.PixelFormat.rgba8888, (result) async {
        File('$dir\\images\\${count.toString().padLeft(2, '0')}.png')
            .writeAsBytesSync(
          (await result.toByteData(format: ui.ImageByteFormat.png))!
              .buffer
              .asUint8List(),
        );
        com.complete();
      });
      await com.future;

      count++;
      if (count >= codec.frameCount) break;
    }
  });
}

bool compareColor(Color color1, Color color2, [int diff = 5]) {
  if (color1.alpha == color2.alpha &&
      (color1.blue - color2.blue).abs() < diff &&
      (color1.red - color2.red).abs() < diff &&
      (color1.green - color2.green).abs() < diff) {
    return true;
  }
  return false;
}
