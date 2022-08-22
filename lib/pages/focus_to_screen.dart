import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class FocusToScreenPage extends StatefulWidget {
  const FocusToScreenPage({Key? key}) : super(key: key);

  @override
  State<FocusToScreenPage> createState() => _FocusToScreenPageState();
}

class _FocusToScreenPageState extends State<FocusToScreenPage>
    with SingleTickerProviderStateMixin {
  final controllers = <int, TextEditingController>{};
  final focusNodes = <int, FocusNode>{};
  int focusIndex = -1;

  ScrollController? scrollController;

  late Ticker ticker;
  @override
  void initState() {
    super.initState();
    ticker = createTicker((elapsed) {
      (fetchTimer ?? observeTimer)?.call();
    })
      ..start();
  }

  @override
  void dispose() {
    ticker.stop();
    ticker.dispose();

    for (final fn in focusNodes.values) {
      fn.dispose();
    }
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// How to notify when keyboard is shown
  /// and there is not enough height under focus object ?
  final keyboardNotifier = ValueNotifier<double>(0);

  double? _keyBoardHeight;
  double get keyBoardHeight {
    _refreshKeyboardHeight();
    return _keyBoardHeight ?? 0;
  }

  /// 修正键盘最终弹起高度
  VoidCallback? fetchTimer;
  void _refreshKeyboardHeight() {
    if (fetchTimer != null) return;
    double height = 0;
    int tickers = 0;
    fetchTimer = () {
      tickers++;
      final mediaData = MediaQuery.of(context);
      print('keyBoardHeight: ${mediaData.viewPadding.bottom}'
          ' ${mediaData.padding.bottom}'
          ' ${mediaData.viewInsets.bottom}');
      if (mediaData.viewInsets.bottom > 0) {
        if (mediaData.viewInsets.bottom > height) {
          height = mediaData.viewInsets.bottom;
        } else {
          final renderObject = (FocusManager
                  .instance.rootScope.focusedChild?.context as Element?)
              ?.renderObject;
          if (renderObject != null) {
            keyboardNotifier.value = height;

            print('_refreshKeyboardHeight: $height');
            showOnScreen(renderObject, height);
            //currentNeedShow = null;
          }
          _keyBoardHeight = height;
          fetchTimer = null;
        }
      } else if (tickers > 100) {
        fetchTimer = null;
      }
    };
  }

  VoidCallback? observeTimer;
  void observeKeyboardHeight() {
    if (observeTimer != null) return;
    print('observeKeyboardHeight: ${keyboardNotifier.value}');
    observeTimer = () {
      final mediaData = MediaQuery.of(context);
      if (mediaData.viewInsets.bottom <= 0) {
        print('observeKeyboardHeight: stop');
        keyboardNotifier.value = 0;
        observeTimer = null;
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollController = PrimaryScrollController.of(context);
  }

  bool showOnScreen(RenderObject object, double kh) {
    keyboardNotifier.value = kh;

    print('showOnScreen: $kh');

    WidgetsBinding.instance.scheduleFrameCallback((timestamp) {
      object.showOnScreen(
        //rect: computeRect(object.paintBounds, kh),
        duration: const Duration(milliseconds: 250),
      );
    });

    return true;
  }

  Rect computeRect(Rect? rect, [double? kh]) {
    return Rect.fromLTRB(
      rect?.left ?? 0,
      rect?.top ?? 0,
      rect?.right ?? 0,
      (rect?.bottom ?? 0) + (kh ?? keyBoardHeight) + 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print('root: ${FocusManager.instance.rootScope.hasFocus}');
          if (FocusManager.instance.rootScope.hasFocus) {
            FocusManager.instance.rootScope
              ..requestFocus(FocusNode())
              ..unfocus();
          }
        },
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 240,
              actions: [
                IconButton(
                  onPressed: () {
                    if (focusNodes.isNotEmpty) {
                      int index = focusIndex - 1;
                      if (index < 0) {
                        index = focusNodes.length - 1;
                      }
                      focusNodes[index]?.requestFocus();
                    }
                  },
                  icon: const Icon(Icons.arrow_upward_outlined),
                ),
                IconButton(
                  onPressed: () {
                    if (focusNodes.isNotEmpty) {
                      int index = focusIndex + 1;
                      if (index >= focusNodes.length) {
                        index = 0;
                      }
                      focusNodes[index]?.requestFocus();
                    }
                  },
                  icon: const Icon(Icons.arrow_downward_outlined),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Focus To Screen'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[50]!,
                        Colors.blue[100]!,
                        Colors.blue[600]!,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: List.generate(
                10,
                (i) => AspectRatio(
                  aspectRatio: 1,
                  child: Container(color: Colors.primaries[i % 18][100]),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return CustomShownRectWidget(
                    onComputeRect: computeRect,
                    child: Container(
                      height: 50,
                      color: Colors.primaries[i % 18][100],
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onTap: () {
                          focusNodes[i]?.requestFocus();
                        },
                        controller: controllers.putIfAbsent(
                          i,
                          () => TextEditingController(text: '$i'),
                        ),
                        focusNode: focusNodes.putIfAbsent(
                          i,
                          () => FocusNode(debugLabel: '$i')
                            ..addListener(() {
                              focusIndex = i;
                            }),
                        ),
                      ),
                    ),
                  );
                },
                childCount: 30,
              ),
            ),
            SliverToBoxAdapter(
              child: ValueListenableBuilder<double>(
                valueListenable: keyboardNotifier,
                builder: (context, value, child) {
                  if (value > 0) {
                    observeKeyboardHeight();
                  }
                  return SizedBox(height: value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShownRectWidget extends SingleChildRenderObjectWidget {
  const CustomShownRectWidget({
    Key? key,
    Widget? child,
    this.onComputeRect,
  }) : super(key: key, child: child);

  final Rect Function(Rect?)? onComputeRect;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomShownRectRenderObject(
      onComputeRect: onComputeRect,
    );
  }
}

class CustomShownRectRenderObject extends RenderProxyBox {
  CustomShownRectRenderObject({
    RenderBox? child,
    this.onComputeRect,
  });

  final Rect Function(Rect?)? onComputeRect;

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    final newRect = onComputeRect?.call(rect) ?? rect;
    print(newRect);
    return super.showOnScreen(
      descendant: descendant,
      rect: newRect,
      duration: duration,
      curve: curve,
    );
  }
}
