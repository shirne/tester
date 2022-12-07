import 'package:flutter/material.dart';

class ScribbleEyePage extends StatefulWidget {
  const ScribbleEyePage({super.key});

  @override
  State<ScribbleEyePage> createState() => _ScribbleEyePageState();
}

class _ScribbleEyePageState extends State<ScribbleEyePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Scribble Eye'),
      ),
      body: Center(
        child: CustomPaint(
          painter: ScribbleEyePainter(),
          size: const Size(200, 200),
        ),
      ),
    );
  }
}

class ScribbleEyePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // 绘制写轮眼外圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // 绘制写轮眼内圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 4, paint);

    // 绘制写轮眼上下两条直线
    canvas.drawLine(Offset(size.width / 2, size.height / 4),
        Offset(size.width / 2, size.height * 3 / 4), paint);

    // 绘制写轮眼左右两条直线
    canvas.drawLine(Offset(size.width / 4, size.height / 2),
        Offset(size.width * 3 / 4, size.height / 2), paint);

    // 绘制写轮眼左侧曲线
    var path = Path();
    path.moveTo(size.width / 4, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height / 4, size.width / 2, size.height / 2);
    canvas.drawPath(path, paint);
    // 绘制写轮眼右侧曲线
    path = Path();
    path.moveTo(size.width * 3 / 4, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height * 3 / 4, size.width / 2, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ScribbleEyePainter oldDelegate) {
    return false;
  }
}
