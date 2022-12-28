import 'dart:math';
import 'package:flutter/material.dart';

/// 三角柱切换代码
/// 来源：@阿立 | 上海 | Flutter
///
class TrigonalPrismPage extends StatelessWidget {
  const TrigonalPrismPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TrigonalPrismWidget(
          width: 200,
          height: 400,
          color: Colors.white,
          page1: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const Card(
                color: Colors.amber,
                // child: TextField(),
              ),
            ),
          ),
          page2: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            clipBehavior: Clip.antiAlias,
          ),
          page3: Container(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      ),
    );
  }
}

class TrigonalPrismWidget extends StatefulWidget {
  final bool rotateX;
  final bool rotateY;
  final Color? color;
  final double width;
  final double height;

  final Widget page1;
  final Widget page2;
  final Widget page3;

  const TrigonalPrismWidget({
    Key? key,
    this.rotateX = true,
    this.rotateY = true,
    this.color,
    required this.width,
    required this.height,
    required this.page1,
    required this.page2,
    required this.page3,
  }) : super(key: key);

  @override
  State<TrigonalPrismWidget> createState() => _TrigonalPrismWidgetState();
}

class _TrigonalPrismWidgetState extends State<TrigonalPrismWidget> {
  Offset angle = const Offset(0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          setState(() {
            angle += Offset(
              widget.rotateY ? details.delta.dy * 0.01 : 0.0,
              widget.rotateX ? -details.delta.dx * 0.01 : 0.0,
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            final rotatedValue = angle.dy % (2 * pi);
            if (rotatedValue >= pi * 5 / 3 && rotatedValue <= pi * 2) {
              angle = const Offset(
                0.0,
                0.0,
              );
            } else if (rotatedValue >= 0 && rotatedValue < pi / 3) {
              angle = const Offset(
                0.0,
                0.0,
              );
            } else if (rotatedValue >= pi / 3 && rotatedValue < pi * 2 / 3) {
              angle = const Offset(
                0.0,
                pi * 2 / 3,
              );
            } else if (rotatedValue >= pi * 2 / 3 && rotatedValue < pi) {
              angle = const Offset(
                0.0,
                pi * 2 / 3,
              );
            } else if (rotatedValue >= pi && rotatedValue < pi * 4 / 3) {
              angle = const Offset(
                0.0,
                pi * 4 / 3,
              );
            } else if (rotatedValue >= pi * 4 / 3 &&
                rotatedValue < pi * 5 / 3) {
              angle = const Offset(
                0.0,
                pi * 4 / 3,
              );
            }
          });
        },
        child: Container(
          color: widget.color ?? Colors.black,
          alignment: Alignment.center,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008)
              ..rotateX(angle.dx)
              ..rotateY(angle.dy),
            alignment: Alignment.center,
            child: Cube(
              angle: angle,
              width: widget.width,
              height: widget.height,
              page1: widget.page1,
              page2: widget.page2,
              page3: widget.page3,
            ),
          ),
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  final Offset angle;
  final double width;
  final double height;
  final Widget page1;
  final Widget page2;
  final Widget page3;

  const Cube({
    super.key,
    required this.angle,
    required this.width,
    required this.height,
    required this.page1,
    required this.page2,
    required this.page3,
  });

  @override
  Widget build(BuildContext context) {
    final Widget widget1 = Transform(
      transform: Matrix4.identity()
        ..translate(0.0, 0.0, -width / 3 * cos(0))
        ..rotateY(0),
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: page1,
      ),
    );
    final Widget widget2 = Transform(
      transform: Matrix4.identity()
        ..translate(width / 3 * sin(pi / 3), 0.0, width / 3 * cos(pi / 3))
        ..rotateY(pi / 3),
      alignment: Alignment.center,
      child: Transform(
        transform: Matrix4.identity()..rotateY(pi),
        alignment: Alignment.center,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: page2,
        ),
      ),
    );
    final Widget widget3 = Transform(
      transform: Matrix4.identity()
        ..translate(-width / 3 * sin(pi / 3), 0.0, width / 3 * cos(pi / 3))
        ..rotateY(pi * 2 / 3),
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: page3,
      ),
    );
    List<Widget> widgetList = <Widget>[];
    final rotatedValue = angle.dy % (2 * pi);
    if (rotatedValue >= pi * 5 / 3 && rotatedValue <= pi * 2) {
      widgetList = [
        widget2,
        widget3,
        widget1,
      ];
    } else if (rotatedValue >= 0 && rotatedValue < pi / 3) {
      widgetList = [
        widget3,
        widget2,
        widget1,
      ];
    } else if (rotatedValue >= pi / 3 && rotatedValue < pi * 2 / 3) {
      widgetList = [
        widget3,
        widget1,
        widget2,
      ];
    } else if (rotatedValue >= pi * 2 / 3 && rotatedValue < pi) {
      widgetList = [
        widget1,
        widget3,
        widget2,
      ];
    } else if (rotatedValue >= pi && rotatedValue < pi * 4 / 3) {
      widgetList = [
        widget1,
        widget2,
        widget3,
      ];
    } else if (rotatedValue >= pi * 4 / 3 && rotatedValue < pi * 5 / 3) {
      widgetList = [
        widget2,
        widget1,
        widget3,
      ];
    }
    return Stack(
      children: widgetList,
    );
  }
}
