import 'package:flutter/material.dart';

import 'main.dart';
import 'pages/anchor.dart';
import 'pages/anchor2.dart';
import 'pages/animate_bottom/index.dart';
import 'pages/animate_bottombar.dart';
import 'pages/animation.dart';
import 'pages/appbar_cover/index.dart';
import 'pages/clip_border.dart';
import 'pages/custom_border.dart';
import 'pages/custom_paint.dart';
import 'pages/custom_scroll.dart';
import 'pages/custom_scroll_text_field.dart';
import 'pages/drag_scroll.dart';
import 'pages/event.dart';
import 'pages/focus_to_screen.dart';
import 'pages/gradient_button_page.dart';
import 'pages/image_filter.dart';
import 'pages/isolate.dart';
import 'pages/lifecycle.dart';
import 'pages/list_page.dart';
import 'pages/lyric/index.dart';
import 'pages/magnifier.dart';
import 'pages/matrix4_test.dart';
import 'pages/matrix_skew.dart';
import 'pages/move.dart';
import 'pages/object_page.dart';
import 'pages/image_test.dart';
import 'pages/page_listen.dart';
import 'pages/screen_shot.dart';
import 'pages/scroll_behavior.dart';
import 'pages/scroll_page.dart';
import 'pages/scrollpanel.dart';
import 'pages/sharingan.dart';
import 'pages/sharingan2.dart';
import 'pages/tab_keep_alive/index.dart';
import 'pages/tab_scroll.dart';
import 'pages/tab_view.dart';
import 'pages/text_page.dart';
import 'pages/navpage/index.dart';
import 'pages/trigonal_prism.dart';
import 'pages/widget_test.dart';
import 'pages/date_picker.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Size? size;
  late bool isDark = Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('演示列表'),
        actions: [
          Switch(
              value: isDark,
              onChanged: (bool newValue) {
                isDark = newValue;
                setState(() {});
                final appState = context.findAncestorStateOfType<MyAppState>();
                if (appState != null) {
                  appState.setTheme(isDark ? ThemeMode.dark : ThemeMode.light);
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const NavigationPage())));
                },
                child: const Text('导航监控'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const LyricPage())));
                },
                child: const Text('歌词'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const AnimationTestPage())));
                },
                child: const Text('弹簧动画'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const CustomPaintPage())));
                },
                child: const Text('Custom paint'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const WidgetTest())));
                },
                child: const Text('Widgets'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const EventTestPage())));
                },
                child: const Text('Eventbus'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const LifecycleTest())));
                },
                child: const Text('Lifecycle'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const MagnifierPage())));
                },
                child: const Text('Magnifier'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const MatrixSkew())));
                },
                child: const Text('MatrixSkew'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const Matrix4Test())));
                },
                child: const Text('Matrix4'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ObjectPage())));
                },
                child: const Text('Object 3D'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ImageTest())));
                },
                child: const Text('Image load'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const IsolateTest())));
                },
                child: const Text('Isolate'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TextPage())));
                },
                child: const Text('文本空格Bug'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const AnimateBottomTest())));
                },
                child: const Text('Animate bottom'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const PageViewListen())));
                },
                child: const Text('Pageview切换监听'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TabIndexPage())));
                },
                child: const Text('Tab & KeepAlive'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const FilterTestPage())));
                },
                child: const Text('ImageFilter'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const CustomScrollTestPage())));
                },
                child: const Text('CustomScrollHeader'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) =>
                          const CustomScrollTextFieldPage())));
                },
                child: const Text('CustomScroll With TextField in Header'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ScrollPage())));
                },
                child: const Text('Just a scroll page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TabViewPage())));
                },
                child: const Text('Tab View Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ShotScreen())));
                },
                child: const Text('ShotScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const AnchorPage())));
                },
                child: const Text('TabBar with Anchor'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const Anchor2Page())));
                },
                child: const Text('TabBar at AppBar\'s bottom with Anchor'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TabScrollPage())));
                },
                child: const Text('Tab Scroll Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ScrollBehaviorPage())));
                },
                child: const Text('Scroll Behavior Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ListTestPage())));
                },
                child: const Text('List Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const FocusToScreenPage())));
                },
                child: const Text('FocusToScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const DatePickerPage())));
                },
                child: const Text('DatePicker'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const GradientButtonPage())));
                },
                child: const Text('Gradient Button'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const MoveTestPage())));
                },
                child: const Text('Move Button'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ScrollPanelPage())));
                },
                child: const Text('Bottom Drag Panel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const DragScrollPage())));
                },
                child: const Text('Drag Scroll Panel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const AppbarCoverPage())));
                },
                child: const Text('Appbar Cover'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const SharinganPage())));
                },
                child: const Text('Sharingan'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ScribbleEyePage())));
                },
                child: const Text('Sharingan'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const TrigonalPrismPage())));
                },
                child: const Text('TrigonalPrism'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ClipBorderPage())));
                },
                child: const Text('ClipBorder'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const CustomBorderPage())));
                },
                child: const Text('CustomBorder'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const AnimateBottomBarPage())));
                },
                child: const Text('Animated Bottombar'),
              ),
              Text(
                'Hello, World!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.blue, Colors.red],
                      ).createShader(
                        const Rect.fromLTWH(0, 0, 100, 100),
                      )
                    //..blendMode = BlendMode.dstIn,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
