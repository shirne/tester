import 'package:flutter/material.dart';

class CatePage extends StatefulWidget {
  const CatePage({Key? key}) : super(key: key);

  @override
  State<CatePage> createState() => _CatePageState();
}

class _CatePageState extends State<CatePage> {
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    print('cate init');
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (!mounted) return;
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    print('cate dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Cate page no keep alive ${isLoaded ? '已加载' : '加载中'}'),
    );
  }
}
