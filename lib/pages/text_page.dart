import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 用于复现文本排版问题
class TextPage extends StatefulWidget {
  const TextPage({Key? key}) : super(key: key);

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  String text = '';
  TextEditingController controller = TextEditingController();
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
                '无空格文本',
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
                '混排123Counter有空格文本1。   ',
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
                '有空格AlignEnd文本   ',
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
                '宽空格结尾文本   　',
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
                '零宽字符结尾    \u{200b}',
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
                  text: '有空格在RichText中    ',
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
            const Text('TextField 强制换行'),
            SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$text\u{200b}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.composing.isCollapsed) {
                          return TextEditingValue(
                              text: Characters(
                                      newValue.text.replaceAll('\u200b', ''))
                                  .join("\u200b"));
                        }
                        return newValue;
                      })
                    ],
                    onChanged: ((value) => setState(() {
                          text = value;
                          controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: text.length));
                        })),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
