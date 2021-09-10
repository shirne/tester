import 'package:animatedalign1/text_form.dart';
import 'package:flutter/material.dart';
import 'gallery.dart';
import 'custom_paint.dart';
import 'action_test.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: TextForm(),
    );
  }
}
