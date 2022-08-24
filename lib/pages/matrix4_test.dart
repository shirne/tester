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
  final matrixs = Matrix4.identity().storage.toList();

  late final settings = List.generate(16, (i) {
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
    return MatrixSetWidget(
      index: i,
      min: min,
      max: max,
      value: matrixs[i],
      onChange: (v) {
        setState(() {
          matrixs[i] = v;
        });
      },
    );
  });

  @override
  void initState() {
    super.initState();
  }

  void reset() {
    matrixs.fillRange(0, 16, 0);
    matrixs[0] = 1.0;
    matrixs[5] = 1.0;
    matrixs[10] = 1.0;
    matrixs[15] = 1.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix4'),
        actions: [
          IconButton(
            onPressed: () {
              reset();
            },
            icon: const Icon(Icons.wifi_protected_setup),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(child: Text('参数设置')),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: settings,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
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
    );
  }
}

class MatrixSetWidget extends StatefulWidget {
  const MatrixSetWidget({
    Key? key,
    required this.index,
    this.min = -9,
    this.max = 9,
    this.value = 0,
    this.onChange,
  }) : super(key: key);

  final int index;
  final double min;
  final double max;
  final double value;
  final void Function(double)? onChange;

  @override
  State<MatrixSetWidget> createState() => _MatrixSetWidgetState();
}

class _MatrixSetWidgetState extends State<MatrixSetWidget> {
  late double value = widget.value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matrix ${widget.index}'),
            Text('${widget.value}'),
          ],
        ),
        Expanded(
            child: CupertinoSlider(
          value: value,
          min: widget.min,
          max: widget.max,
          divisions: 100,
          onChanged: (v) {
            setState(() {
              value = v;
            });
            widget.onChange?.call(value);
          },
        )),
        GestureDetector(
          onTap: () {
            value = widget.value;
            widget.onChange?.call(value);
          },
          child: const Icon(Icons.wifi_protected_setup),
        ),
      ],
    );
  }
}
