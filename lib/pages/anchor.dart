import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnchorPage extends StatefulWidget {
  const AnchorPage({Key? key}) : super(key: key);

  @override
  State<AnchorPage> createState() => _AnchorPageState();
}

class _AnchorPageState extends State<AnchorPage>
    with SingleTickerProviderStateMixin {
  final keys = <GlobalKey>[
    GlobalKey(debugLabel: 'tab1'),
    GlobalKey(debugLabel: 'tab2'),
    GlobalKey(debugLabel: 'tab3'),
  ];
  late final tabController = TabController(length: 3, vsync: this);
  final scrollController = ScrollController();

  static const expandedHeight = 240.0;

  double offset = 50;
  double collapseStep = 0;

  bool isTabClicked = false;

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
      isTabClicked = true;
      scrollController.position
          .ensureVisible(keyRenderObject,
              duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
          .then((value) {
        isTabClicked = false;
      });
    }
  }

  void _onScroll() {
    double newStep = 0;
    if (scrollController.offset > expandedHeight - kToolbarHeight * 2) {
      newStep = scrollController.offset > expandedHeight - kToolbarHeight
          ? 1
          : (scrollController.offset - (expandedHeight - kToolbarHeight * 2)) /
              kToolbarHeight;
    }
    setState(() {
      collapseStep = newStep;
    });
    if (isTabClicked) return;
    int i = 0;
    for (; i < keys.length; i++) {
      final keyRenderObject = keys[i]
          .currentContext
          ?.findAncestorRenderObjectOfType<RenderSliverToBoxAdapter>();
      if (keyRenderObject != null) {
        final offsetY = (keyRenderObject.parentData as SliverPhysicalParentData)
            .paintOffset
            .dy;
        if (offsetY > kToolbarHeight + offset) {
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

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            collapsedHeight: kToolbarHeight,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                height: kToolbarHeight,
                alignment: Alignment.center,
                child: tabBar,
              ),
              expandedTitleScale: 1,
              titlePadding: EdgeInsets.only(left: 50 * collapseStep),
              background: const FittedBox(
                child: FlutterLogo(),
              ),
            ),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
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
