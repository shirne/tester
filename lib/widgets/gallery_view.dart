import 'dart:math';

import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  final ScrollController? controller;
  final int itemCount;
  final int minPerRow;
  final int maxPerRow;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext, int)? itemBuilder;
  final List<Widget>? children;

  GalleryView({
    Key? key,
    this.controller,
    required this.children,
    this.minPerRow = 1,
    this.maxPerRow = 10,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutQuad,
  })  : assert(children != null),
        itemBuilder = null,
        itemCount = children!.length,
        super(key: key);

  GalleryView.builder({
    Key? key,
    this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.minPerRow = 1,
    this.maxPerRow = 10,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutQuad,
  })  : assert(itemBuilder != null),
        children = null,
        super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView>
    with SingleTickerProviderStateMixin<GalleryView> {
  // 当前显示的缩放值
  double _scale = 1;

  // 缩放过程中 `_rowCount`改变前的最后缩放值
  double _lastScale = 1;

  // 每次缩放结束时计算得的目标缩放值
  double _targetScale = 1;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // 当前显示的每行数量，缩放过程中会保持比当前屏幕大一个
  int _rowCount = 4;

  // 缩放结束时计算的每行数量
  int _realCount = 4;

  // 是否有缩放操作. 一指滑动时也会触发onScaleUpdate 但scale值始终是1
  bool isScaled = false;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(_onTicker);
  }

  @override
  dispose() {
    _controller.stop(canceled: true);
    _controller.removeListener(_onTicker);
    _controller.dispose();
    super.dispose();
  }

  _updateScale(double newScale) {
    double absScale = newScale / _lastScale;

    int newCount = (_rowCount / absScale).ceil();

    // 限制最小缩放
    if (newCount >= widget.maxPerRow) {
      newCount = widget.maxPerRow;
      if (absScale < 1) {
        absScale = 1;
      }
    }

    if (newCount != _rowCount) {
      double viewScale = _rowCount / newCount;
      _lastScale *= viewScale;
      absScale = absScale / viewScale;
      _rowCount = newCount;
    }

    setState(() {
      _scale = absScale;
    });
  }

  _onTicker() {
    if (_controller.value == 1) {
      setState(() {
        _rowCount = _realCount;
        _lastScale = 1;
        _scale = 1;
      });
      _controller.reset();
    } else {
      setState(() {
        _scale =
            _scaleAnimation.value * (_targetScale - _lastScale) + _lastScale;
      });
    }
  }

  _updateRelease() {
    _realCount = (_rowCount / _scale).round();
    _realCount = max(widget.minPerRow, min(widget.maxPerRow, _realCount));
    _targetScale = _rowCount / _realCount;
    _lastScale = _scale;

    // 最终缩放值与当前值接近时，截取动画时长
    double percent = min(1, (_scale - _targetScale).abs());

    _controller.duration = Duration(
        milliseconds: (widget.duration.inMilliseconds * percent).round());
    _scaleAnimation = _controller.drive(CurveTween(curve: widget.curve));
    _controller.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (detail) {
        if (detail.pointerCount >= 2) {
          isScaled = true;
          _updateScale(detail.scale);
        }
      },
      onScaleEnd: (detail) {
        if (isScaled) {
          isScaled = false;
          _updateRelease();
        }
      },
      child: Transform(
        transform: Matrix4.identity()..scale(_scale, _scale),
        child: GridView.builder(
          itemCount: widget.itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _rowCount,
          ),
          itemBuilder: (context, index) {
            return AnimatedSwitcher(
              duration: widget.duration,
              switchInCurve: Curves.linear,
              switchOutCurve: Curves.linear,
              // 默认layout小图片不会铺满
              layoutBuilder: (widget, widgets) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ...widgets,
                    if (widget != null) widget,
                  ],
                );
              },
              child: Container(
                key: _ItemKey(index, _rowCount, widget.maxPerRow),
                child: widget.itemBuilder != null
                    ? widget.itemBuilder!(context, index)
                    : widget.children![index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemKey extends ValueKey<int> {
  _ItemKey(int value, int currentRowCount, int maxRowCount)
      : super(
            (value ~/ currentRowCount) * maxRowCount + value % currentRowCount);
}
