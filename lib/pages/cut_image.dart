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
    canvas.drawRect(
      fullRect,
      Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.fill,
    );

    final pixels =
        (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final unit8List = pixels.buffer.asUint8List();

    // 需要处理的边缘像素数
    double side = 50; //image.width / 6;
    final maxWidth = image.width - 1;
    final maxHeight = image.height - 1;

    // 处理上下边缘
    for (int i = 0; i < side; i++) {
      final alpha = i * 255 ~/ side;

      for (int w = 0; w <= maxWidth; w++) {
        final topIndex = i * image.width * 4 + w * 4 + 3;
        final bottomIndex = (maxHeight - i) * image.width * 4 + w * 4 + 3;
        addLog(
            '上边缘像素：$w, $i, ${unit8List.sublist(topIndex - 3, topIndex + 1)}, $alpha');
        addLog(
            '下边缘像素：$w, ${maxHeight - i}, ${unit8List.sublist(bottomIndex - 3, bottomIndex + 1)}, $alpha');
        unit8List[topIndex] = alpha;
        unit8List[bottomIndex] = alpha;
      }
    }

    // 处理左右边缘
    for (int i = 0; i < side; i++) {
      final alpha = i * 255 ~/ side;
      for (int h = 0; h <= maxHeight; h++) {
        final leftIndex = h * image.width * 4 + i * 4 + 3;
        final rightIndex = h * image.width * 4 + (maxWidth - i) * 4 + 3;
        addLog(
            '左边缘像素：$i, $h, ${unit8List.sublist(leftIndex - 3, leftIndex + 1)}, $alpha');
        addLog(
            '右边缘像素：${maxWidth - i}, $h, ${unit8List.sublist(rightIndex - 3, rightIndex + 1)}, $alpha');
        // 四角交界的地方
        if (h <= side || h >= maxHeight - side) {
          unit8List[leftIndex] = math.min(alpha, unit8List[leftIndex]);
          unit8List[rightIndex] = math.min(alpha, unit8List[rightIndex]);
        } else {
          unit8List[leftIndex] = alpha;
          unit8List[rightIndex] = alpha;
        }
      }
    }

    //addLog('最终数据：${unit8List.join(' ')}');

    final alphaedImage = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      unit8List,
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

    // 图片写到文件
    // File('${Directory.current.path}/newimage.png')
    //     .writeAsBytes(newImageByte.buffer.asUint8List());

    // 日志写到文件
    // File('${Directory.current.path}/log.txt')
    //     .writeAsStringSync(logTexts.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('裁剪图片圆角'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.limeAccent,
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
