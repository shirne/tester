import 'package:flutter/material.dart';

class ClipBorderPage extends StatelessWidget {
  const ClipBorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClipBorder'),
      ),
      body: const Center(
        child: ClipBorder(),
      ),
    );
  }
}

class ClipBorder extends StatelessWidget {
  const ClipBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BorderClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
        ),
        width: 200,
        height: 200,
      ),
    );
  }
}

class BorderClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..relativeLineTo(size.width / 2, 0)
      ..relativeLineTo(size.width / 2, size.height / 2)
      ..relativeLineTo(0, size.height / 2)
      ..relativeLineTo(-size.width / 2, 0)
      ..relativeLineTo(-size.width / 2, -size.height / 2)
      ..close();
    final matrix = Matrix4.identity()..scale(0.8);
    final path2 = path.transform(matrix.storage);
    return Path()
      ..addPath(path, Offset.zero)
      ..addPath(path2, Offset(size.width * 0.1, size.height * 0.1))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
