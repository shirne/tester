import 'package:flutter/material.dart';
import 'other.dart';

import '../tools.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  void initState() {
    super.initState();
    print('page1 mounted');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('page1 subscribed');
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    print('page1 unmounted');
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print('page1 $mounted didPush');
  }

  @override
  void didPopNext() {
    print('page1 $mounted didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page 1'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const Other();
              }));
            },
            child: const Text('Other'),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
