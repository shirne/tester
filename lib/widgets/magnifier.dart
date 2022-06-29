import 'dart:typed_data';
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

  double transLeft = 0;
  double transTop = 0;

  bool showMagnifier = false;

  Size size = Size.zero;

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

    setState(() {
      left = math.max(
          0,
          math.min(size.width - widget.size,
              event.position.dx - widget.size / widget.power));
      top = math.max(
          0,
          math.min(size.height - kToolbarHeight - widget.size,
              event.position.dy - kToolbarHeight - widget.size / widget.power));
      transLeft = -event.position.dx; // 和power 什么关系?
      transTop = -event.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
                    Float64List.fromList([
                      widget.power, 0, 0, 0, //
                      0, widget.power, 0, 0,
                      0, 0, 1, 0,
                      transLeft, transTop, 0, 1
                    ]),
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
