import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart' hide Matrix4;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_math/vector_math_64.dart' show Vector3, Matrix4;

class Object3D extends StatefulWidget {
  final Size size;
  final bool asset;
  final String path;
  final double zoom;
  final double? angleX;
  final double? angleY;
  final double? angleZ;

  final bool useInternal;

  const Object3D({
    Key? key,
    required this.size,
    required this.path,
    required this.asset,
    this.angleX,
    this.angleY,
    this.angleZ,
    this.zoom = 1.0,
  })  : useInternal =
            (angleX != null || angleY != null || angleZ != null) ? false : true,
        super(key: key);

  @override
  State<Object3D> createState() => _Object3DState();
}

class _Object3DState extends State<Object3D> {
  double angleX = 15.0;
  double angleY = 45.0;
  double angleZ = 0.0;

  double _previousX = 0.0;
  double _previousY = 0.0;

  late double zoom;
  String object = "V 1 1 1 1";

  late File file;

  @override
  void initState() {
    super.initState();
    if (widget.asset) {
      rootBundle.loadString(widget.path).then((String value) {
        setState(() {
          object = value;
        });
      });
    } else {
      File file = File(widget.path);
      file.readAsString().then((String value) {
        setState(() {
          object = value;
        });
      });
    }
  }

  void _updateCube(DragUpdateDetails data) {
    if (angleY > 360.0) {
      angleY = angleY - 360.0;
    }
    if (_previousY > data.globalPosition.dx) {
      setState(() {
        angleY = angleY - 1;
      });
    }
    if (_previousY < data.globalPosition.dx) {
      setState(() {
        angleY = angleY + 1;
      });
    }
    _previousY = data.globalPosition.dx;

    if (angleX > 360.0) {
      angleX = angleX - 360.0;
    }
    if (_previousX > data.globalPosition.dy) {
      setState(() {
        angleX = angleX - 1;
      });
    }
    if (_previousX < data.globalPosition.dy) {
      setState(() {
        angleX = angleX + 1;
      });
    }
    _previousX = data.globalPosition.dy;
  }

  void _updateY(DragUpdateDetails data) {
    _updateCube(data);
  }

  void _updateX(DragUpdateDetails data) {
    _updateCube(data);
  }

  void _updateZoom(ScaleUpdateDetails details) {
    print(details);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: _ObjectPainter(
          widget.size,
          object,
          widget.useInternal ? angleX : widget.angleX!,
          widget.useInternal ? angleY : widget.angleY!,
          widget.useInternal ? angleZ : widget.angleZ!,
          widget.zoom,
        ),
        size: widget.size,
      ),
      onHorizontalDragUpdate: _updateY,
      onVerticalDragUpdate: _updateX,
      //onScaleUpdate: _updateZoom,
    );
  }
}

class _ObjectPainter extends CustomPainter {
  final double _zoomFactor;

  final double _rotation = 5.0; // in degrees
  final double _scalingFactor = 10.0 / 100.0; // in percent
  double _translation = 0.1 / 100;

  final double zero = 0.0;

  final String object;

  double _viewPortX = 0.0, _viewPortY = 0.0;

  late List<Vector3> vertices;
  late List<dynamic> faces;
  late Matrix4 T;
  Vector3 camera = Vector3(0.0, 0.0, 0.0);
  Vector3 light = Vector3(0.0, 0.0, 100.0);

  double angleX;
  double angleY;
  double angleZ;

  Color color = const Color.fromARGB(255, 255, 255, 255);

  Size size;

  _ObjectPainter(
    this.size,
    this.object,
    this.angleX,
    this.angleY,
    this.angleZ,
    this._zoomFactor,
  ) {
    _translation *= _zoomFactor;

    _viewPortX = (size.width / 2).toDouble();
    _viewPortY = (size.height / 2).toDouble();
  }

  Map<String, dynamic> _parseObjString(String objString) {
    List<Vector3> vertices = [];
    List<List<int>> faces = [];
    List<int> face = [];

    List<String> lines = objString.split("\n");

    Vector3 vertex;

    for (var line in lines) {
      line = line.replaceAll(RegExp(r"\s+$"), "");
      List<String> chars = line.split(" ");

      // vertex
      if (chars[0] == "v") {
        vertex = Vector3(double.parse(chars[1]), double.parse(chars[2]),
            double.parse(chars[3]));

        vertices.add(vertex);

        // face
      } else if (chars[0] == "f") {
        for (var i = 1; i < chars.length; i++) {
          face.add(int.parse(chars[i].split("/")[0]));
        }

        faces.add(face);
        face = [];
      }
    }

    return {'vertices': vertices, 'faces': faces};
  }

  bool _shouldDrawFace(List face) {
    var normalVector = _normalVector3(
        vertices[face[0] - 1], vertices[face[1] - 1], vertices[face[2] - 1]);

    var dotProduct = normalVector.dot(camera);
    double vectorLengths = normalVector.length * camera.length;

    double angleBetween = dotProduct / vectorLengths;

    return angleBetween < 0;
  }

  Vector3 _normalVector3(Vector3 first, Vector3 second, Vector3 third) {
    Vector3 secondFirst = Vector3.copy(second);
    secondFirst.sub(first);
    Vector3 secondThird = Vector3.copy(second);
    secondThird.sub(third);

    return Vector3(
        (secondFirst.y * secondThird.z) - (secondFirst.z * secondThird.y),
        (secondFirst.z * secondThird.x) - (secondFirst.x * secondThird.z),
        (secondFirst.x * secondThird.y) - (secondFirst.y * secondThird.x));
  }

  double _scalarMultiplication(Vector3 first, Vector3 second) {
    return (first.x * second.x) + (first.y * second.y) + (first.z * second.z);
  }

  Vector3 _calcDefaultVertex(Vector3 vertex) {
    T = Matrix4.translationValues(_viewPortX, _viewPortY, zero);
    T.scale(_zoomFactor, -_zoomFactor);

    T.rotateX(_degreeToRadian(angleX));
    T.rotateY(_degreeToRadian(angleY));
    T.rotateZ(_degreeToRadian(angleZ));

    return T.transform3(vertex);
  }

  double _degreeToRadian(double degree) {
    return degree * (math.pi / 180.0);
  }

  void _drawFace(List<Vector3> verticesToDraw, List<int> face, Canvas canvas) {
    Paint paint = Paint();
    Vector3 normalizedLight = Vector3.copy(light).normalized();

    var normalVector = _normalVector3(verticesToDraw[face[0] - 1],
        verticesToDraw[face[1] - 1], verticesToDraw[face[2] - 1]);

    Vector3 jnv = Vector3.copy(normalVector).normalized();

    double koef = _scalarMultiplication(jnv, normalizedLight);

    if (koef < 0.0) {
      koef = 0.0;
    }

    Color newColor = const Color.fromARGB(255, 0, 0, 0);

    Path path = Path();

    newColor = newColor.withRed((color.red.toDouble() * koef).round());
    newColor = newColor.withGreen((color.green.toDouble() * koef).round());
    newColor = newColor.withBlue((color.blue.toDouble() * koef).round());
    paint.color = newColor;
    paint.style = PaintingStyle.fill;

    bool lastPoint = false;
    double firstVertexX, firstVertexY, secondVertexX, secondVertexY;

    for (int i = 0; i < face.length; i++) {
      if (i + 1 == face.length) {
        lastPoint = true;
      }

      if (lastPoint) {
        firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
        firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
        secondVertexX = verticesToDraw[face[0] - 1][0].toDouble();
        secondVertexY = verticesToDraw[face[0] - 1][1].toDouble();
      } else {
        firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
        firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
        secondVertexX = verticesToDraw[face[i + 1] - 1][0].toDouble();
        secondVertexY = verticesToDraw[face[i + 1] - 1][1].toDouble();
      }

      if (i == 0) {
        path.moveTo(firstVertexX, firstVertexY);
      }

      path.lineTo(secondVertexX, secondVertexY);
    }
    // var z = 0.0;
    // for (var x in face) {
    //   z += verticesToDraw[x - 1].z;
    // }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Map<String, dynamic> parsedFile = _parseObjString(object);
    vertices = parsedFile["vertices"];
    faces = parsedFile["faces"];

    List<Vector3> verticesToDraw = [];
    for (var vertex in vertices) {
      verticesToDraw.add(Vector3.copy(vertex));
    }

    for (int i = 0; i < verticesToDraw.length; i++) {
      verticesToDraw[i] = _calcDefaultVertex(verticesToDraw[i]);
    }

    final List<Map> avgOfZ = [];
    for (int i = 0; i < faces.length; i++) {
      List<int> face = faces[i];
      double z = 0.0;
      for (var x in face) {
        z += verticesToDraw[x - 1].z;
      }
      Map data = <String, dynamic>{
        "index": i,
        "z": z,
      };
      avgOfZ.add(data);
    }
    avgOfZ.sort((Map a, Map b) => a['z'].compareTo(b['z']));

    for (int i = 0; i < faces.length; i++) {
      List<int> face = faces[avgOfZ[i]["index"]];
      if (_shouldDrawFace(face) || true) {
        _drawFace(verticesToDraw, face, canvas);
      }
    }
  }

  @override
  bool shouldRepaint(_ObjectPainter old) =>
      old.object != object ||
      old.angleX != angleX ||
      old.angleY != angleY ||
      old.angleZ != angleZ ||
      old._zoomFactor != _zoomFactor;
}
