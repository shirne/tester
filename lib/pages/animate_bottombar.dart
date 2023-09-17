import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const myBottomHeight = 80.0;

class AnimateBottomBarPage extends StatefulWidget {
  const AnimateBottomBarPage({super.key});

  @override
  State<AnimateBottomBarPage> createState() => _AnimateBottomBarPageState();
}

class _AnimateBottomBarPageState extends State<AnimateBottomBarPage> {
  int _counter = 0;

  int curIndex = 0;
  bool floatActived = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
      floatActived = !floatActived;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          sizeConstraints: BoxConstraints.loose(const Size.fromHeight(40)),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Bottombar'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          backgroundColor: Colors.transparent,
          shape: const StadiumBorder(),
          child: FloatingButton(
            isActived: floatActived,
          ),
        ),
        floatingActionButtonLocation:
            const NockedInFloatingActionButtonLocation(),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5.0,
          height: myBottomHeight,
          shape: const RoundedOuterNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            StadiumBorder(),
          ),
          child: Builder(builder: (context) {
            return CustomPaint(
              foregroundPainter: BottomCustomPainter(context, curIndex),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: BottomItem(
                      onPressed: () {
                        setState(() {
                          curIndex = 0;
                        });
                      },
                      isActived: curIndex == 0,
                      icon: Icons.home_max_outlined,
                      label: 'Home',
                    ),
                  ),
                  Expanded(
                    child: BottomItem(
                      onPressed: () {
                        setState(() {
                          curIndex = 1;
                        });
                      },
                      isActived: curIndex == 1,
                      icon: Icons.home_max_outlined,
                      label: 'Home',
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Expanded(
                    child: BottomItem(
                      onPressed: () {
                        setState(() {
                          curIndex = 3;
                        });
                      },
                      isActived: curIndex == 3,
                      icon: Icons.link_outlined,
                      label: 'Home',
                    ),
                  ),
                  Expanded(
                    child: BottomItem(
                      onPressed: () {
                        setState(() {
                          curIndex = 4;
                        });
                      },
                      isActived: curIndex == 4,
                      icon: Icons.mood_outlined,
                      label: 'Home',
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BottomCustomPainter extends CustomPainter {
  BottomCustomPainter(this.context, this.index);

  final BuildContext context;
  final int index;

  late final ScaffoldGeometry scaffoldGeometry =
      Scaffold.geometryOf(context).value;
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  Path getBorderPath(Rect hostRect, Rect? guestRect,
      [double borderWidth = 2, double margin = 5]) {
    const ab = RoundedOuterNotchedShape(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      StadiumBorder(),
    );
    final half = (margin) / 2;
    final Path hostPath = ab.getOuterPath(
        hostRect, //.deflate(borderWidth),
        guestRect == null
            ? null
            : Rect.fromLTRB(guestRect.left + half, guestRect.top,
                    guestRect.right + half, guestRect.bottom)
                .inflate(margin),
        guestRect == null ? null : Radius.circular(guestRect.shortestSide / 2));

    return hostPath;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(0, scaffoldGeometry.bottomNavigationBarTop!) & size;
    final path = getBorderPath(
      rect,
      scaffoldGeometry.floatingActionButtonArea!,
    );
    //canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final bounds = path.getBounds();
    final matrix = Matrix4.identity()..translate(-bounds.left, -bounds.top);
    final newPath = path.transform(matrix.storage);

    canvas.drawPath(
      newPath,
      Paint()
        //..color = Colors.white
        ..shader = RadialGradient(
          colors: [colorScheme.primary, colorScheme.primary.withAlpha(0)],
          //colors: [Color(0xffff0000), Color(0xffffffff)],
          stops: const [0, 1],
          radius: 1,
          center: const Alignment(0, -0.5),
        ).createShader(newPath.getBounds())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final itemWidth = size.width / 5;

    canvas.drawShadow(
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              itemWidth * index,
              size.height / 2,
              itemWidth,
              itemWidth,
            ),
            Radius.circular(itemWidth),
          ),
        ),
      colorScheme.primary,
      24,
      true,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoundedOuterNotchedShape extends AutomaticNotchedShape {
  const RoundedOuterNotchedShape(
      RoundedRectangleBorder host, StadiumBorder guest)
      : super(host, guest);

  @override
  Path getOuterPath(Rect hostRect, Rect? guestRect, [Radius? guestRadius]) {
    final Path hostPath;
    if (guest != null && guestRect != null) {
      guestRect = Rect.fromLTRB(
          guestRect.left, guestRect.top, guestRect.right, guestRect.bottom - 5);
      final half = (hostRect.width - guestRect.width) / 2;
      final radius = (host as RoundedRectangleBorder)
          .borderRadius
          .resolve(TextDirection.ltr);
      guestRadius ??= Radius.circular(guestRect.shortestSide / 2.0);

      hostPath = Path()
        ..moveTo(hostRect.left, hostRect.top + radius.topLeft.y)
        ..relativeArcToPoint(Offset(radius.topLeft.x, -radius.topLeft.y),
            radius: radius.topLeft)
        ..relativeLineTo(half - guestRadius.x - radius.topLeft.x, 0)
        ..relativeArcToPoint(Offset(guestRadius.x, guestRadius.y),
            radius: guestRadius)
        ..relativeLineTo(0, guestRect.height - guestRadius.y * 2)
        ..relativeArcToPoint(Offset(guestRadius.x, guestRadius.y),
            radius: guestRadius, clockwise: false)
        ..relativeLineTo(guestRect.width - guestRadius.x * 2, 0)
        ..relativeArcToPoint(Offset(guestRadius.x, -guestRadius.y),
            radius: guestRadius, clockwise: false)
        ..relativeLineTo(0, -guestRect.height + guestRadius.y * 2)
        ..relativeArcToPoint(Offset(guestRadius.x, -guestRadius.y),
            radius: guestRadius)
        ..relativeLineTo(half - guestRadius.x - radius.topLeft.x, 0)
        ..relativeArcToPoint(Offset(radius.topRight.x, radius.topRight.y),
            radius: radius.topRight)
        ..relativeLineTo(
            0, hostRect.height - radius.topRight.y - radius.bottomRight.y)
        ..relativeArcToPoint(
            Offset(-radius.bottomRight.x, radius.bottomRight.y),
            radius: radius.bottomRight)
        ..relativeLineTo(
            -hostRect.width + radius.bottomRight.x + radius.bottomLeft.x, 0)
        ..relativeArcToPoint(Offset(-radius.bottomLeft.x, -radius.bottomLeft.y),
            radius: radius.bottomLeft)
        ..close();
    } else {
      hostPath = host.getOuterPath(hostRect);
    }
    return hostPath;
  }
}

class NockedInFloatingActionButtonLocation extends StandardFabLocation
    with FabCenterOffsetX {
  const NockedInFloatingActionButtonLocation();

  @override
  double getOffsetY(
    ScaffoldPrelayoutGeometry scaffoldGeometry,
    double adjustment,
  ) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double contentMargin =
        scaffoldGeometry.scaffoldSize.height - contentBottom;
    final double bottomViewPadding = scaffoldGeometry.minViewPadding.bottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    final double bottomMinInset = scaffoldGeometry.minInsets.bottom;

    double safeMargin;

    if (contentMargin > bottomMinInset + fabHeight) {
      safeMargin = 0.0;
    } else if (bottomMinInset == 0.0) {
      safeMargin = bottomViewPadding;
    } else {
      safeMargin = fabHeight + kFloatingActionButtonMargin;
    }

    double fabY = contentBottom - safeMargin;

    if (snackBarHeight > 0.0) {
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    }

    if (bottomSheetHeight > 0.0) {
      fabY = math.min(fabY, contentBottom - bottomSheetHeight - fabHeight);
    }
    final double maxFabY =
        scaffoldGeometry.scaffoldSize.height - fabHeight - safeMargin;
    return math.min(maxFabY, fabY);
  }
}

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key, this.isActived = false});

  final bool isActived;

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton>
    with SingleTickerProviderStateMixin {
  late final baseAnimation = AnimationController(vsync: this)
    ..duration = const Duration(seconds: 1)
    ..addListener(() => setState(() {}));

  late final animation = CurvedAnimation(
    parent: baseAnimation,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    baseAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FloatingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActived) {
      baseAnimation
        ..stop(canceled: true)
        ..animateTo(1);
    } else {
      baseAnimation.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final p1 = (animation.value * 2).clamp(0, 1).toDouble();
    final p2 = ((animation.value - 0.5) * 2).clamp(0, 1).toDouble();

    final mv = myBottomHeight / 2 * p1;
    return Container(
      width: 64,
      decoration: BoxDecoration(
          color: Color.lerp(
            colorScheme.primary,
            const Color(0xFF242D34),
            p2,
          ),
          borderRadius: BorderRadius.circular(54),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha(50),
              offset: const Offset(0, 15),
              blurRadius: 30,
              spreadRadius: 15,
              blurStyle: BlurStyle.normal,
            )
          ]),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: p2,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(7.0, 7.0)
                  ..rotateZ(math.pi * 2 * p2)
                  ..translate(-7.0, -7.0),
                child: SvgPicture.asset(
                  'assets/svg/close.svg',
                  width: 14,
                  height: 14,
                ),
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 1 - p1,
              child: Transform(
                transform: Matrix4.identity()..translate(-3.0 - mv, -3.0 + mv),
                child: SvgPicture.asset(
                  'assets/svg/arrow.svg',
                  width: 13,
                  height: 13,
                ),
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 1 - p1,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(10.0 + mv, 9.0 - mv)
                  ..rotateZ(math.pi)
                  ..translate(-6.5, -6.5),
                child: SvgPicture.asset(
                  'assets/svg/arrow.svg',
                  width: 13,
                  height: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  const BottomItem({
    super.key,
    required this.isActived,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final bool isActived;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor:
            isActived ? colorScheme.primary : colorScheme.onSurface,
        shape: const StadiumBorder(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          Container(
            height: 16,
            alignment: Alignment.center,
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isActived
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Center(child: Text(label)),
              secondChild: Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
