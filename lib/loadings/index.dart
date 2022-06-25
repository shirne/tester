import 'package:flutter/material.dart';

import 'rect_progress_indicator.dart';

class LoadingIndex extends StatefulWidget {
  const LoadingIndex({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingIndexState();
}

class _LoadingIndexState extends State<LoadingIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Center(
              child: CircularProgressIndicator(),
            ),
            Center(
              child: LinearProgressIndicator(),
            ),
            Center(
              child: RefreshProgressIndicator(),
            ),
            Center(
              child: RectProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
