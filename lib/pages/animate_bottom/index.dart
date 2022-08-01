import 'package:flutter/material.dart';

class AnimateBottomTest extends StatefulWidget {
  const AnimateBottomTest({Key? key}) : super(key: key);

  @override
  State<AnimateBottomTest> createState() => _AnimateBottomTestState();
}

class _AnimateBottomTestState extends State<AnimateBottomTest> {
  Offset bottomOffset = const Offset(0, 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      setState(() {
        bottomOffset = Offset.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('aaa')),
      body: ListView.builder(
          itemBuilder: (context, index) => Center(child: Text('$index'))),
      bottomNavigationBar: AnimatedSlide(
        offset: bottomOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Opacity(
          opacity: 1 - bottomOffset.dy,
          child: Material(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            elevation: 8,
            color: colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment,
                    color: colorScheme.onSurface,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child:
                        Text('0', style: Theme.of(context).textTheme.caption),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: colorScheme.onSurface,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child:
                        Text('分享', style: Theme.of(context).textTheme.caption),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.heart_broken,
                    color: colorScheme.onSurface,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child:
                        Text('收藏', style: Theme.of(context).textTheme.caption),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.ac_unit_sharp,
                    color: colorScheme.onSurface,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      '0',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
