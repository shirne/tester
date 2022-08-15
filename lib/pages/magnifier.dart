import 'package:flutter/material.dart';

import '../widgets/magnifier.dart';

class MagnifierPage extends StatelessWidget {
  const MagnifierPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnifier'),
      ),
      body: Magnifier(
        power: 2,
        size: 200,
        child: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.blue.shade50, Colors.blue]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: const [
                  Text('topleft'),
                  Spacer(),
                  Text('topright'),
                ],
              ),
              const Spacer(),
              Center(
                child: Image.network(
                  'https://www.htobao.net/attachment/images/1/2021/02/MPuB1T069fBY96yY1zapaN9qohhOPz.png?x-oss-process=style/normal',
                  height: 200,
                ),
              ),
              const Center(
                  child: SizedBox(
                      width: 300,
                      child: Text('text1,text1,text1,text1,text1,text1'))),
              const Center(
                  child: SizedBox(
                      width: 300, child: Text('text2,text2,text2,text2'))),
              const Center(
                  child:
                      SizedBox(width: 300, child: Text('text3,text3,text3'))),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('start'),
                ),
              ),
              const Spacer(),
              Row(
                children: const [
                  Text('bottomleft'),
                  Spacer(),
                  Text('bottomright'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
