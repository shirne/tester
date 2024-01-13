import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CutImagePage extends StatefulWidget {
  const CutImagePage({super.key});

  @override
  State<CutImagePage> createState() => _CutImagePageState();
}

class _CutImagePageState extends State<CutImagePage> {
  ImageProvider<Object>? imageProvider;
  final imagePath = 'assets/images/rect2.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final logTexts = [];
  void addLog(String logs) {
    //print(logs);
    //logTexts.add(logs);
  }

  void createImage() async {
    final data = await rootBundle.load(imagePath);
    final image = await decodeImageFromList(data.buffer.asUint8List());

    final pr = ui.PictureRecorder();
    final canvas = Canvas(pr);
    final fullRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    // 裁剪画布圆角
    canvas.clipRRect(
      RRect.fromRectAndRadius(fullRect, const Radius.circular(32)),
    );

    // 画背景色
    // canvas.drawRect(
    //   fullRect,
    //   Paint()
    //     ..color = Colors.purple
    //     ..style = PaintingStyle.fill,
    // );
    final bgColor = Colors.purple;

    final byteData =
        (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final pixels = byteData.buffer.asUint32List();

    // 取一行原始数据
    // addLog(
    //     '原始数据：${pixels.skip(150 * 300 * 4).take(300 * 4).map<String>((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');

    // 需要处理的边缘像素数
    double side = 50; //image.width / 6;
    final maxWidth = image.width - 1;
    final maxHeight = image.height - 1;

    // 处理上下边缘
    for (int i = 0; i < side; i++) {
      final alpha = i * 255 ~/ side;

      for (int w = 0; w <= maxWidth; w++) {
        final topIndex = i * image.width + w;
        final bottomIndex = (maxHeight - i) * image.width + w;
        final topColor = Color(pixels[topIndex]);
        final bottomColor = Color(pixels[topIndex]);

        // 四角颜色等下再混合
        if (w <= side || w >= maxWidth - side) {
          pixels[topIndex] = topColor.withAlpha(alpha).value;
          pixels[bottomIndex] = bottomColor.withAlpha(alpha).value;
        } else {
          pixels[topIndex] =
              Color.alphaBlend(topColor.withAlpha(alpha), bgColor).value;
          pixels[bottomIndex] =
              Color.alphaBlend(bottomColor.withAlpha(alpha), bgColor).value;
        }
      }
    }

    // 处理左右边缘
    for (int i = 0; i < side; i++) {
      final alpha = i * 255 ~/ side;
      for (int h = 0; h <= maxHeight; h++) {
        final leftIndex = h * image.width + i;
        final rightIndex = h * image.width + (maxWidth - i);
        final leftColor = Color(pixels[leftIndex]);
        final rightColor = Color(pixels[rightIndex]);
        // 四角交界的地方
        if (h <= side || h >= maxHeight - side) {
          final leftAlpha = math.min(alpha, leftColor.alpha);
          final rightAlpha = math.min(alpha, rightColor.alpha);
          pixels[leftIndex] =
              Color.alphaBlend(leftColor.withAlpha(leftAlpha), bgColor).value;
          pixels[rightIndex] =
              Color.alphaBlend(rightColor.withAlpha(rightAlpha), bgColor).value;
        } else {
          pixels[leftIndex] =
              Color.alphaBlend(leftColor.withAlpha(alpha), bgColor).value;
          pixels[rightIndex] =
              Color.alphaBlend(rightColor.withAlpha(alpha), bgColor).value;
        }
      }
    }

    // 取一行处理后的数据
    // addLog(
    //     '最终数据：${pixels.skip(150 * 300 * 4).take(300 * 4).map<String>((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');

    final alphaedImage = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      image.width,
      image.height,
      ui.PixelFormat.rgba8888,
      (result) {
        alphaedImage.complete(result);
      },
    );

    // 将处理后的图片画上去
    canvas.drawImage(
      await alphaedImage.future,
      Offset.zero,
      Paint(),
    );
    final picture = pr.endRecording();
    final newImage = await picture.toImage(image.width, image.height);
    final newImageByte =
        await newImage.toByteData(format: ui.ImageByteFormat.png);
    imageProvider = MemoryImage(newImageByte!.buffer.asUint8List());
    setState(() {});

    // 取一行解析后的数据
    // final newPixels =
    //     (await newImage.toByteData(format: ui.ImageByteFormat.rawRgba))!
    //         .buffer
    //         .asUint8List();
    // addLog(
    //     '最终数据：${newPixels.skip(150 * 300 * 4).take(300 * 4).map<String>((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');

    // 图片写到文件
    // File('${Directory.current.path}/newimage.png')
    //     .writeAsBytes(newImageByte.buffer.asUint8List());

    // 日志写到文件
    File('${Directory.current.path}/log.txt')
        .writeAsStringSync(logTexts.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('裁剪图片圆角'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueAccent[100],
        child: Column(
          children: [
            const Text('原图'),
            Image.asset(
              imagePath,
              width: 300,
              height: 300,
            ),
            const Text('处理后图'),
            imageProvider == null
                ? Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 300,
                    child: const CircularProgressIndicator())
                : Image(
                    image: imageProvider!,
                    width: 300,
                    height: 300,
                  ),
          ],
        ),
      ),
    );
  }
}
