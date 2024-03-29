import 'package:flutter/material.dart';

import 'cate.dart';
import 'home.dart';
import 'news.dart';
import 'user.dart';

class TabIndexPage extends StatefulWidget {
  const TabIndexPage({Key? key}) : super(key: key);

  @override
  State<TabIndexPage> createState() => _TabIndexPageState();
}

class _TabIndexPageState extends State<TabIndexPage> {
  int tabIndex = 0;
  PageController controller = PageController();
  @override
  void initState() {
    super.initState();
    controller.addListener(_onTabChange);
  }

  @override
  void dispose() {
    controller.removeListener(_onTabChange);
    super.dispose();
  }

  _onTabChange() {
    setState(() {
      tabIndex = controller.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Header'),
      ),
      body: PageView(
        controller: controller,
        children: const [
          HomePage(),
          CatePage(),
          NewsPage(),
          UserPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (int index) {
          if (index == tabIndex) return;
          controller.jumpToPage(index);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Cate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.padding),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
