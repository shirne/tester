import 'dart:ui';

extension NullableList<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : this[0];

  E? firstWhereOrNull(bool Function(E) test) {
    for (E item in this) {
      if (test.call(item)) {
        return item;
      }
    }
    return null;
  }

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

extension DateTimeUtil on DateTime {
  DateTime startOfDay() {
    return DateTime(year, month, day, 0, 0, 0, 0, 0);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999, 0);
  }

  /// `offset`=-1时以周日起始
  DateTime startOfWeek([int offset = 0]) {
    return DateTime(year, month, day + 1 + offset - weekday, 0, 0, 0, 0, 0);
  }

  /// `offset`=-1时以周日起始
  DateTime endOfWeek([int offset = 0]) {
    return DateTime(
        year, month, day + 7 + offset - weekday, 23, 59, 59, 999, 0);
  }

  DateTime startOfMonth() {
    return DateTime(year, month, 1, 0, 0, 0, 0, 0);
  }

  DateTime endOfMonth() {
    int endDay = 31;
    if (month == 2) {
      if ((year % 400 == 0) || (year % 100 != 0 && year % 4 == 0)) {
        endDay = 29;
      } else {
        endDay = 28;
      }
    } else if ([4, 6, 9, 11].contains(month)) {
      endDay = 30;
    }
    return DateTime(year, month, endDay, 23, 59, 59, 999, 0);
  }
}

extension IntExt on int {
  String toHex([int length = 2]) => toRadixString(16).padLeft(length, '0');
}

extension ColorExt on Color {
  String toRgb([String typeName = 'Color']) =>
      '$typeName(${(r * 255).toInt()},${(g * 255).toInt()},${(b * 255).toInt()})';
  String toHex([String prefix = '#']) =>
      '$prefix${(r * 255).toInt().toHex(2)}${(g * 255).toInt().toHex(2)}${(b * 255).toInt().toHex(2)}';
}
