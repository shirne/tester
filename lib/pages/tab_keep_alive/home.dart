import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    print('Home init');
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (!mounted) return;
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    print('Home dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Index page has keep alive ${isLoaded ? '已加载' : '加载中'}'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
