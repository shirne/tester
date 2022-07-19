import 'package:flutter/material.dart';

/// 用于复现文本排版问题
class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: const Text(
                '我是一条文本',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: const Text(
                '我混排123Counter文本1。   ',
                style: TextStyle(
                  fontFamily: 'PT Sans',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: const Text(
                '我是一条文本   ',
                textAlign: TextAlign.end,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: const Text(
                '我是一条文本有空格   　',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: const Text(
                'hello    \u{200b}',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: const Text.rich(
                TextSpan(
                  text: '我是一条文本有空格    ',
                  children: [
                    TextSpan(
                      text: '|',
                      style: TextStyle(color: Colors.transparent),
                    )
                  ],
                ),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
