import 'package:flutter/material.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

extension ListNull<E> on List<E> {
  /// 获取首个元素，为空返回null
  E? get firstOrNull => isEmpty ? null : first;

  /// 获取首个匹配到的元素，匹配不到返回null
  E? firstWhereOrNull(bool Function(E) test) {
    for (E item in this) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }

  /// 获取可匹配的唯一元素，匹配不到或不唯一返回null
  E? singleOrNull(bool Function(E) test) {
    E? matched;
    for (E item in this) {
      if (test(item)) {
        if (matched != null) return null;
        matched = item;
      }
    }
    return matched;
  }
}
