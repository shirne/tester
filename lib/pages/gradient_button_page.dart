import 'package:flutter/material.dart';

class GradientButtonPage extends StatelessWidget {
  const GradientButtonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Buttons'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExtendedButton(
                    onPressed: () {},
                    extendedStyle: ExtendedButtonStyle(
                      gradient: MaterialStateProperty.all(const LinearGradient(
                          colors: [Colors.blue, Colors.red])),
                    ),
                    child: const Text('Button'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Button'),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExtendedButton(
                    onPressed: null,
                    extendedStyle: ExtendedButtonStyle(
                      gradient: MaterialStateProperty.all(const LinearGradient(
                          colors: [Colors.blue, Colors.red])),
                    ),
                    child: const Text('Button'),
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Button'),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExtendedButton(
                    onPressed: () {},
                    extendedStyle: ExtendedButtonStyle(
                      gradient: MaterialStateProperty.all(
                        const SweepGradient(
                          colors: [
                            Colors.blue,
                            Colors.green,
                            Colors.cyan,
                            Colors.red,
                            Colors.blue,
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Button'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExtendedButton(
                    onPressed: () {},
                    extendedStyle: ExtendedButtonStyle(
                      gradient: MaterialStateProperty.all(
                        const RadialGradient(
                          colors: [
                            Colors.blue,
                            Colors.red,
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Button'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExtendedButton(
                    onPressed: () {},
                    extendedStyle: ExtendedButtonStyle(
                      gradient: MaterialStateProperty.resolveWith(
                        (state) {
                          if (state.contains(MaterialState.pressed)) {
                            return const LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.amber,
                                Colors.blue,
                                Colors.green,
                              ],
                            );
                          }
                          return const LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.green,
                              Colors.red,
                              Colors.amber,
                            ],
                          );
                        },
                      ),
                      duration: MaterialStateProperty.all(
                        const Duration(milliseconds: 1000),
                      ),
                    ),
                    child: const Text('Button'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExtendedButton(
                    onPressed: () {},
                    extendedStyle: ExtendedButtonStyle(
                      gradient: MaterialStateProperty.all(
                        const LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.red,
                          ],
                        ),
                      ),
                      transform: MaterialStateProperty.resolveWith((state) {
                        if (state.contains(MaterialState.pressed)) {
                          return Matrix4.identity()..scale(0.95);
                        }
                        return Matrix4.identity();
                      }),
                      duration: MaterialStateProperty.resolveWith((state) {
                        if (state.contains(MaterialState.pressed)) {
                          return const Duration(milliseconds: 200);
                        }
                        return const Duration(milliseconds: 500);
                      }),
                      curve: MaterialStateProperty.resolveWith((state) {
                        if (state.contains(MaterialState.pressed)) {
                          return Curves.easeOut;
                        }
                        return Curves.bounceOut;
                      }),
                    ),
                    child: const Text('Button'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _transparent = Color(0x00ffffff);

class _NullButton extends ElevatedButton {
  const _NullButton() : super(onPressed: null, child: null);

  ButtonStyle defaultStyle(BuildContext context) {
    return defaultStyleOf(context);
  }
}

class ExtendedButtonStyle {
  final MaterialStateProperty<DecorationImage>? image;
  final MaterialStateProperty<Gradient>? gradient;
  final MaterialStateProperty<Matrix4>? transform;
  final MaterialStateProperty<BlendMode>? blendMode;
  final MaterialStateProperty<Duration> duration;
  final MaterialStateProperty<Curve>? curve;

  ExtendedButtonStyle({
    this.image,
    this.gradient,
    this.transform,
    this.blendMode,
    MaterialStateProperty<Duration>? duration,
    this.curve,
  }) : duration = duration ??
            MaterialStateProperty.all(
              const Duration(milliseconds: 200),
            );

  ExtendedButtonStyle copyWith({
    MaterialStateProperty<DecorationImage>? image,
    MaterialStateProperty<Gradient>? gradient,
    MaterialStateProperty<Matrix4>? transform,
    MaterialStateProperty<BlendMode>? blendMode,
    MaterialStateProperty<Duration>? duration,
    MaterialStateProperty<Curve>? curve,
  }) {
    return ExtendedButtonStyle(
      image: image ?? this.image,
      gradient: gradient ?? this.gradient,
      transform: transform ?? this.transform,
      blendMode: blendMode ?? this.blendMode,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }
}

class ExtendedButton extends StatelessWidget {
  ExtendedButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    MaterialStatesController? statesController,
    ExtendedButtonStyle? extendedStyle,
    this.width,
    this.height,
    required this.child,
  })  : statesController = statesController ??
            MaterialStatesController({
              if (onPressed == null) MaterialState.disabled,
            }),
        extendedStyle = extendedStyle ?? ExtendedButtonStyle(),
        super(key: key);

  final double? width;
  final double? height;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final ButtonStyle? style;

  final Clip clipBehavior;

  final FocusNode? focusNode;

  final bool autofocus;

  final MaterialStatesController statesController;

  final Widget? child;

  final ExtendedButtonStyle extendedStyle;

  static MaterialStateProperty<Gradient> fromTheme(ThemeData theme) {
    return MaterialStateProperty.all(
      LinearGradient(
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
        ],
      ),
    );
  }

  ButtonStyle _fallbackStyle(BuildContext context) {
    return style ??
        Theme.of(context).elevatedButtonTheme.style ??
        const _NullButton().defaultStyle(context);
  }

  ButtonStyle _noBackgroundStyle(BuildContext context) {
    return _fallbackStyle(context).copyWith(
      backgroundColor: MaterialStateProperty.all(
        _transparent,
      ),
      shadowColor: MaterialStateProperty.all(
        _transparent,
      ),
    );
  }

  BoxDecoration _resolveDecoration(
    BuildContext context,
    ButtonStyleButton button,
    Set<MaterialState> value,
  ) {
    final buttonStyle = _fallbackStyle(context);
    final border = buttonStyle.shape?.resolve(value);
    BoxShape shape = BoxShape.rectangle;
    BorderRadiusGeometry? borderRadius;
    BoxShadow? shadow;
    if (border is StadiumBorder) {
      borderRadius = BorderRadius.circular(1000);
    } else if (border is BeveledRectangleBorder) {
      borderRadius = border.borderRadius;
    } else if (border is CircleBorder) {
      shape = BoxShape.circle;
      borderRadius = BorderRadius.circular(1000);
    } else if (border is RoundedRectangleBorder) {
      borderRadius = border.borderRadius;
    }

    final elevation = buttonStyle.elevation?.resolve(value);
    final shadowColor = buttonStyle.shadowColor?.resolve(value) ??
        Theme.of(context).shadowColor;
    if (elevation != null) {
      if (elevation > 0) {
        shadow = BoxShadow(
          color: shadowColor.withAlpha(80),
          offset: Offset(0, elevation / 1.8),
          blurRadius: elevation * 1.5,
          spreadRadius: 0,
          blurStyle: BlurStyle.normal,
        );
      }
    }

    return BoxDecoration(
      color: buttonStyle.backgroundColor?.resolve(value),
      image: extendedStyle.image?.resolve(value),
      gradient: extendedStyle.gradient?.resolve(value),
      backgroundBlendMode: extendedStyle.blendMode?.resolve(value),
      shape: shape,
      borderRadius: borderRadius,
      boxShadow: shadow != null ? [shadow] : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<MaterialState>>(
      valueListenable: statesController,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: extendedStyle.duration.resolve(value),
          curve: extendedStyle.curve?.resolve(value) ?? Curves.linear,
          width: width,
          height: height,
          transform: extendedStyle.transform?.resolve(value),
          transformAlignment: Alignment.center,
          clipBehavior: clipBehavior,
          decoration: _resolveDecoration(
            context,
            child as ButtonStyleButton,
            value,
          ),
          child: child,
        );
      },
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        clipBehavior: clipBehavior,
        focusNode: focusNode,
        autofocus: autofocus,
        statesController: statesController,
        style: _noBackgroundStyle(context),
        child: child,
      ),
    );
  }
}
