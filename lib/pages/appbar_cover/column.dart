import 'package:flutter/material.dart';

class ColumnPage extends StatefulWidget {
  const ColumnPage({super.key});

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  final offsetTop = ValueNotifier<double>(0);
  final scrollController = ScrollController();
  double topOffset = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    topOffset = MediaQuery.of(context).padding.top + kToolbarHeight;
    offsetTop.value = topOffset;
  }

  void onScroll() {
    double offset = scrollController.offset;
    if (offset < 0) offset = 0;
    if (offset > kToolbarHeight) offset = kToolbarHeight;
    offsetTop.value = topOffset - offset;
    print('${scrollController.offset} $offset  ${offsetTop.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink[600]!,
                  Colors.pink[50]!,
                  Colors.blue[50]!,
                  Colors.blue[600]!
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: offsetTop,
                  builder: (context, value, child) {
                    return Container(
                      height: value,
                      alignment: Alignment.topCenter,
                      child: child,
                    );
                  },
                  child: AppBar(
                    elevation: 0,
                    title: const Text('app Bar'),
                  ),
                ),
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Center(
                          child: Text('aaa'),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('bbb'),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('ccc'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('$index'),
                    );
                  },
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
