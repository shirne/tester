import 'package:flutter/material.dart';
import 'dart:math';

class CardPage extends StatefulWidget {
  const CardPage({super.key, required this.title});

  final String title;

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final ValueNotifier<List<double>> _valueNotifier =
      ValueNotifier([0.0, 0.0, 0.0]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              child: ValueListenableBuilder<List<double>>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return Transform(
                    // 沿着卡片中间，Y轴旋转一圈
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // 添加透视效果
                      ..rotateY(-pi * 2 * value[0])
                      ..rotateX(-pi * 2 * value[1])
                      ..rotateZ(-pi * 2 * value[2]), // 绕Y轴旋转一圈（360度）
                    alignment: Alignment.center,
                    child: child!,
                  );
                },
                child: const PokerCardView(
                  number: '10',
                  type: PokerType.spade,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ValueListenableBuilder<List<double>>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return Slider(
                    value: value[0],
                    onChanged: (v) {
                      value[0] = v;
                      _valueNotifier.value = value.toList();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ValueListenableBuilder<List<double>>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return Slider(
                    value: value[1],
                    onChanged: (v) {
                      value[1] = v;
                      _valueNotifier.value = value.toList();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ValueListenableBuilder<List<double>>(
                valueListenable: _valueNotifier,
                builder: (context, value, child) {
                  return Slider(
                    value: value[2],
                    onChanged: (v) {
                      value[2] = v;
                      _valueNotifier.value = value.toList();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokerCardView extends StatelessWidget {
  const PokerCardView({
    super.key,
    required this.number,
    required this.type,
  });

  //点数A - K
  final String number;

  //花型
  final PokerType type;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 7,
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth / 2;
        final h = constraints.maxHeight / 2;
        return Stack(
          children: [
            //扑克背景图,沿Y轴旋转一圈
            Transform(
              alignment: Alignment.center,
              //和下面卡片有点间距
              transform: Matrix4.identity()
                ..translate(0.0, 0.0, 5.0)
                ..rotateY(-pi),
              child: Container(
                //decoration: const BoxDecoration(
                color: Colors.blue,
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                //),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.ac_unit,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

            Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(-w, 0.0, 0.0)
                  ..rotateY(pi / 2),
                alignment: Alignment.center,
                child: Container(
                  width: 10,
                  height: h * 2,
                  //decoration: const BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xffe80000),
                  //),
                ),
              ),
            ),
            Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(w, 0.0, 0.0)
                  ..rotateY(-pi / 2),
                alignment: Alignment.center,
                child: Container(
                  width: 10,
                  height: h * 2,
                  // decoration: const BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff00e800),
                  //),
                ),
              ),
            ),
            Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, -h, 0.0)
                  ..rotateX(pi / 2),
                alignment: Alignment.center,
                child: Container(
                  width: w * 2,
                  height: 10,
                  // decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff990000),
                  // ),
                ),
              ),
            ),
            Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, h, 0.0)
                  ..rotateX(-pi / 2),
                alignment: Alignment.center,
                child: Container(
                  width: w * 2,
                  height: 10,
                  // decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff009900),
                  // ),
                ),
              ),
            ),

            Transform(
              transform: Matrix4.identity()..translate(0.0, 0.0, -5.0),
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                // decoration: const BoxDecoration(
                //borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xffe8e8e8),
                //),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 20,
                        color: type.color,
                      ),
                    ),
                    Icon(
                      type.icon,
                      color: type.color,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

//花色枚举 红桃，黑桃，梅花，方块

enum PokerType {
  hearst, //红桃
  black, //黑桃
  spade, //梅花
  diamond //方块
}

extension PokerTypeExtension on PokerType {
  String get name {
    switch (this) {
      case PokerType.hearst:
        return "红桃";
      case PokerType.black:
        return "黑桃";
      case PokerType.spade:
        return "梅花";
      case PokerType.diamond:
        return "方块";
    }
  }

  Color get color {
    switch (this) {
      case PokerType.hearst:
      case PokerType.diamond:
        return Colors.red;
      case PokerType.black:
      case PokerType.spade:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case PokerType.hearst:
        return Icons.favorite;
      case PokerType.black:
        return Icons.ac_unit;
      case PokerType.spade:
        return Icons.grass;
      case PokerType.diamond:
        return Icons.diamond;
    }
  }
}
