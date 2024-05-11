import 'package:flutter/material.dart';

class Word2ColorPage extends StatefulWidget {
  const Word2ColorPage({super.key, required this.title});

  final String title;

  @override
  State<Word2ColorPage> createState() => _Word2ColorPageState();
}

class _Word2ColorPageState extends State<Word2ColorPage> {
  double lightness = 0.35;
  double saturation = 0.6;

  void update(VoidCallback callback) {
    setState(() {
      callback();
    });
  }

  Color getColor(int hash, double l, double s) {
    final color = Color((hash & 0xFFFFFF) + 0xFF000000);
    final hsl = HSLColor.fromColor(color);

    return hsl.withLightness(l).withSaturation(s).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: const Text('亮度'),
                ),
                Expanded(
                  child: Slider(
                    value: lightness,
                    onChanged: (v) {
                      update(() {
                        lightness = v;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: const Text('饱和度'),
                ),
                Expanded(
                  child: Slider(
                    value: saturation,
                    onChanged: (v) {
                      update(() {
                        saturation = v;
                      });
                    },
                  ),
                ),
              ],
            ),
            for (int i = 'A'.codeUnitAt(0); i <= 'Z'.codeUnitAt(0); i++)
              getRow(i),
          ],
        ),
      ),
    );
  }

  Widget getRow(int c) {
    final char = String.fromCharCode(c);
    return Row(
      children: [
        const SizedBox(width: 16),
        Container(alignment: Alignment.center, width: 60, child: Text(char)),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getColor(char.hashCode, lightness, saturation),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.black,
            alignment: Alignment.center,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getColor(char.hashCode, 1 - lightness, saturation),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
