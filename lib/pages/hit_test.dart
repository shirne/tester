import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class HitTestPage extends StatefulWidget {
  const HitTestPage({super.key});

  @override
  State<HitTestPage> createState() => _HitTestPageState();
}

class _HitTestPageState extends State<HitTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('点击测试')),
      body: const Column(
        children: [
          Expanded(
            child: TopHalf(),
          ),
          Expanded(
            child: BottomHalf(),
          ),
        ],
      ),
    );
  }
}

class TopHalf extends StatelessWidget {
  const TopHalf({super.key});

  Widget _topHalfButton(int num) {
    return ElevatedButton(
      onPressed: () {
        MyDialog.toast('button$num pressed');
      },
      child: Text('button$num'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  MyDialog.toast('top mask taped');
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.shadow.withAlpha(50),
                    shape: KnockShape(
                      debugFlag: 'ShapeTop',
                      knocked: const CircleBorder(),
                      knockRect: Rect.fromCenter(
                        center: Offset(
                          constraints.maxWidth / 2,
                          constraints.maxHeight / 2 + kToolbarHeight,
                        ),
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class BottomHalf extends StatefulWidget {
  const BottomHalf({super.key});

  @override
  State<BottomHalf> createState() => _BottomHalfState();
}

class _BottomHalfState extends State<BottomHalf> {
  final pressedRect = ValueNotifier<Rect?>(null);

  void showCover(BuildContext context) {
    if (pressedRect.value != null) return;

    final obj = context.findRenderObject() as RenderBox?;
    if (obj == null) return;
    final size = obj.size;
    final offset = obj.localToGlobal(Offset.zero);

    pressedRect.value = offset & size;
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
    return Stack(
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
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      MyDialog.toast('button5 pressed');
                      if (pressedRect.value == null) {
                        showCover(context);
                      } else {
                        pressedRect.value = null;
                      }
                    },
                    child: Text('button$num'),
                  );
                }),
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
              return GestureDetector(
                onTap: () {
                  MyDialog.toast('bottom mask taped');
                },
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.shadow.withAlpha(50),
                    shape: KnockShape(
                      debugFlag: 'ShapeBottom',
                      knocked: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      knockRect: value,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class KnockShape extends ShapeBorder {
  const KnockShape({
    this.debugFlag = 'KnockShape',
    required this.knocked,
    required this.knockRect,
  });

  final String debugFlag;
  final ShapeBorder knocked;
  final Rect knockRect;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    print('[$debugFlag] getInnerPath: $rect');
    final path = Path()..addRect(rect);
    return Path.combine(
      PathOperation.difference,
      path,
      knocked.getInnerPath(knockRect),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    print('[$debugFlag] getOuterPath: $rect');
    final path = Path()..addRect(rect);
    return Path.combine(
      PathOperation.difference,
      path,
      knocked.getOuterPath(knockRect),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  KnockShape scale(double t) {
    return KnockShape(knocked: knocked.scale(t), knockRect: knockRect);
  }
}
