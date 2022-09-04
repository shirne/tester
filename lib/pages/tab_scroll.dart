import 'package:flutter/material.dart';

class TabScrollPage extends StatefulWidget {
  const TabScrollPage({Key? key}) : super(key: key);

  @override
  State<TabScrollPage> createState() => _TabScrollPageState();
}

class _TabScrollPageState extends State<TabScrollPage> {
  final List<String> tabs = <String>['Tab 1', 'Tab 2'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                // This widget takes the overlapping behavior of the SliverAppBar,
                // and redirects it to the SliverOverlapInjector below. If it is
                // missing, then it is possible for the nested "inner" scroll view
                // below to end up under the SliverAppBar even when the inner
                // scroll view thinks it has not been scrolled.
                // This is not necessary if the "headerSliverBuilder" only builds
                // widgets that do not overlap the next sliver.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title:
                      const Text('Books'), // This is the title in the app bar.
                  pinned: true,
                  expandedHeight: 150.0,
                  // The "forceElevated" property causes the SliverAppBar to show
                  // a shadow. The "innerBoxIsScrolled" parameter is true when the
                  // inner scroll view is scrolled beyond its "zero" point, i.e.
                  // when it appears to be scrolled below the SliverAppBar.
                  // Without this, there are cases where the shadow would appear
                  // or not appear inappropriately, because the SliverAppBar is
                  // not actually aware of the precise position of the inner
                  // scroll views.
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: [
                TabScrollItem(name: 'tab-1'),
                TabScrollItem(name: 'tab-2'),
              ]),
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
  TabController? tabController;
  bool isActive = false;
  @override
  void initState() {
    super.initState();
    isActive = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (tabController != null) {
      tabController?.removeListener(_onTabChange);
    }
    tabController = DefaultTabController.of(context);
    tabController?.addListener(_onTabChange);
  }

  @override
  void dispose() {
    tabController?.removeListener(_onTabChange);
    super.dispose();
  }

  _onTabChange() {
    if (tabController?.indexIsChanging ?? true) {
      return;
    }
    final render = context.findRenderObject() as RenderBox?;
    final offset = render?.localToGlobal(Offset.zero);
    setState(() {
      isActive = offset != null && !offset.dx.isNaN;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        physics: isActive ? null : const NeverScrollableScrollPhysics(),
        controller: isActive ? null : ScrollController(),
        // The "controller" and "primary" members should be left
        // unset, so that the NestedScrollView can control this
        // inner scroll view.
        // If the "controller" property is set, then this scroll
        // view will not be associated with the NestedScrollView.
        // The PageStorageKey should be unique to this ScrollView;
        // it allows the list to remember its scroll position when
        // the tab view is not on the screen.
        key: PageStorageKey<String>(widget.name),
        slivers: <Widget>[
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            // In this example, the inner scroll view has
            // fixed-height list items, hence the use of
            // SliverFixedExtentList. However, one could use any
            // sliver widget here, e.g. SliverList or SliverGrid.
            sliver: SliverFixedExtentList(
              // The items in this example are fixed to 48 pixels
              // high. This matches the Material Design spec for
              // ListTile widgets.
              itemExtent: 48.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // This builder is called for each child.
                  // In this example, we just number each list item.
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
                // The childCount of the SliverChildBuilderDelegate
                // specifies how many children this inner list
                // has. In this example, each tab has a list of
                // exactly 30 items, but this is arbitrary.
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
