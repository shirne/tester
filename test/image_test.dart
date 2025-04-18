import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  setUp(() async {});

  Future<Uint8List> getData(String path) async {
    final ui.Codec codec =
        await ui.instantiateImageCodec(File(path).readAsBytesSync());

    final image = (await codec.getNextFrame()).image;

    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    return data!.buffer.asUint8List();
  }

  test('read image color', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var image = File('../bg.png');
    var loadedFuture = Completer<ui.Image>();
    ui.decodeImageFromList(image.readAsBytesSync(), (loadImage) {
      loadedFuture.complete(loadImage);
    });
    var loadImage = await loadedFuture.future;
    print("${loadImage.width}/${loadImage.height}");
    var pixels = await loadImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (pixels != null) {
      var data = pixels.buffer.asUint8List();
      print(data.length);

      var idx = ((loadImage.width * loadImage.height / 2) + loadImage.width / 2)
          .toInt();
      print(data.sublist(idx, idx + 4));
    }
  });

  test('compare color', () async {
    final orig = '${Directory.current.path}/assets/images/rect2.jpg';
    final p1 = '${Directory.current.path}/newimage.png';
    final p2 = '${Directory.current.path}/rect2.png';
    final data = await getData(orig);
    final data1 = await getData(p1);
    final data2 = await getData(p2);

    final pos = 150 * 300 * 4 + 270 * 4;

    print(data.sublist(pos, pos + 4));
    print(data1.sublist(pos, pos + 4));
    print(data2.sublist(pos, pos + 4));

    final pos2 = 150 * 300 * 4 + 150 * 4;
    print(data.sublist(pos2, pos2 + 4));
    print(data1.sublist(pos2, pos2 + 4));
    print(data2.sublist(pos2, pos2 + 4));
  });

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
