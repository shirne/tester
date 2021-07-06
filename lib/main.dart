import 'package:flutter/material.dart';

import 'widgets/gallery_view.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Container(
          child: GalleryView.builder(
            itemCount: 200,
            itemBuilder: (_, index) => Container(
              color: Colors.primaries[index % Colors.primaries.length],
            ),
          ),
        ),
      ),
    );
  }
}
