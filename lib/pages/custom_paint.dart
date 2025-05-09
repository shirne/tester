import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class CustomPaintPage extends StatelessWidget {
  const CustomPaintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom paint')),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 400,
          child: CustomPaint(
            painter: Sky(),
            child: const Center(
              child: Text(
                'Once upon a time...',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint());
    final Rect rect = Offset.zero & size;
    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.2,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawCircle(
      Offset.zero,
      rect.width,
      Paint()..shader = gradient.createShader(rect),
    );

    // canvas.saveLayer(
    //   null,
    //   Paint()
    //     ..color = Colors.black
    //     ..blendMode = BlendMode.dstIn,
    // );

    final widthHalf = size.width / 2;
    final heightHalf = size.height / 2;
    canvas.drawPath(
      Path()
        ..moveTo(widthHalf, 0)
        ..lineTo(0, heightHalf - 1)
        ..lineTo(size.width, heightHalf - 1)
        ..lineTo(widthHalf, 0)
        ..close(),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.dstOut,
    );

    // canvas.drawCircle(
    //   Offset(10, 10),
    //   rect.width * 0.7,
    //   Paint()
    //     ..color = Colors.black
    //     ..blendMode = BlendMode.dstIn,
    // );

    //canvas.restore();
    canvas.restore();
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
