import 'dart:convert';
import 'dart:math';

class ShopDiscount {
  final List<String> bookList;
  final double price;
  final random = Random();

  ShopDiscount(this.bookList, this.price);

  List<String> randomBooks(int count) {
    return List.generate(
        count, (index) => bookList[random.nextInt(bookList.length)]);
  }

  List<Result> findGroups(List<String> books) {
    /// 统计书的数量
    Map<String, int> bookCounts = {};
    for (String book in books) {
      if (bookCounts.containsKey(book)) {
        bookCounts[book] = bookCounts[book]! + 1;
      } else {
        bookCounts[book] = 1;
      }
    }

    /// 最大数量
    final max = bookCounts.values.reduce((c1, c2) => c1 > c2 ? c1 : c2);
    final results = <Result>[];

    /// 按数量从多到少排序
    final releaseBooks = bookCounts.entries.toList();
    releaseBooks.sort((a, b) => b.value.compareTo(a.value));
    bool isFirst = true;
    for (final bookEntry in releaseBooks) {
      /// 数量最多的书直接加
      if (max == bookEntry.value) {
        if (results.isEmpty) {
          results.add(Result([]));
          for (int i = 0; i < bookEntry.value; i++) {
            results[0].groups.add([bookEntry.key]);
          }
        } else {
          for (int i = 0; i < bookEntry.value; i++) {
            results[0].groups[i].add(bookEntry.key);
          }
        }

        /// 数量次多的第一种书，按顺序加
      } else if (isFirst) {
        for (int i = 0; i < bookEntry.value; i++) {
          results[0].groups[i].add(bookEntry.key);
        }
        isFirst = false;

        /// 剩下的书
      } else {
        final lastResults = results.toList();
        results.clear();
        for (int i = 0; i < bookEntry.value; i++) {
          for (Result r in lastResults) {
            bool isAdded = false;
            for (int i = 0; i < r.groups.length; i++) {
              if (r.groups[i].contains(bookEntry.key)) continue;
              isAdded = true;
              final newR = r.copy();
              newR.groups[i].add(bookEntry.key);
              newR.sort();

              /// 去重
              final groupKey = newR.groupKey;
              if (results.where((e) => e.groupKey == groupKey).isEmpty) {
                results.add(newR);
              }
            }
            assert(isAdded, '$results ${bookEntry.key} 统计异常');
          }
        }
      }
    }

    return results;
  }

  List<Result> findGroups2(List<String> books) {
    final results = <Result>[];
    for (String book in books) {
      if (results.isEmpty) {
        results.add(Result([
          [book]
        ]));
      } else {
        final lastResults = results.toList();
        results.clear();
        for (Result r in lastResults) {
          bool isAdded = false;
          for (int i = 0; i < r.groups.length; i++) {
            if (r.groups[i].contains(book)) continue;
            isAdded = true;
            final newR = r.copy();
            newR.groups[i].add(book);
            newR.sort();
            results.add(newR);
          }
          if (!isAdded || !r.containsSingle(book)) {
            final newR = r.copy();
            newR.groups.add([book]);
            newR.sort();
            results.add(newR);
          }
        }
      }
    }
    return results;
  }
}

class Result {
  final List<List<String>> groups;

  String get groupKey => groups.map<int>((e) => e.length).join(',');

  /// 总折扣值
  double get total =>
      groups.map<double>(sumTotal).reduce((value, element) => value + element);

  double sumTotal(List<String> group) {
    double discount = 1;
    switch (group.length) {
      case 5:
        discount = 0.75;
        break;
      case 4:
        discount = 0.80;
        break;
      case 3:
        discount = 0.90;
        break;
      case 2:
        discount = 0.95;
        break;
      default:
    }
    return group.length * discount;
  }

  Result(this.groups);

  void sort() {
    // for (List<String> items in groups) {
    //   items.sort((g1, g2) => g1.compareTo(g2));
    // }
    groups.sort((g1, g2) => g2.length.compareTo(g1.length));
  }

  bool containsSingle(String book) {
    return groups
        .where((element) => element.length == 1 && element[0] != book)
        .isNotEmpty;
  }

  Result copy() {
    return Result(
        List.generate(groups.length, (index) => groups[index].toList()));
  }

  Map<String, dynamic> toJson() => {
        'items': groups,
        'total': total.toStringAsFixed(2),
      };

  @override
  String toString() => jsonEncode(toJson());

  @override
  int get hashCode => groups
      .map<int>(
          (e) => e.map<int>((e) => e.hashCode).reduce((b1, b2) => b1 ^ b2))
      .reduce((value, element) => value ^ element);

  @override
  bool operator ==(Object other) {
    return this == other;
  }
}
