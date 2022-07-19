import 'package:flutter/material.dart';

import 'other.dart';
import '../tools.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  void initState() {
    super.initState();

    print('page3 mounted');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('page3 subscribed');
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    print('page3 unmounted');
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print('page3 $mounted didPush');
  }

  @override
  void didPopNext() {
    print('page3 $mounted didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page 3'),
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
