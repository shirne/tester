import 'package:flutest/pages/appbar_cover/column.dart';
import 'package:flutest/pages/appbar_cover/cover.dart';
import 'package:flutter/material.dart';

class AppbarCoverPage extends StatefulWidget {
  const AppbarCoverPage({super.key});

  @override
  State<AppbarCoverPage> createState() => _AppbarCoverPageState();
}

class _AppbarCoverPageState extends State<AppbarCoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ColumnPage();
                    },
                  ));
                },
                child: Text('Column')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return CoverPage();
                    },
                  ));
                },
                child: Text('Cover')),
          ],
        ),
      ),
    );
  }
}
