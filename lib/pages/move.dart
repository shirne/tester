import 'package:flutter/material.dart';

class MoveTestPage extends StatefulWidget {
  const MoveTestPage({Key? key}) : super(key: key);

  @override
  State<MoveTestPage> createState() => _MoveTestPageState();
}

class _MoveTestPageState extends State<MoveTestPage>
    with SingleTickerProviderStateMixin {
  double posM = -1;
  double posO = 0;
  double posN = 3;
  double posP = 0;

  double speedO = 0;
  double speedM = -2;
  double speedN = -3;
  double speedP = -1;

  static const offsetTop = 80.0;

  late final controller = AnimationController.unbounded(value: 0, vsync: this);
  @override
  void initState() {
    super.initState();
    controller.addListener(_onAnimate);
  }

  @override
  void dispose() {
    controller.removeListener(_onAnimate);
    super.dispose();
  }

  void _changeState() {
    if (controller.isAnimating) {
      controller.stop();
    } else {
      controller.animateTo(10, duration: const Duration(seconds: 20));
    }
  }

  void _onAnimate() {
    double value = controller.value;
    if (value.isInfinite) value = 0;
    setState(() {
      posM = -1 + value * speedM;
      posO = 0 + value * speedO;
      posN = 3 + value * speedN;
      posP = 0 + value * speedP;
    });
  }

  void reset() {
    controller.animateTo(0, duration: const Duration(milliseconds: 300));
  }

  double posToPos(double x) {
    double cell = MediaQuery.of(context).size.width / 20;
    return x * cell + 10 * cell - 1;
  }

  Widget dot(String tag, Color color) {
    return SizedBox(
      width: 1,
      height: 1,
      child: OverflowBox(
        maxWidth: 50,
        maxHeight: 100,
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tag),
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget info(String label, String result) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 5, bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label),
          ),
          Expanded(child: Text(result)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('move'),
        actions: [
          TextButton(
            onPressed: reset,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text('重置'),
          ),
          TextButton(
            onPressed: _changeState,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: Text(controller.isAnimating ? '停止' : '开始'),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: offsetTop, bottom: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        for (int i = -10; i < 10; i++)
                          Expanded(
                            child: Container(
                              height: 10,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black38),
                                  right: BorderSide(color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        for (int i = -10; i < 10; i++)
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: 1,
                                height: 16,
                                child: OverflowBox(
                                  maxWidth: 20,
                                  maxHeight: 20,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '$i',
                                    style:
                                        const TextStyle(color: Colors.black38),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: posToPos(posM),
                top: offsetTop + 10,
                child: dot('M', Colors.blue),
              ),
              Positioned(
                left: posToPos(posO),
                top: offsetTop + 10,
                child: dot('O', Colors.orange),
              ),
              Positioned(
                left: posToPos(posN),
                top: offsetTop + 10,
                child: dot('N', Colors.green),
              ),
              Positioned(
                left: posToPos(posP),
                top: offsetTop - 20,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: dot('P', Colors.red),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                info('M: ', '$posM'),
                info('N: ', '$posN'),
                info('O: ', '$posO'),
                info('P: ', '$posP'),
                info('P-M: ', '${posP - posM}'),
                info('P-N: ', '${posP - posN}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
