import 'package:flutter/material.dart';

class ListTestPage extends StatefulWidget {
  const ListTestPage({Key? key}) : super(key: key);

  @override
  State<ListTestPage> createState() => _ListTestPageState();
}

class _ListTestPageState extends State<ListTestPage> {
  final lists = <int>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Test'),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                lists.clear();
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Clear'),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                lists.add(lists.isEmpty ? 0 : lists.last + 1);
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
      body: lists.isEmpty
          ? const Center(
              child: Text('Click Add to add a new item'),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: lists.length,
              findChildIndexCallback: (key) {
                final index = lists.indexOf((key as ValueKey<int>).value);
                return index > -1 ? index : null;
              },
              itemBuilder: (context, i) {
                final value = lists[i];
                return Dismissible(
                  key: ValueKey<int>(value),
                  onDismissed: (direction) {
                    lists.remove(value);
                    setState(() {});
                  },
                  child: AnimatedItem(value),
                );
              },
            ),
    );
  }
}

class AnimatedItem extends StatefulWidget {
  const AnimatedItem(this.value, {Key? key}) : super(key: key);

  final int value;

  @override
  State<AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem> {
  double height = 0;
  Color color = Colors.white;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        height = 50;
        color = Colors.blue[(widget.value % 9 + 1) * 100]!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceOut,
      height: height,
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      alignment: Alignment.center,
      color: color,
      child: Text('${widget.value}'),
    );
  }
}
