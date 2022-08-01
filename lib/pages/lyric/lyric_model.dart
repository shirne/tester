import 'dart:convert';

import '../../tools.dart';

class LyricModel {
  final String? title;
  final String? album;
  final String? artist;
  final String? editor;
  final int offset;
  final Map<int, String> lyrics;

  String? get ti => title;
  String? get ar => artist;
  String? get al => album;
  String? get by => editor;

  List<MapEntry<int, String>> get lyricList =>
      lyrics.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  const LyricModel({
    required this.lyrics,
    this.title,
    this.album,
    this.artist,
    this.editor,
    this.offset = 0,
  });

  factory LyricModel.fromText(String text) {
    final lyrics = <int, String>{};
    final lines = text.split(RegExp('[\r\n]', multiLine: true));
    final sTags = <LyricTag>[];
    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('[:]')) continue;
      final tags = <LyricTag>[];
      while (line.startsWith('[') && line.contains(']')) {
        int endTag = line.indexOf(']');
        String tagStr = line.substring(1, endTag);
        final tag = LyricTag.fromString(tagStr);
        if (tag.isTime) {
          tags.add(tag);
        } else {
          sTags.add(tag);
        }
        line = line.substring(endTag + 1);
      }
      for (final tag in tags) {
        lyrics[tag.timeValue] = line;
      }
    }
    return LyricModel(
      lyrics: lyrics,
      title: sTags
          .firstWhereOrNull((tag) => tag.label == 'ti' || tag.label == 'title')
          ?.value,
      album: sTags
          .firstWhereOrNull((tag) => tag.label == 'al' || tag.label == 'album')
          ?.value,
      artist: sTags
          .firstWhereOrNull((tag) => tag.label == 'ar' || tag.label == 'artist')
          ?.value,
      editor: sTags
          .firstWhereOrNull((tag) => tag.label == 'by' || tag.label == 'editor')
          ?.value,
      offset: int.tryParse(
              sTags.firstWhereOrNull((tag) => tag.label == 'offset')?.value ??
                  '0') ??
          0,
    );
  }

  String toLyric({bool mergeTime = false}) {
    final stringBuffer = StringBuffer();
    if (title != null) {
      stringBuffer.writeln("[ti:$title]");
    }
    if (album != null) {
      stringBuffer.writeln("[ti:$album]");
    }
    if (artist != null) {
      stringBuffer.writeln("[ar:$artist]");
    }
    if (editor != null) {
      stringBuffer.writeln("[by:$editor]");
    }
    if (offset != 0) {
      stringBuffer.writeln("[offset:$offset]");
    }
    final times = lyrics.keys.toList();
    times.sort((a, b) => a.compareTo(b));
    if (mergeTime) {
      final lyricList = lyrics.entries.toList();
      final usedTimes = <int>{};
      for (int time in times) {
        if (usedTimes.contains(time)) continue;
        final otherTimes =
            lyricList.where((lyric) => lyric.value == lyrics[time]).toList();
        otherTimes.sort((a, b) => a.key.compareTo(b.key));
        for (MapEntry<int, String> otime in otherTimes) {
          usedTimes.add(otime.key);
          stringBuffer.write("[${formatTime(otime.key)}]");
        }
        stringBuffer.writeln(lyrics[time]);
      }
    } else {
      for (int time in times) {
        stringBuffer.writeln("[${formatTime(time)}]${lyrics[time]}");
      }
    }
    return stringBuffer.toString();
  }

  String formatTime(int time) {
    int ms = time % 1000;
    time ~/= 1000;
    int s = time % 60;
    int m = time ~/ 60;
    return "[$m:$s.$ms]";
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'album': album,
        'artist': artist,
        'editor': editor,
        'offset': offset,
        'lyrics': lyrics,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class LyricTag {
  static final regIsTime = RegExp(r'^[\d]{1,}$');
  final bool isTime;
  final String label;
  final String value;

  int get timeValue => isTime ? parseTime(value) : 0;

  const LyricTag({this.label = '', required this.value, this.isTime = false});

  factory LyricTag.fromString(String tag) {
    String label;
    String value;
    int dIndex = tag.indexOf(':');
    if (tag.indexOf(':') > 0) {
      label = tag.substring(0, dIndex);
      value = tag.substring(dIndex + 1);
      if (!regIsTime.hasMatch(label)) {
        return LyricTag(
          label: label.toLowerCase(),
          value: value,
        );
      }
      return LyricTag(value: tag, isTime: true);
    }
    return LyricTag(value: tag);
  }

  int parseTime(String time) {
    final parts = time.split('.');
    final sParts = parts[0].split(':').reversed;
    int result = 0;
    int power = 1;
    for (String p in sParts) {
      result += (int.tryParse(p) ?? 0) * power * 1000;
      if (power < 3600) {
        power *= 60;
      } else {
        // 最高支持小时
        break;
      }
    }
    if (parts.length > 1) {
      result += ((double.tryParse("0.parts[1]") ?? 0) * 1000).toInt();
    }
    return result;
  }
}
