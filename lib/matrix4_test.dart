import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class Matrix4Test extends StatefulWidget {
  const Matrix4Test({Key? key}) : super(key: key);

  @override
  State<Matrix4Test> createState() => _Matrix4TestState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _Matrix4TestState extends State<Matrix4Test> {
  bool selected = false;
  double entryRow = 1;
  double entryCol = 1;
  double entryV = 0.1;

  double rotateX = 1;
  double rotateY = 1;
  double rotateZ = 1;
  List<double> matrixs = List.filled(16, 0.0);

  @override
  void initState() {
    super.initState();
    matrixs[0] = 1.0;
    matrixs[5] = 1.0;
    matrixs[10] = 1.0;
    matrixs[15] = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    print(matrixs);
    List<Widget> settings = [];
    int idx = 0;
    for (var element in matrixs) {
      int i = idx++;
      double min = -9;
      double max = 9;
      if (i > 11) {
        min = -100;
        max = 100;
      }
      if (i == 3 || i == 7 || i == 11) {
        min = -0.1;
        max = 0.1;
      }
      settings.add(ListTile(
        title: Text('Matrix $i'),
        subtitle: Text(
          matrixs[i].toString(),
          softWrap: false,
        ),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              matrixs[i] = Matrix4.identity().storage[i];
            });
          },
          child: const Icon(Icons.wifi_protected_setup),
        ),
        trailing: CupertinoSlider(
          value: matrixs[i],
          min: min,
          max: max,
          divisions: 100,
          onChanged: (value) {
            setState(() {
              matrixs[i] = value;
            });
          },
        ),
      ));
    }
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SingleChildScrollView(
            child: Column(
              children: settings,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected = !selected;
              });
            },
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 250.0,
                    height: 250.0,
                    color: Colors.lightBlue,
                    transform: (Matrix4(
                        matrixs[0],
                        matrixs[1],
                        matrixs[2],
                        matrixs[3],
                        matrixs[4],
                        matrixs[5],
                        matrixs[6],
                        matrixs[7],
                        matrixs[8],
                        matrixs[9],
                        matrixs[10],
                        matrixs[11],
                        matrixs[12],
                        matrixs[13],
                        matrixs[14],
                        matrixs[15])),
                    child: AnimatedAlign(
                      alignment:
                          selected ? Alignment.topRight : Alignment.bottomLeft,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: const FlutterLogo(size: 50.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
