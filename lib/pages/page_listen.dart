import 'package:flutter/material.dart';

class PageViewListen extends StatefulWidget {
  const PageViewListen({Key? key}) : super(key: key);

  @override
  State<PageViewListen> createState() => _PageViewListenState();
}

class _PageViewListenState extends State<PageViewListen> {
  PageController controller = PageController(initialPage: 4);
  int pageCount = 5;
  bool canScroll = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pageview'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                pageCount++;
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        physics: canScroll
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: List.generate(
          pageCount,
          (index) => ItemBuilder(
            index,
            controller,
            onInnerHover: (isHover) {
              if (isHover) {
                setState(() {
                  canScroll = false;
                });
              } else {
                setState(() {
                  canScroll = true;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class ItemBuilder extends StatefulWidget {
  const ItemBuilder(this.index, this.controller, {this.onInnerHover, Key? key})
      : super(key: key);

  final int index;
  final PageController controller;
  final void Function(bool)? onInnerHover;

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  bool isShown = false;
  final hoverIn = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    print('page ${widget.index} inited');
    widget.controller.addListener(_onChange);
    Future.delayed(const Duration(milliseconds: 1)).then(
      (value) => _onChange(),
    );
    hoverIn.addListener(_onHoverChanged);
  }

  @override
  void dispose() {
    print('page ${widget.index} disposed');
    widget.controller.removeListener(_onChange);
    hoverIn.removeListener(_onHoverChanged);
    super.dispose();
  }

  void _onHoverChanged() {
    print('current hover ${hoverIn.value}');
    widget.onInnerHover?.call(hoverIn.value);
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
      child: Builder(builder: (context) {
        return Listener(
          onPointerHover: (event) {
            //print('${event.position} ${event.delta}');
            var render = context.findRenderObject() as RenderBox?;
            if (render != null) {
              var rect = render.localToGlobal(Offset.zero) & render.size;
              if (rect.contains(event.position + event.delta)) {
                hoverIn.value = true;
              } else {
                hoverIn.value = false;
              }
            }
          },
          onPointerSignal: (event) {
            print(event);
          },
          child: Container(
            color: Colors.blueAccent,
            alignment: Alignment.center,
            width: 100,
            height: 80,
            child: Text('${widget.index} ${isShown ? '播放' : '暂停'}'),
          ),
        );
      }),
    );
  }
}
