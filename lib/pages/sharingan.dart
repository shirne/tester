import 'dart:math' as math;
import 'package:flutter/material.dart';

class SharinganPage extends StatefulWidget {
  const SharinganPage({super.key});

  @override
  State<SharinganPage> createState() => _SharinganPageState();
}

class _SharinganPageState extends State<SharinganPage> {
  double smallRadius = 0.2;
  double innerRadius = 0.2;
  double innerArc = 30;
  double outerRadius = 0.7;
  double outerArc = 30;
  bool showControl = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('写轮眼'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showControl = !showControl;
              });
            },
            icon: Icon(
              showControl ? Icons.visibility_off : Icons.visibility,
            ),
          )
        ],
      ),
      body: Flex(
        direction: MediaQuery.of(context).size.aspectRatio > 1
            ? Axis.horizontal
            : Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: RouondEye(
                  showControl: showControl,
                  smallRadius: smallRadius,
                  innerRadius: innerRadius,
                  innerArc: innerArc,
                  outerRadius: outerRadius,
                  outerArc: outerArc,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: const Text('内圈'),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.1,
                        max: 0.8,
                        value: smallRadius,
                        onChanged: (v) {
                          setState(() {
                            smallRadius = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: const Text('内圈控制点'),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.1,
                        max: 0.8,
                        value: innerRadius,
                        onChanged: (v) {
                          setState(() {
                            innerRadius = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: const Text('控制点回转'),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: 120,
                        value: innerArc,
                        onChanged: (v) {
                          setState(() {
                            innerArc = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: const Text('外圈控制点'),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.1,
                        max: 1,
                        value: outerRadius,
                        onChanged: (v) {
                          setState(() {
                            outerRadius = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: const Text('控制点回转'),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: 120,
                        value: outerArc,
                        onChanged: (v) {
                          setState(() {
                            outerArc = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RouondEye extends CustomPainter {
  RouondEye({
    this.smallRadius = 0.2,
    this.innerRadius = 0.4,
    this.innerArc = 30,
    this.outerRadius = 0.7,
    this.outerArc = 30,
    this.showControl = false,
  });

  final double smallRadius;
  final double innerRadius;
  final double innerArc;
  final double outerRadius;
  final double outerArc;
  final bool showControl;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..strokeWidth = 4
        ..color = Colors.black
        ..style = PaintingStyle.stroke,
    );
    final sinInner = math.sin(math.pi * innerArc / 180);
    final cosInner = math.cos(math.pi * innerArc / 180);

    final sinInner30 = math.sin(math.pi * (innerArc + 60) / 180);
    final cosInner30 = math.cos(math.pi * (innerArc + 60) / 180);

    final sinInner60 = math.sin(math.pi * (innerArc + 30) / 180);
    final cosInner60 = math.cos(math.pi * (innerArc + 30) / 180);

    final sinOuter = math.sin(math.pi * outerArc / 180);
    final cosOuter = math.cos(math.pi * outerArc / 180);

    final sinOuter30 = math.sin(math.pi * (outerArc + 60) / 180);
    final cosOuter30 = math.cos(math.pi * (outerArc + 60) / 180);

    final sinOuter60 = math.sin(math.pi * (outerArc + 30) / 180);
    final cosOuter60 = math.cos(math.pi * (outerArc + 30) / 180);

    final sRadius = radius * innerRadius;
    final hRadius = radius * outerRadius;

    final control1 =
        Offset(radius - sRadius * sinInner, radius - sRadius * cosInner);
    final control2 =
        Offset(radius + hRadius * sinOuter30, radius + hRadius * cosOuter30);

    final control3 =
        Offset(radius + sRadius * sinInner30, radius + sRadius * cosInner30);
    final control4 =
        Offset(radius - hRadius * cosOuter60, radius + hRadius * sinOuter60);

    final control5 =
        Offset(radius - sRadius * cosInner60, radius + sRadius * sinInner60);
    final control6 =
        Offset(radius - hRadius * sinOuter, radius - hRadius * cosOuter);

    final sin60 = math.sin(math.pi / 3);
    final path = Path()
      ..moveTo(radius, 0)
      ..cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        radius * (1 + sin60),
        radius * 1.5,
      )
      ..cubicTo(
        control3.dx,
        control3.dy,
        control4.dx,
        control4.dy,
        radius * (1 - sin60),
        radius * 1.5,
      )
      ..cubicTo(
        control5.dx,
        control5.dy,
        control6.dx,
        control6.dy,
        radius,
        0,
      )
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius * smallRadius,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.fill,
    );
    if (showControl) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.red;
      canvas.drawCircle(control1, 4, paint);
      canvas.drawCircle(control2, 4, paint);

      paint.color = Colors.green;
      canvas.drawCircle(control3, 4, paint);
      canvas.drawCircle(control4, 4, paint);

      paint.color = Colors.blue;
      canvas.drawCircle(control5, 4, paint);
      canvas.drawCircle(control6, 4, paint);
    }
  }

  @override
  bool shouldRepaint(RouondEye oldDelegate) =>
      showControl != oldDelegate.showControl ||
      smallRadius != oldDelegate.smallRadius ||
      innerRadius != oldDelegate.innerRadius ||
      innerArc != oldDelegate.innerArc ||
      outerRadius != oldDelegate.outerRadius ||
      outerArc != oldDelegate.outerArc;
}
