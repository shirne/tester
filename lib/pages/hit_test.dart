import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class HitTestPage extends StatelessWidget {
  const HitTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('点击测试')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            MyDialog.toast('button1 pressed');
                          },
                          child: const Text('button1'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            MyDialog.toast('button2 pressed');
                          },
                          child: const Text('button2'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            MyDialog.toast('button3 pressed');
                          },
                          child: const Text('button3'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            MyDialog.toast('button4 pressed');
                          },
                          child: const Text('button4'),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      MyDialog.toast('mask taped');
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        color:
                            Theme.of(context).colorScheme.shadow.withAlpha(50),
                        shape: const KnockShape(
                            knocked: CircleBorder(), knockSize: 100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        MyDialog.toast('button pressed');
                      },
                      child: const Text('button'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KnockShape extends ShapeBorder {
  const KnockShape({
    required this.knocked,
    required this.knockSize,
  });

  final ShapeBorder knocked;
  final double knockSize;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path()..addRect(rect);
    return Path.combine(
        PathOperation.difference,
        path,
        knocked.getOuterPath(Rect.fromCenter(
            center: rect.center, width: knockSize, height: knockSize)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path()..addRect(rect);
    return Path.combine(
        PathOperation.difference,
        path,
        knocked.getOuterPath(Rect.fromCenter(
            center: rect.center, width: knockSize, height: knockSize)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect);
    //canvas.drawPath(path, Paint()..color=)
  }

  @override
  KnockShape scale(double t) {
    return KnockShape(knocked: knocked.scale(t), knockSize: knockSize * t);
  }
}
