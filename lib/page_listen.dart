import 'package:flutter/material.dart';

class PageViewListen extends StatefulWidget {
  const PageViewListen({Key? key}) : super(key: key);

  @override
  State<PageViewListen> createState() => _PageViewListenState();
}

class _PageViewListenState extends State<PageViewListen> {
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pageview')),
      body: PageView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ItemBuilder(index, controller);
          }),
    );
  }
}

class ItemBuilder extends StatefulWidget {
  final int index;
  final PageController controller;
  const ItemBuilder(this.index, this.controller, {Key? key}) : super(key: key);

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  bool isShown = false;
  @override
  void initState() {
    super.initState();
    print('page ${widget.index} inited');
    widget.controller.addListener(_onChange);
    Future.delayed(const Duration(milliseconds: 1)).then(
      (value) => _onChange(),
    );
  }

  @override
  void dispose() {
    print('page ${widget.index} disposed');
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    final newIsShown = widget.index == widget.controller.page?.round();
    if (isShown == newIsShown) return;
    setState(() {
      isShown = newIsShown;
      print('page ${widget.index} ${isShown ? '播放' : '暂停'}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${widget.index} ${isShown ? '播放' : '暂停'}'),
    );
  }
}
