import 'package:flutter/material.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage>
    with SingleTickerProviderStateMixin {
  final List<double> tabOffset = [0, 0, 0];
  late final TabController tabController =
      TabController(length: 3, vsync: this);
  @override
  void initState() {
    super.initState();
    tabController.addListener(() {
      print(tabController.index);
    });
    tabController.animation!.addListener(() {
      if (!tabController.indexIsChanging) {
        tabOffset[tabController.index] = tabController.offset;
        tabOffset[tabController.index + (tabController.offset > 0 ? 1 : -1)] =
            1 - tabController.offset.abs();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          tabs: <Tab>[
            Tab(text: 'Zeroth ${tabOffset[0]}'),
            Tab(text: 'First ${tabOffset[1]}'),
            Tab(text: 'Second ${tabOffset[2]}'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Center(
            child: Text(
              'Zeroth Tab',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Center(
            child: Text(
              'First Tab',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Center(
            child: Text(
              'Second Tab',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          )
        ],
      ),
    );
  }
}
