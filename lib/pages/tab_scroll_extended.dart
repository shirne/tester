import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

class TabScrollExtendedPage extends StatefulWidget {
  const TabScrollExtendedPage({Key? key}) : super(key: key);

  @override
  State<TabScrollExtendedPage> createState() => _TabScrollExtendedPageState();
}

class _TabScrollExtendedPageState extends State<TabScrollExtendedPage> {
  final List<String> tabs = <String>['Tab 1', 'Tab 2'];

  double pinnedHeaderHeight = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 200.0,
                title: const Text('Books'),
                bottom: TabBar(
                  tabs: tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          onlyOneScrollInBody: true,
          body: const TabBarView(
            children: [
              TabScrollItem(name: 'tab-1'),
              TabScrollItem(name: 'tab-2'),
            ],
          ),
        ),
      ),
    );
  }
}

class TabScrollItem extends StatefulWidget {
  const TabScrollItem({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<TabScrollItem> createState() => _TabScrollItemState();
}

class _TabScrollItemState extends State<TabScrollItem>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        key: PageStorageKey<String>(widget.name),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
                childCount: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
