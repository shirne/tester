import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class HitTestPage extends StatefulWidget {
  const HitTestPage({super.key});

  @override
  State<HitTestPage> createState() => _HitTestPageState();
}

class _HitTestPageState extends State<HitTestPage> {
  final pressedRect = ValueNotifier<Rect?>(null);
  final bottomHalfKey = GlobalKey();

  void showCover(BuildContext context) {
    if (pressedRect.value != null) return;

    final obj = context.findRenderObject() as RenderBox?;
    if (obj == null) return;
    final size = obj.size;
    final offset = obj.localToGlobal(Offset.zero);

    pressedRect.value = offset & size;
  }

  Widget _topHalfButton(int num) {
    return ElevatedButton(
      onPressed: () {
        MyDialog.toast('button$num pressed');
      },
      child: Text('button$num'),
    );
  }

  Widget _bottomHalfButton(int num) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTapDown: (details) {
          print('onTapDown $details');
        },
        onTapUp: (details) {
          print('onTapUp $details');
          pressedRect.value = null;
        },
        onPanDown: (details) {
          print('onPanDown $details');
          showCover(context);
        },
        onPanStart: (details) {
          print('onPanStart $details');
        },
        onPanUpdate: (details) {
          print('onPanUpdate $details');
        },
        onPanEnd: (details) {
          print('onPanEnd $details');
          pressedRect.value = null;
        },
        onPanCancel: () {
          print('onPanCancel');
          pressedRect.value = null;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'button$num',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('点击测试')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _topHalfButton(1),
                          _topHalfButton(2),
                          _topHalfButton(3),
                          _topHalfButton(4),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        MyDialog.toast('mask taped');
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withAlpha(50),
                          shape: KnockShape(
                            knocked: const CircleBorder(),
                            knockRect: Rect.fromCenter(
                                center: Offset(
                                  constraints.maxWidth / 2,
                                  constraints.maxHeight / 2,
                                ),
                                width: 200,
                                height: 200),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            key: bottomHalfKey,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _bottomHalfButton(1),
                        _bottomHalfButton(2),
                        _bottomHalfButton(3),
                        _bottomHalfButton(4),
                        _bottomHalfButton(5),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ValueListenableBuilder<Rect?>(
                    valueListenable: pressedRect,
                    builder: (context, value, child) {
                      if (value == null) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        decoration: ShapeDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withAlpha(50),
                          shape: KnockShape(
                            knocked: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            knockRect: value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KnockShape extends ShapeBorder {
  const KnockShape({
    required this.knocked,
    required this.knockRect,
  });

  final ShapeBorder knocked;
  final Rect knockRect;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path()..addRect(rect);
    return Path.combine(
      PathOperation.difference,
      path,
      knocked.getOuterPath(knockRect),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path()..addRect(rect);
    return Path.combine(
      PathOperation.difference,
      path,
      knocked.getOuterPath(knockRect),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect);
    //canvas.drawPath(path, Paint()..color=)
  }

  @override
  KnockShape scale(double t) {
    return KnockShape(knocked: knocked.scale(t), knockRect: knockRect);
  }
}
