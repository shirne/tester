import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

import '../../widgets/gallery_view.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _isImage = false;
  bool _isLoading = false;
  int _itemCount = 200;
  List<String> avatars = [];
  late ImageProvider transImage;

  @override
  initState() {
    super.initState();
    transImage = MemoryImage(Uint8List.fromList([
      71, 73, 70, 56, 55, 97, 1, 0, 1, 0, 240, 0, 0, 0, 0, 0, 201, 69, 38, //
      33, 249, 4, 1, 0, 0, 1, 0, 44, 0, 0, 0, 00, 1, 0, 1, 0, 0, 2, 2, 76, 1, 0,
      59,
    ]));
  }

  _loadAvatar() async {
    if (avatars.isEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        final result = await Dio().get<Map<String, dynamic>>(
            "https://randomuser.me/api/?results=$_itemCount");
        List<dynamic> list = result.data!['results'];
        list.forEach((element) {
          avatars.add(element['picture']['large']);
        });
      } catch (_) {
        print(_);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  _changeMode() async {
    if (!_isImage) {
      await _loadAvatar();
      if (avatars.isEmpty) {
        MyDialog.of(context).toast('获取图片失败');
        return;
      }
    }
    setState(() {
      _isImage = !_isImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: Container(
        child: GalleryView.builder(
          itemCount: _itemCount,
          itemBuilder: (_, index) => _isImage
              ? FadeInImage(
                  placeholder: transImage,
                  image: NetworkImage(avatars[index % avatars.length]),
                  fit: BoxFit.fill,
                )
              : Container(
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isLoading) return;
          _changeMode();
        },
        tooltip: "切换展示模式",
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(_isImage ? Icons.apps_sharp : Icons.image),
      ),
    );
  }
}
