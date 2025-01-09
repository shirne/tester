import 'package:flutter/material.dart';

class BottomExpandPage extends StatefulWidget {
  const BottomExpandPage({super.key});

  @override
  State<BottomExpandPage> createState() => _BottomExpandPageState();
}

class _BottomExpandPageState extends State<BottomExpandPage> {
  var isExpanded = ValueNotifier(false);
  var height = ValueNotifier(0.0);
  final int list1ItemCount = 100;
  final int list2ItemCount = 100;
  var handerKey = GlobalKey();
  final controller = ScrollController();
  final controller2 = ScrollController();

  // 记录上次的偏移位置，防止目标对象滑出视野dispose
  double? lastOffHeight;

  var bindScrollOffset = ValueNotifier(0.0);

  final handleBarHeight = 60.0;

  @override
  void initState() {
    super.initState();
    isExpanded.addListener(_onExpandChanged);
    bindScrollOffset.addListener(_onBindScroll);
    controller2.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var renderObj =
          handerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderObj != null) {
        var offset =
            renderObj.localToGlobal(Offset(0, renderObj.size.height)).dy;
        lastOffHeight = offset + controller.offset + 8;
      }
    });
  }

  @override
  void dispose() {
    isExpanded.removeListener(_onExpandChanged);
    bindScrollOffset.removeListener(_onBindScroll);
    controller2.removeListener(_onScroll);
    super.dispose();
  }

  void _onExpandChanged() {
    if (isExpanded.value) {
      var screenHeight = MediaQuery.of(context).size.height;
      var renderObj =
          handerKey.currentContext?.findRenderObject() as RenderBox?;
      var offheight = lastOffHeight ?? 60.0;

      if (renderObj != null) {
        var offset =
            renderObj.localToGlobal(Offset(0, renderObj.size.height)).dy;
        offheight = offset + controller.offset + 8;
        lastOffHeight = offheight;
      }

      height.value = screenHeight;
      bindScrollOffset.value = 0;

      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceIn,
      );
    } else {
      height.value = 0;
      controller2.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }
  }

  void _onBindScroll() {
    if (isExpanded.value) {
      controller.jumpTo(bindScrollOffset.value);
    }
  }

  void _onScroll() {
    if (isExpanded.value) {
      if (controller2.offset < (lastOffHeight ?? handleBarHeight)) {
        bindScrollOffset.value = controller2.offset;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: controller,
            slivers: [
              SliverAppBar(
                title: Text('appbar'),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    height: 60,
                    //  展开目标的固定锚点位置()
                    key: (index == 3) ? handerKey : null,
                    color: Colors.blue[100 * ((index % 8) + 1)],
                    child: Center(
                      child: Text(
                        '列表1 第 ${index + 1} 项',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  childCount: list1ItemCount,
                ),
              ),

              // 底部占位
              SliverToBoxAdapter(
                child: SizedBox(height: handleBarHeight),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: height,
              builder: (context, value, child) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 400),
                  tween: Tween(end: value + handleBarHeight),
                  builder: (context, value, child) {
                    return SizedBox(
                      height: value,
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              child: CustomScrollView(
                controller: controller2,
                physics:
                    isExpanded.value ? null : NeverScrollableScrollPhysics(),
                slivers: [
                  // 空白占位
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<double>(
                      valueListenable: height,
                      builder: (context, value, child) {
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 400),
                          tween:
                              Tween(end: isExpanded.value ? lastOffHeight : 0),
                          builder: (context, value, child) {
                            return SizedBox(height: value);
                          },
                          child: child,
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded.value = !isExpanded.value;
                        });
                      },
                      child: Container(
                        height: handleBarHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isExpanded.value ? '收起' : '展开列表1',
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(
                              isExpanded.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        height: 60,
                        color: Colors.blue[100 * ((index % 8) + 1)],
                        child: Center(
                          child: Text(
                            '列表2 第 ${index + 1} 项',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      childCount: list2ItemCount,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
