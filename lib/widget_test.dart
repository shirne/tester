import 'package:flutter/material.dart';

class WidgetTest extends StatelessWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('widgets'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              print('pressed');
            },
            style: ButtonStyle(
              // 文本颜色不能在textStyle中指定，需要指定foregroundColor
              textStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return const TextStyle(fontSize: 12);
                }
                return const TextStyle(fontSize: 16);
              }),
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black;
                }
                return Colors.white;
              }),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text('点击这个按钮'),
            ),
          ),
          const Text('text'),
          Navigator()
        ],
      ),
    );
  }
}
