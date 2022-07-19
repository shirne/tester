import 'package:flutter/material.dart';

class Other extends StatefulWidget {
  const Other({Key? key}) : super(key: key);

  @override
  State<Other> createState() => _OtherState();
}

class _OtherState extends State<Other> {
  @override
  void initState() {
    super.initState();
    print('=========other page showed');
  }

  @override
  void dispose() {
    print('=========other page hided');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('other page')),
      body: Container(
        alignment: Alignment.center,
        child: const Text('Other page'),
      ),
    );
  }
}
