import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Anchor2Page extends StatefulWidget {
  const Anchor2Page({Key? key}) : super(key: key);

  @override
  State<Anchor2Page> createState() => _Anchor2PageState();
}

class _Anchor2PageState extends State<Anchor2Page>
    with SingleTickerProviderStateMixin {
  final keys = <GlobalKey>[
    GlobalKey(debugLabel: 'tab1'),
    GlobalKey(debugLabel: 'tab2'),
    GlobalKey(debugLabel: 'tab3'),
  ];
  late final tabController = TabController(length: 3, vsync: this);
  final scrollController = ScrollController();

  static const expandedHeight = 240.0;

  double? tabBarHeight;
  double offset = 50;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onTabChange(i) {
    final keyRenderObject = keys[i]
        .currentContext
        ?.findAncestorRenderObjectOfType<RenderSliverToBoxAdapter>();
    if (keyRenderObject != null) {
      // 点击的时候不让滚动影响tab
      scrollController.removeListener(_onScroll);
      scrollController.position
          .ensureVisible(keyRenderObject,
              duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
          .then((value) => scrollController.addListener(_onScroll));
    }
  }

  void _onScroll() {
    int i = 0;
    for (; i < keys.length; i++) {
      final keyRenderObject = keys[i]
          .currentContext
          ?.findAncestorRenderObjectOfType<RenderSliverToBoxAdapter>();
      if (keyRenderObject != null) {
        final offsetY = (keyRenderObject.parentData as SliverPhysicalParentData)
            .paintOffset
            .dy;
        if (offsetY > kToolbarHeight + (tabBarHeight ?? 0) + offset) {
          break;
        }
      }
    }
    final newIndex = i == 0 ? 0 : i - 1;
    if (newIndex != tabController.index) {
      tabController.animateTo(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      controller: tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade300,
      indicatorColor: Colors.white,
      onTap: _onTabChange,
      tabs: const [
        Tab(child: Text('Tab1')),
        Tab(child: Text('Tab2')),
        Tab(child: Text('Tab3')),
      ],
    );
    tabBarHeight = tabBar.preferredSize.height;
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            collapsedHeight: kToolbarHeight,
            title: Text('test'),
            flexibleSpace: const FlexibleSpaceBar(
              //title: Text('test'),
              expandedTitleScale: 1,
              background: FittedBox(
                child: FlutterLogo(),
              ),
            ),
            bottom: tabBar,
          ),
          SliverToBoxAdapter(
            child: Text(
              'List 1',
              key: keys[0],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Item(index),
                childCount: 8),
          ),
          SliverToBoxAdapter(
            child: Text(
              'List 2',
              key: keys[1],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Item(index),
              childCount: 9,
            ),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          ),
          SliverToBoxAdapter(
            child: Text(
              'List 3',
              key: keys[2],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Item(index),
                childCount: 8),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.primaries[index % 18]),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('text $index')),
    );
  }
}
