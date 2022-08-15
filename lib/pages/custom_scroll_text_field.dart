import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomScrollTextFieldPage extends StatefulWidget {
  const CustomScrollTextFieldPage({Key? key}) : super(key: key);

  @override
  State<CustomScrollTextFieldPage> createState() =>
      _CustomScrollTextFieldPageState();
}

class _CustomScrollTextFieldPageState extends State<CustomScrollTextFieldPage> {
  final textController = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.rootScope.requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: false,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: IgnoreShowOnScreenWidget(
                        //ignoreShowOnScreen: false,
                        child: TextField(
                          focusNode: focusNode,
                          controller: textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IconButton(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          print('btn clicked');
                        },
                        color: Colors.white,
                        icon: const Icon(Icons.heart_broken),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.teal[100 * (index % 9)],
                    child: Text('Grid Item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: Text('List Item $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IgnoreShowOnScreenWidget extends SingleChildRenderObjectWidget {
  const IgnoreShowOnScreenWidget({
    Key? key,
    Widget? child,
    this.ignoreShowOnScreen = true,
  }) : super(key: key, child: child);

  final bool ignoreShowOnScreen;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return IgnoreShowOnScreenRenderObject(
      ignoreShowOnScreen: ignoreShowOnScreen,
    );
  }
}

class IgnoreShowOnScreenRenderObject extends RenderProxyBox {
  IgnoreShowOnScreenRenderObject({
    RenderBox? child,
    this.ignoreShowOnScreen = true,
  });

  final bool ignoreShowOnScreen;

  @override
  void showOnScreen({
    RenderObject? descendant,
    Rect? rect,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
  }) {
    if (!ignoreShowOnScreen) {
      return super.showOnScreen(
        descendant: descendant,
        rect: rect,
        duration: duration,
        curve: curve,
      );
    }
  }
}
