import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringAnimation extends StatefulWidget {
  final Widget child;
  final SpringDescription description;
  final double minScale;
  const SpringAnimation(
      {Key? key,
      required this.child,
      this.minScale = 0.8,
      this.description = const SpringDescription(
        damping: 1,
        mass: 1,
        stiffness: 1,
      )})
      : super(key: key);

  @override
  State<SpringAnimation> createState() => _SpringAnimationState();
}

class _SpringAnimationState extends State<SpringAnimation>
    with SingleTickerProviderStateMixin {
  late final SpringSimulation simulation = SpringSimulation(
    widget.description,
    0,
    1,
    1,
  );
  double scale = 1;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: widget.minScale - 0.2,
      upperBound: 1.2,
    );
    _animationController.duration = const Duration(seconds: 1);
    _animationController.reverseDuration = const Duration(seconds: 1);
    _animationController.value = 1;
    _animationController.addListener(_onAnimate);
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimate);
    _animationController.dispose();
    super.dispose();
  }

  _onAnimate() {
    setState(() {
      scale = _animationController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detail) {
        setState(() {
          _animationController.stop(canceled: true);
          _animationController.animateWith(SpringSimulation(
            SpringDescription(
              damping: widget.description.damping,
              mass: 10,
              stiffness: widget.description.stiffness,
            ),
            _animationController.value,
            widget.minScale,
            0,
          ));
        });
      },
      onTapUp: (detail) {
        _animationController.stop(canceled: true);
        _animationController.animateWith(SpringSimulation(
          widget.description,
          _animationController.value,
          1,
          0,
        ));
      },
      child: Transform.scale(
        scale: scale,
        child: widget.child,
      ),
    );
  }
}
