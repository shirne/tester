import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Magnifier extends StatefulWidget {
  final double size;
  final double power;
  final Widget child;
  const Magnifier(
      {Key? key, required this.child, this.size = 200, this.power = 2})
      : super(key: key);

  @override
  State<Magnifier> createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  double left = 0;
  double top = 0;

  bool showMagnifier = false;

  Size size = Size.zero;
  Matrix4 translate = Matrix4.identity();

  void _onEnter(PointerEnterEvent event) {
    //print(event);
    setState(() {
      showMagnifier = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    //print(event);
    setState(() {
      showMagnifier = false;
    });
  }

  void _onHover(PointerHoverEvent event) {
    //print(event);
    final offsetTop = event.position.dy - event.localPosition.dy;
    final offsetLeft = event.position.dx - event.localPosition.dx;

    setState(() {
      left = math.max(
          0,
          math.min(size.width - offsetLeft - widget.size,
              event.position.dx - offsetLeft - widget.size / 2));
      top = math.max(
          0,
          math.min(size.height - offsetTop - widget.size,
              event.position.dy - offsetTop - widget.size / 2));
      translate = Matrix4.identity()
        ..translate(event.position.dx, event.position.dy)
        ..scale(widget.power)
        ..translate(-event.position.dx, -event.position.dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context);
    size = md.size;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: Stack(
        children: [
          widget.child,
          if (showMagnifier)
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ImageFilter.matrix(
                    translate.storage,
                    filterQuality: FilterQuality.low,
                  ),
                  child: Container(
                    //color: Colors.transparent,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
