import 'dart:io';

import 'package:image/image.dart';
import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/qrcode.dart';
import 'package:zxing_lib/zxing.dart';

final decoder = QRCodeReader();

void main() {
  walkDir(Directory('${Directory.current.path}/test/errcode'));
}

int pixel2L(int p) {
  final r = p >>> 24;
  final g = p >>> 16 & 0xff;
  final b = p >>> 8 & 0xff;
  return g * 2 + r + b ~/ 4;
}

void walkDir(Directory dir) async {
  final enties = await dir.list().toList();
  for (final fn in enties) {
    if (fn is File) {
      final img = decodeImage(fn.readAsBytesSync());
      if (img != null) {
        stdout.writeln('start: ${fn.path}');
        if (!readImage(img, 'orig')) {
          if (!readImage(grayscale(img), 'grayscale')) {
            if (!readImage(
                copyResize(img, width: img.width * 2, height: img.height * 2),
                'copyresize x 2')) {
              if (!readImage(
                  copyResize(img,
                      width: img.width ~/ 2, height: img.height ~/ 2),
                  'copyresize / 2')) {
                stdout.writeln('failed: ${fn.path}');
              }
            }
          }
        }
      }
    }
  }
}

bool readImage(Image img, String flag) {
  try {
    final luminance = RGBLuminanceSource(
        img.width, img.height, img.getBytes().buffer.asInt32List());
    final bin = GlobalHistogramBinarizer(luminance);

    final result = decoder.decode(BinaryBitmap(bin), {
      DecodeHintType.TRY_HARDER: true,
    });
    stdout.writeln(' success[$flag]:  ${result.text}');
    return true;
  } catch (_) {
    stdout.writeln('  error[$flag]:$_');
  }
  return false;
}
