import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkewTest extends StatefulWidget {
  const SkewTest({Key? key}) : super(key: key);

  @override
  State<SkewTest> createState() => _SkewTestState();
}

class _SkewTestState extends State<SkewTest> {
  List<double> matrixs = List.filled(16, 0.0);
  double stepper = 0;
  Matrix4 inint = Matrix4.identity();

  @override
  void initState() {
    super.initState();
    inint = Matrix4.identity();
    matrixs[0] = 1.0;
    matrixs[5] = 1.0;
    matrixs[10] = 1.0;
    matrixs[15] = 1.0;
    print(inint);
  }

  setStepper(double percent) {
    stepper = percent;
    setState(() {
      matrixs[4] = -0.105 * stepper;
      matrixs[5] = inint.storage[5] + (0.9 - inint.storage[5]) * stepper;
      matrixs[7] = -0.004 * stepper;
    });
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
                    title: const Text('Matrix'),
                    subtitle: Text(
                      matrixs[4].toString() +
                          "\n" +
                          matrixs[5].toString() +
                          "\n" +
                          matrixs[7].toString(),
                      softWrap: false,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        setStepper(0);
                      },
                      child: const Icon(Icons.wifi_protected_setup),
                    ),
                    trailing: CupertinoSlider(
                      value: stepper,
                      min: -1,
                      max: 1,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          setStepper(value);
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
