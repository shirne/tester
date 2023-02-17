import 'package:flutter/material.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  final scrollController = ScrollController();
  final offsetTop = ValueNotifier<double>(0);
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
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: kToolbarHeight * 2,
                elevation: 0,
                //backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  expandedTitleScale: 1,
                  background: SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: kToolbarHeight,
                        alignment: Alignment.center,
                        child: Text(
                          'Cover Title',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  title: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Stack(
                      children: [
                        Container(
                          height: kToolbarHeight,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: OverflowBox(
                            alignment: Alignment.topLeft,
                            maxHeight: MediaQuery.of(context).size.height,
                            child: ValueListenableBuilder<double>(
                              valueListenable: offsetTop,
                              builder: (context, value, child) {
                                return Container(
                                  transform: Matrix4.identity()
                                    ..translate(0.0, -value, 0.0),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.pink[600]!,
                                        Colors.pink[50]!,
                                        Colors.blue[50]!,
                                        Colors.blue[600]!,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: kToolbarHeight,
                          alignment: Alignment.center,
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
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('$index'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
