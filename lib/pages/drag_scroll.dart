import 'package:flutter/material.dart';

class DragScrollPage extends StatefulWidget {
  const DragScrollPage({super.key});

  @override
  State<DragScrollPage> createState() => _DragScrollPageState();
}

class _DragScrollPageState extends State<DragScrollPage> {
  final dragController = ScrollController();
  final controller = ScrollController();

  BuildContext? fillContext;
  bool isFixed = false;

  final heightListener = ValueNotifier<double>(100);

  double maxHeight = 1;

  @override
  void initState() {
    super.initState();
    dragController.addListener(_dragScrolled);
    controller.addListener(_scrolled);
  }

  void _dragScrolled() {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceOut,
    );
  }

  void _scrolled() {
    if (fillContext?.findRenderObject() == null) return;

    print((fillContext!.findRenderObject()! as RenderBox).size);
    final height = fillContext?.size?.height ?? 0;
    if (height > 100 && height < maxHeight) {
      heightListener.value = height;
    }
    if ((!isFixed && height >= maxHeight) || (isFixed && height < maxHeight)) {
      setState(() {
        isFixed = height >= maxHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    maxHeight = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          const SliverAppBar(
            title: Text('title'),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Text('$index');
              },
              childCount: 50,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true, //!isFixed,
            child: ConstrainedBox(
              constraints: isFixed
                  ? BoxConstraints.loose(Size.fromHeight(maxHeight))
                  : BoxConstraints.loose(const Size.fromHeight(100)),
              child: RamainingFill((context) {
                fillContext = context;
              }),
            ),
          ),
        ],
      ),
      bottomSheet: ValueListenableBuilder<double>(
        valueListenable: heightListener,
        builder: (context, value, child) {
          return Container(
            height: value,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              controller: dragController,
              itemBuilder: (context, index) {
                return Text('popup $index');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RamainingFill extends StatefulWidget {
  const RamainingFill(this.onBuild, {super.key});
  final Function(BuildContext?)? onBuild;
  @override
  State<RamainingFill> createState() => _RamainingFillState();
}

class _RamainingFillState extends State<RamainingFill> {
  @override
  void initState() {
    print('initState');
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    widget.onBuild?.call(null);
    super.dispose();
  }

  @override
  void activate() {
    print('activate');
    widget.onBuild?.call(context);
    super.activate();
  }

  @override
  void reassemble() {
    print('reassemble');
    super.reassemble();
  }

  @override
  void deactivate() {
    print('deactivate');
    widget.onBuild?.call(null);
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    widget.onBuild?.call(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    widget.onBuild?.call(context);
    return Container(
      color: Colors.amber[50],
      alignment: Alignment.center,
      child: Text('A'),
    );
  }
}
