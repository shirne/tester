import 'package:flutter/material.dart';

import 'animation.dart';
import 'custom_paint.dart';
import 'event.dart';
import 'isolate.dart';
import 'lifecycle.dart';
import 'lyric/index.dart';
import 'magnifier.dart';
import 'matrix4_test.dart';
import 'matrix_skew.dart';
import 'object_page.dart';
import 'image_test.dart';
import 'text_page.dart';
import 'navpage/index.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('演示列表')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const NavigationPage())));
                },
                child: const Text('导航监控'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const LyricPage())));
                },
                child: const Text('歌词'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TextPage())));
                },
                child: const Text('文本排版Bug'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const AnimationTestPage())));
                },
                child: const Text('弹簧动画'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const CustomPaintPage())));
                },
                child: const Text('Custom paint'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const EventTestPage())));
                },
                child: const Text('Eventbus'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const LifecycleTest())));
                },
                child: const Text('Lifecycle'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const MagnifierPage())));
                },
                child: const Text('Magnifier'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const MatrixSkew())));
                },
                child: const Text('MatrixSkew'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const Matrix4Test())));
                },
                child: const Text('Matrix4'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ObjectPage())));
                },
                child: const Text('Object 3D'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ImageTest())));
                },
                child: const Text('Image load'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const IsolateTest())));
                },
                child: const Text('Isolate'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TextPage())));
                },
                child: const Text('文本空格Bug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
