import 'dart:ui';

import 'package:flutter/material.dart';

class FilterTestPage extends StatefulWidget {
  const FilterTestPage({Key? key}) : super(key: key);

  @override
  State<FilterTestPage> createState() => _FilterTestPageState();
}

class _FilterTestPageState extends State<FilterTestPage> {
  int coverIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Music'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (coverIndex >= 3) {
                  coverIndex = 1;
                } else {
                  coverIndex++;
                }
              });
            },
            child: const Text(
              '切换',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 背景
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Image.asset(
                'assets/images/cover$coverIndex.jpeg',
                fit: BoxFit.fill,
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ShaderMask(
              shaderCallback: (rect) {
                final ratio =
                    0.5 * (rect.right - rect.left) / (rect.bottom - rect.top) -
                        0.05;
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: [
                    0,
                    ratio,
                    ratio + 0.1,
                    (1 - ratio) - 0.1,
                    1 - ratio,
                    1
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/cover$coverIndex.jpeg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ListView.builder(
              primary: true,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                    child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.white),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
