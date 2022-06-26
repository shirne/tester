import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatrixSkew extends StatefulWidget {
  const MatrixSkew({Key? key}) : super(key: key);

  @override
  State<MatrixSkew> createState() => _MatrixSkewState();
}

class _MatrixSkewState extends State<MatrixSkew> {
  double skewX = 0;
  double skewY = 0;
  double rotationX = 0;
  double translate = 0;
  Matrix4 init = Matrix4.identity();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                    title: const Text('SkewX'),
                    subtitle: Text(
                      skewX.toString(),
                      softWrap: false,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        setState(() {
                          skewX = 0;
                        });
                      },
                      child: const Icon(Icons.wifi_protected_setup),
                    ),
                    trailing: CupertinoSlider(
                      value: skewX,
                      min: -1,
                      max: 1,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          skewX = value;
                        });
                      },
                    )),
                ListTile(
                    title: const Text('SkewY'),
                    subtitle: Text(
                      skewY.toString(),
                      softWrap: false,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        setState(() {
                          skewY = 0;
                        });
                      },
                      child: const Icon(Icons.wifi_protected_setup),
                    ),
                    trailing: CupertinoSlider(
                      value: skewY,
                      min: -1,
                      max: 1,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          skewY = value;
                        });
                      },
                    )),
                ListTile(
                    title: const Text('rotationX'),
                    subtitle: Text(
                      rotationX.toString(),
                      softWrap: false,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        setState(() {
                          rotationX = 0;
                        });
                      },
                      child: const Icon(Icons.wifi_protected_setup),
                    ),
                    trailing: CupertinoSlider(
                      value: rotationX,
                      min: -3,
                      max: 3,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          rotationX = value;
                        });
                      },
                    )),
                ListTile(
                    title: const Text('translate'),
                    subtitle: Text(
                      translate.toString(),
                      softWrap: false,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        setState(() {
                          translate = 0;
                        });
                      },
                      child: const Icon(Icons.wifi_protected_setup),
                    ),
                    trailing: CupertinoSlider(
                      value: translate,
                      min: -50,
                      max: 50,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          translate = value;
                        });
                      },
                    ))
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 250.0,
                  height: 250.0,
                  color: Colors.lightBlue,
                  transformAlignment: Alignment.center,
                  transform: (Matrix4.skew(skewX, skewY) +
                      Matrix4.rotationX(rotationX) +
                      Matrix4.translationValues(
                          translate, translate, translate)),
                  child: const AnimatedAlign(
                    alignment: Alignment.bottomLeft,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    child: FlutterLogo(size: 50.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
