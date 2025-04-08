import 'package:flutter/material.dart';

class PlayerButtonPage extends StatefulWidget {
  const PlayerButtonPage({super.key});

  @override
  State<PlayerButtonPage> createState() => _PlayerButtonPageState();
}

class _PlayerButtonPageState extends State<PlayerButtonPage> {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Color(0xFF9EA2AC),
      fontSize: 18,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: Color(0xCCFFFFFF),
          offset: Offset(0, 0),
          blurRadius: 4,
        )
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Button'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: CirclePlayerButton(textStyle: textStyle),
        ),
      ),
    );
  }
}

class CirclePlayerButton extends StatefulWidget {
  const CirclePlayerButton({
    super.key,
    required this.textStyle,
  });

  final TextStyle textStyle;

  @override
  State<CirclePlayerButton> createState() => _CirclePlayerButtonState();
}

class _CirclePlayerButtonState extends State<CirclePlayerButton> {
  final pressedPosition = ValueNotifier<Alignment>(Alignment.center);

  void setAlignment(Offset localPos) {
    var rectBox = context.findRenderObject() as RenderBox?;
    if (rectBox != null) {
      var rect = rectBox.size;
      pressedPosition.value = Alignment(
        (localPos.dx * 2 / rect.width - 1).clamp(-1, 1),
        (localPos.dy * 2 / rect.height - 1).clamp(-1, 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setAlignment(details.localPosition);
      },
      onPanUpdate: (details) {
        setAlignment(details.localPosition);
      },
      onPanCancel: () {
        pressedPosition.value = Alignment.center;
      },
      onPanEnd: (details) {
        pressedPosition.value = Alignment.center;
      },
      onTapUp: (details) {
        pressedPosition.value = Alignment.center;
      },
      child: ValueListenableBuilder<Alignment>(
        valueListenable: pressedPosition,
        builder: (context, snapshot, child) {
          return TweenAnimationBuilder<Alignment>(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCirc,
            tween: Tween(end: snapshot),
            builder: (context, value, _) {
              return Container(
                decoration: BoxDecoration(
                  //color: Color(0xFFECEDEF),
                  gradient: RadialGradient(
                    colors: [Color(0xFFCCCCCC), Color(0xFFEEEEEE)],
                    //colors: [Color(0xFFEEEEEE), Color(0xFFDDDDDD)],

                    focal: value,
                  ),
                  border: Border.all(color: Color(0xFFFFFFFF)),
                  shape: BoxShape.circle,
                ),
                child: child,
              );
            },
          );
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFCCCCCC),
                  border: Border.all(color: Color(0xFF999999)),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'PLAY LIST',
                  style: widget.textStyle,
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.fast_rewind,
                  size: 32,
                  color: widget.textStyle.color,
                  shadows: widget.textStyle.shadows,
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.fast_forward,
                  size: 32,
                  color: widget.textStyle.color,
                  shadows: widget.textStyle.shadows,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow,
                    size: 32,
                    color: widget.textStyle.color,
                    shadows: widget.textStyle.shadows,
                  ),
                  Icon(
                    Icons.pause,
                    size: 32,
                    color: widget.textStyle.color,
                    shadows: widget.textStyle.shadows,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
