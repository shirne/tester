import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_plugin/my_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String path = 'Unfetched';
  String subPath = 'Unfetched';
  int size = 0;
  final _myPlugin = MyPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _myPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> getPath() async {
    String path;
    try {
      path = await _myPlugin.getAssetsPath('logo.jpg') ?? 'Fetch failed';
    } on PlatformException {
      path = 'Fetch failed.';
    }

    if (!mounted) return;

    setState(() {
      this.path = path;
    });
  }

  Future<void> getSubPath() async {
    String subPath;
    try {
      subPath =
          await _myPlugin.getAssetsSubPath('images/logo.jpg') ?? 'Fetch failed';
    } on PlatformException {
      subPath = 'Fetch failed.';
    }

    if (!mounted) return;

    setState(() {
      this.subPath = subPath;
    });
  }

  Future<void> getSize() async {
    int size;
    try {
      size = await _myPlugin.getAssetsSize('assets/images/logo.jpg') ?? 0;
    } on PlatformException {
      size = 0;
    }

    if (!mounted) return;

    setState(() {
      this.size = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Text(path),
            ElevatedButton(
              onPressed: getPath,
              child: Text('fetchPath'),
            ),
            Text(subPath),
            ElevatedButton(
              onPressed: getSubPath,
              child: Text('fetchPath'),
            ),
            Text('$size'),
            ElevatedButton(
              onPressed: getSize,
              child: Text('fetchPath'),
            ),
          ],
        ),
      ),
    );
  }
}
