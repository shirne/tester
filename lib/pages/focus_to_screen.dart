import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../fundation/keyboard_observe.dart';

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

  /// How to notify when keyboard is shown
  /// and there is not enough height under focus object ?
  late final keyboardNotifier = KeyboardObserve.fromSingle(
    vsync: this,
    autoStart: true,
  );

  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    keyboardNotifier.addListener(_checkFocusOnScreen);
  }

  @override
  void dispose() {
    keyboardNotifier.dispose();

    for (final fn in focusNodes.values) {
      fn.dispose();
    }
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _checkFocusOnScreen() {
    print('${keyboardNotifier.value}');
    if (keyboardNotifier.value > 0) {
      WidgetsBinding.instance.scheduleFrameCallback((timestamp) {
        if (completer != null && !completer!.isCompleted) {
          completer!.complete(keyboardNotifier.value);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollController = PrimaryScrollController.of(context);
  }

  Completer<double>? completer;
  FutureOr<Rect> computeRect(Rect? rect, [double? kh]) {
    if (kh == null) {
      kh = keyboardNotifier.storeValue;
      print(kh);
      if (kh == 0) {
        if (completer == null || completer!.isCompleted) {
          completer = Completer<double>();
        }
        return completer!.future.then((value) => computeRect(rect, value));
      }
    }
    return Rect.fromLTRB(
      rect?.left ?? 0,
      rect?.top ?? 0,
      rect?.right ?? 0,
      (rect?.bottom ?? 0) + kh + 10,
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
        child: Focus(
          canRequestFocus: false,
          onKey: (node, event) {
            print('$node $event');
            return KeyEventResult.handled;
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
                                print('FocusNode: $i');
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<double>(
        valueListenable: keyboardNotifier,
        builder: (context, value, child) {
          print('bottom placeholder: $value');
          return SizedBox(
            height: value,
            child: child,
          );
        },
        child: Container(
          color: Colors.black12,
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

  final FutureOr<Rect> Function(Rect?)? onComputeRect;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomShownRectRenderObject(
      computeRect: (Rect? rect) {
        final result = onComputeRect?.call(rect);
        if (result != null) {
          if (result is Future) {
            (result as Future).then((rect) {
              print('request showOnScreen $rect');
              context.findRenderObject()?.showOnScreen(
                    rect: rect,
                  );
            });
          } else {
            return result;
          }
        }
        return rect;
      },
    );
  }
}

class CustomShownRectRenderObject extends RenderProxyBox {
  CustomShownRectRenderObject({
    RenderBox? child,
    this.computeRect,
  });

  final Rect? Function(Rect?)? computeRect;

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    final newRect = computeRect?.call(rect) ?? rect;
    print('CustomShownRect rect: $rect');
    return super.showOnScreen(
      descendant: descendant,
      rect: newRect ?? rect,
      duration: duration,
      curve: curve,
    );
  }
}
