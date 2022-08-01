import 'package:flutter/material.dart';

import 'other.dart';
import '../../tools.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  void initState() {
    super.initState();
    print('page2 mounted');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('page2 subscribed');
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    print('page2 unmounted');
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print('page2 $mounted didPush');
  }

  @override
  void didPopNext() {
    print('page2 $mounted didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page 2'),
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
