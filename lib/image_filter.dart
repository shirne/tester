import 'dart:ui';

import 'package:flutter/material.dart';

class FilterTestPage extends StatefulWidget {
  const FilterTestPage({Key? key}) : super(key: key);

  @override
  State<FilterTestPage> createState() => _FilterTestPageState();
}

class _FilterTestPageState extends State<FilterTestPage> {
  bool isShow = true;
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
                isShow = !isShow;
              });
            },
            child: Text(isShow ? '隐藏' : '显示'),
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
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(
                'assets/images/bg.jpg',
              ),
            ),
          ),

          /// 第一层filter，硬边缘，上下尺寸小一点
          Positioned(
            child: AnimatedOpacity(
              opacity: isShow ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 150,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20,
                        tileMode: TileMode.clamp,
                      ),
                      child: Container(
                        height: 150,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 150,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 第二层filter, 软边缘
          Positioned(
            child: AnimatedOpacity(
              opacity: isShow ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Column(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                      tileMode: TileMode.decal,
                    ),
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                            'assets/images/bg.jpg',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY: 20,
                      tileMode: TileMode.decal,
                    ),
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                            'assets/images/bg.jpg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Center(child: Text('$index'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
