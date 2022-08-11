import 'package:flutter/material.dart';

class WidgetTest extends StatefulWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  State<WidgetTest> createState() => _WidgetTestPageState();
}

class _WidgetTestPageState extends State<WidgetTest> {
  int _counter = 0;
  final controller = ScrollController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuart,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scroll to bottom"),
      ),
      body: Center(
        child: Container(
          width: 150,
          height: 300,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 0.5)),
          child: ListView.builder(
            controller: controller,
            padding: const EdgeInsets.all(10),
            itemCount: _counter,
            itemBuilder: (context, index) => Text('This is row $index'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
