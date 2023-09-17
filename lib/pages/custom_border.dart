import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomBorderPage extends StatelessWidget {
  const CustomBorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义边框'),
      ),
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [Colors.blue, Colors.red]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(blurRadius: 20, spreadRadius: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBorder extends BoxBorder {
  final Radius radius;
  const CustomBorder({this.radius = Radius.zero});

  @override
  BorderSide get top => BorderSide.none;

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.symmetric(
        horizontal: radius.x,
        vertical: radius.y,
      );

  @override
  bool get isUniform => false;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final width = rect.width - radius.x * 2;
    final height = rect.height - radius.y * 2;
    return Path()
      ..moveTo(0, 0)
      ..relativeLineTo(rect.width - radius.x, 0)
      ..relativeArcToPoint(Offset(radius.x, radius.y), radius: radius)
      ..relativeLineTo(0, height)
      ..relativeArcToPoint(Offset(-radius.x, radius.y), radius: radius)
      ..relativeLineTo(width, 0)
      ..relativeArcToPoint(Offset(-radius.x, -radius.y), radius: radius)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    // TODO: implement paint
  }

  @override
  CustomBorder scale(double t) {
    return CustomBorder(
      radius: Radius.elliptical(
        math.max(0.0, radius.x * t),
        math.max(0.0, radius.y * t),
      ),
    );
  }
}
