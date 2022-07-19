import 'package:flutter/material.dart';

import 'lyric_model.dart';

class LyricPage extends StatefulWidget {
  const LyricPage({Key? key}) : super(key: key);

  @override
  State<LyricPage> createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> {
  final LyricModel lyricModel = LyricModel.fromText('''
[ti:依赖]
[ar:蔡健雅]
[al:MY SPACE]
[by:Chapter Chang]
[offset:0]
[00:00.50]蔡健雅 - 依赖
[00:07.94]词、曲：蔡健雅、陶晶莹
[00:11.60]关了灯把房间整理好
[00:15.48]凌晨三点还是睡不著
[00:19.64]你应该是不在　所以把电话挂掉
[00:30.39]在黑暗手表跟着心跳
[00:34.57]怎么慢它停也停不了
[00:39.70]我应该只是心情不好
[00:45.00]那又怎样
[00:48.50]但本来是这样
[01:21.36]朋友们对我的安慰
[01:25.20]都是同样的一个话题
[01:29.73]我一定要变得更坚强
[01:34.68]说很简单
[00:38.50]但是做却很难
[00:53.00][01:43.88][02:11.23]虽然无所谓写在脸上
[00:58.21][01:48.44][02:15.79]我还是舍不得让你离开
[01:02.97][01:53.50][02:20.60]虽然闭着眼假装听不到
[01:07.84][01:58.23][02:25.11][02:33.15]你对爱　已不再　想依赖
''');
  late final lyrics = lyricModel.lyricList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lyric')),
      body: ListView(
        children: List.generate(
            lyrics.length,
            (index) => Center(
                  child: Text(lyrics[index].value),
                )),
      ),
    );
  }
}
