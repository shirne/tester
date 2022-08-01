import 'package:flutter/material.dart';

class ScrollPage extends StatelessWidget {
  const ScrollPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('just a scroll page'),
      ),
      body: SafeArea(
        child: ListView.builder(
          primary: true,
          itemBuilder: (BuildContext context, int index) {
            if (index == 1) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue[200 + index % 4 * 100],
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 100 + index % 4 * 20.0,
                child: Text('Item: $index'),
              );
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              color: Colors.blue[200 + index % 4 * 100],
              height: 100 + index % 4 * 20.0,
              child: Text('Item: $index'),
            );
          },
        ),
      ),
    );
  }
}
