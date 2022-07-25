import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomScrollTestPage extends StatefulWidget {
  const CustomScrollTestPage({Key? key}) : super(key: key);

  @override
  State<CustomScrollTestPage> createState() => _CustomScrollTestPageState();
}

const expandedHeight = 160.0;

class _CustomScrollTestPageState extends State<CustomScrollTestPage> {
  ScrollController controller = ScrollController();
  double progress = 0;
  @override
  void initState() {
    super.initState();
    controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    super.dispose();
  }

  _onScroll() {
    setState(() {
      progress =
          math.min(1, controller.offset / (expandedHeight - kToolbarHeight));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: math.max(0, expandedHeight + 50 - controller.offset),
              child: Image.asset(
                'assets/images/bg.jpg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                backgroundColor:
                    Colors.blue.withAlpha((progress * 255).round()),
                collapsedHeight: kToolbarHeight,
                expandedHeight: expandedHeight,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  centerTitle: false,
                  titlePadding: EdgeInsets.zero,
                  title: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: (kToolbarHeight - 30) / 2 + (1 - progress) * 40,
                        child: Align(
                          alignment: Alignment(-1 + 2 * progress, 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FlutterLogo(
                              duration: Duration(milliseconds: 0),
                              size: 30 + (1 - progress) * 30,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 + progress * 32),
                          child: SizedBox(
                            height: kToolbarHeight,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Press on the plus to add items above and below',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      alignment: Alignment.center,
                      color: Colors.blue[200 + index % 4 * 100],
                      height: 100 + index % 4 * 20.0,
                      child: Text('Item: $index'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
