import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

const double _kMinRectProgressIndicatorSize = 36.0;
const int _kIndeterminateRectDuration = 1333 * 2222;

class _RectProgressIndicatorPainter extends CustomPainter {
  _RectProgressIndicatorPainter({
    this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 2.0 +
                offsetValue * 0.5 * math.pi,
        arcSweep = value != null
            ? value.clamp(0.0, 1.0) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon);

  final Color? backgroundColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double arcStart;
  final double arcSweep;

  PathMetric? rect;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    rect ??= (Path()
          ..addRRect(RRect.fromLTRBR(
              0, 0, size.width, size.height, const Radius.circular(5))))
        .computeMetrics()
        .single;
    final total = rect!.length;
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    if (backgroundColor != null) {
      final Paint backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      //canvas.drawArc(Offset.zero & size, 0, _sweep, false, backgroundPaint);
      Path path = rect!.extractPath(0, total * _sweep);
      canvas.drawPath(path, backgroundPaint);
    }

    // Indeterminate
    if (value == null) {
      paint.strokeCap = StrokeCap.square;
    }

    //canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);

    canvas.drawPath(
        rect!.extractPath(total * arcStart / _twoPi, total * arcSweep / _twoPi),
        paint);
  }

  @override
  bool shouldRepaint(_RectProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth;
  }
}

/// A material design circular progress indicator, which spins to indicate that
/// the application is busy.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a circle. There are two kinds of circular
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator arc is displayed with [valueColor], an animated value. To
/// specify a constant color use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// {@tool dartpad --template=stateful_widget_material_ticker}
///
/// This example shows a [RectProgressIndicator] with a changing value.
///
/// ```dart
///  late AnimationController controller;
///
///  @override
///  void initState() {
///    controller = AnimationController(
///      vsync: this,
///      duration: const Duration(seconds: 5),
///    )..addListener(() {
///        setState(() {});
///      });
///    controller.repeat(reverse: true);
///    super.initState();
///  }
///
/// @override
/// void dispose() {
///   controller.dispose();
///   super.dispose();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Padding(
///       padding: const EdgeInsets.all(20.0),
///       child: Column(
///         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///         children: <Widget>[
///           Text(
///             'Linear progress indicator with a fixed color',
///             style: Theme.of(context).textTheme.headline6,
///           ),
///           RectProgressIndicator(
///             value: controller.value,
///             semanticsLabel: 'Linear progress indicator',
///           ),
///         ],
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [LinearProgressIndicator], which displays progress along a line.
///  * [RefreshIndicator], which automatically displays a [RectProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#circular-progress-indicators>
class RectProgressIndicator extends ProgressIndicator {
  /// Creates a circular progress indicator.
  ///
  /// {@macro flutter.material.ProgressIndicator.ProgressIndicator}
  const RectProgressIndicator({
    Key? key,
    double? value,
    Color? backgroundColor,
    Color? color,
    Animation<Color?>? valueColor,
    this.strokeWidth = 4.0,
    String? semanticsLabel,
    String? semanticsValue,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          color: color,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  Color _getValueColor(BuildContext context) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }

  /// The width of the line used to draw the circle.
  ///
  /// This property is ignored if used in an adaptive constructor inside an iOS
  /// environment.
  final double strokeWidth;

  @override
  _RectProgressIndicatorState createState() => _RectProgressIndicatorState();
}

class _RectProgressIndicatorState extends State<RectProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateRectDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateRectDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _offsetTween =
      CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween =
      CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateRectDuration),
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(RectProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double headValue,
      double tailValue, double offsetValue, double rotationValue) {
    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: _kMinRectProgressIndicatorSize,
          minHeight: _kMinRectProgressIndicatorSize,
        ),
        child: CustomPaint(
          painter: _RectProgressIndicatorPainter(
            backgroundColor: widget.backgroundColor,
            valueColor: widget._getValueColor(context),
            value: widget.value, // may be null
            headValue:
                headValue, // remaining arguments are ignored if widget.value is not null
            tailValue: tailValue,
            offsetValue: offsetValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(
          context,
          _strokeHeadTween.evaluate(_controller),
          _strokeTailTween.evaluate(_controller),
          _offsetTween.evaluate(_controller),
          _rotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      return _buildIndicator(context, 0.0, 0.0, 0, 0.0);
    }
    return _buildAnimation();
  }
}
