import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollBehaviorPage extends StatefulWidget {
  const ScrollBehaviorPage({Key? key}) : super(key: key);

  @override
  State<ScrollBehaviorPage> createState() => _ScrollBehaviorPageState();
}

class _ScrollBehaviorPageState extends State<ScrollBehaviorPage> {
  bool mouseCanDrag = true;
  bool mouseCanDragChange = false;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('scrollBehavior'),
        actions: [
          Switch(
              value: mouseCanDrag,
              onChanged: (v) {
                setState(() {
                  mouseCanDrag = v;
                  mouseCanDragChange = true;
                });
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    mouseCanDragChange = false;
                  });
                });
              })
        ],
      ),
      body: ScrollConfiguration(
        behavior: mouseCanDrag ? EnableMouseBehavior() : DisableMouseBehavior(),
        child: ListView.builder(
          controller: controller,
          physics:
              mouseCanDragChange ? const NeverScrollableScrollPhysics() : null,
          itemBuilder: (context, index) {
            return Container(
              height: 50,
              alignment: Alignment.center,
              child: Text('$index'),
            );
          },
        ),
      ),
    );
  }
}

class EnableMouseBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.mouse,
        PointerDeviceKind.unknown,
      };
}

class DisableMouseBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      };
}
