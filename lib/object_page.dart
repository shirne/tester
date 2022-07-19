import 'package:flutter/material.dart';

import 'object_3d.dart';

class ObjectPage extends StatelessWidget {
  const ObjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('obj3D load')),
      body: Container(
        color: Colors.black,
        child: const Center(
          child: Object3D(
            size: Size(400.0, 400.0),
            path: "assets/obj/male02.obj",
            asset: true,
          ), //assets/file.obj为我们的本地obj文件，需要到pubspec.yaml中进行配置
        ),
      ),
    );
  }
}
