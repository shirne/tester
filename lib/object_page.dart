

import 'package:flutter/material.dart';

import 'object_3d.dart';

class ObjectPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Object3D(
          size: const Size(400.0, 400.0),
          path: "assets/obj/male02.obj",
          asset: true,
        ), //assets/file.obj为我们的本地obj文件，需要到pubspec.yaml中进行配置
      ),
    );
  }

}