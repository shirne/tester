import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generator', () {
    final generator = Generator();

    for (CalculationAble c in generator.random(10, 12)) {
      print('$c = ${c.result}\n');
    }
  });
}

class Generator {
  final aMap = generateAddMap();
  final sMap = generateSubtractMap();
  final mMap = generateMultiplyMap();
  final dMap = generateDivideMap();

  final rand = math.Random();

  List<CalculationAble> random(int count, int length) {
    assert(count > 0);
    final list = <CalculationAble>[];

    for (int i = 0; i < count; i++) {
      var item = generate(length, rand.nextInt(100));
      while (list.contains(item)) {
        item = generate(length, rand.nextInt(100));
      }
      list.add(item);
    }
    return list;
  }

  CalculationAble generate(int length, int result) {
    assert(length >= 2);

    Arithmetic rc = generateCalculation(result);
    Arithmetic pointer = rc;
    while (rc.length < length) {
      if (pointer.first.length == 1) {
        pointer.first = generateCalculation(pointer.first.result);
      } else if (pointer.last!.length == 1) {
        pointer.last = generateCalculation(pointer.last!.result);

        pointer = (rand.nextInt(2) == 0 ? pointer.first : pointer.last!)
            as Arithmetic;
      }
    }
    return rc;
  }

  Arithmetic generateCalculation(int result) {
    final oper = Operator.values[rand.nextInt(4)];
    final List<Calculation>? randBox;
    switch (oper) {
      case Operator.add:
        randBox = aMap[result];
        break;
      case Operator.subtract:
        randBox = sMap[result];
        break;
      case Operator.multiply:
        randBox = mMap[result];
        break;
      case Operator.divide:
        randBox = dMap[result];
        break;
    }
    if (randBox == null) {
      return generateCalculation(result);
    }
    final item = randBox[rand.nextInt(randBox.length)];
    if (rand.nextDouble() < 0.9 && (item.first == 1 || item.last == 1)) {
      return generateCalculation(result);
    }

    return randBox[rand.nextInt(randBox.length)].upgrade();
  }
}

abstract class CalculationAble {
  Operator? get oper;
  int get result;
  int get length;
}

class Arithmetic implements CalculationAble {
  Arithmetic(this.first, [this.last, this.oper])
      : assert(oper == null || last != null);

  CalculationAble first;
  CalculationAble? last;

  @override
  final Operator? oper;

  @override
  int get length => first.length + (last?.length ?? 0);

  @override
  int get result {
    int firstResult = first.result;
    int? lastResult = last?.result;

    switch (oper) {
      case Operator.add:
        return firstResult + lastResult!;
      case Operator.subtract:
        return firstResult - lastResult!;
      case Operator.multiply:
        return firstResult * lastResult!;
      case Operator.divide:
        return firstResult ~/ lastResult!;
      case null:
        return firstResult;
    }
  }

  @override
  String toString() {
    final str = StringBuffer();
    if (oper == null) {
      str.write('$first');
    } else {
      if (oper!.priority > (first.oper?.priority ?? 99)) {
        str.write('( $first )');
      } else {
        str.write('$first');
      }
      if (oper!.priority >= (last!.oper?.priority ?? 99)) {
        str.write(' ${oper!.symbol} ( $last )');
      } else {
        str.write(' ${oper!.symbol} $last');
      }
    }
    return str.toString();
  }

  @override
  int get hashCode => first.hashCode ^ oper.hashCode ^ last.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Arithmetic) return false;
    return first == other.first && oper == other.oper && last == other.last;
  }
}

enum Operator {
  add('+'),
  subtract('-'),
  multiply('*', 1),
  divide('/', 1);

  final String symbol;
  final int priority;
  const Operator(this.symbol, [this.priority = 0]);

  int compute(Calculation c) {
    switch (c.oper) {
      case Operator.add:
        return c.first + c.last!;
      case Operator.subtract:
        return c.first - c.last!;
      case Operator.multiply:
        return c.first * c.last!;
      case Operator.divide:
        return c.first ~/ c.last!;
      case null:
        return c.first;
    }
  }
}

class Calculation implements CalculationAble {
  const Calculation(this.first, [this.last, this.oper])
      : assert(oper == null || last != null);

  final int first;
  final int? last;

  @override
  final Operator? oper;

  @override
  int get length => last == null ? 1 : 2;

  @override
  int get result {
    if (oper == null) {
      return first;
    }
    switch (oper) {
      case Operator.add:
        return first + last!;
      case Operator.subtract:
        return first - last!;
      case Operator.multiply:
        return first * last!;
      case Operator.divide:
        return first ~/ last!;
      case null:
        return first;
    }
  }

  Arithmetic upgrade() {
    return Arithmetic(
      Calculation(first),
      last == null ? null : Calculation(last!),
      oper,
    );
  }

  @override
  String toString() => oper == null ? '$first' : '$first ${oper?.symbol} $last';

  @override
  int get hashCode => first.hashCode ^ oper.hashCode ^ last.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Calculation) return false;
    return first == other.first && oper == other.oper && last == other.last;
  }
}

Map<int, List<Calculation>> generateAddMap() {
  final map = <int, List<Calculation>>{};
  for (int i = 0; i < 99; i++) {
    for (int j = 0; j < 100 - i; j++) {
      var c = Calculation(i, j, Operator.add);
      map.putIfAbsent(c.result, () => <Calculation>[]).add(c);
    }
  }
  return map;
}

Map<int, List<Calculation>> generateSubtractMap() {
  final map = <int, List<Calculation>>{};
  for (int i = 0; i < 99; i++) {
    for (int j = 0; j < 100 - i; j++) {
      var c = Calculation(i + j, i, Operator.subtract);
      map.putIfAbsent(c.result, () => <Calculation>[]).add(c);
    }
  }
  return map;
}

Map<int, List<Calculation>> generateMultiplyMap() {
  final map = <int, List<Calculation>>{};
  for (int i = 1; i < 100; i++) {
    for (int j = 0; j < 100 ~/ i; j++) {
      var c = Calculation(i, j, Operator.multiply);
      map.putIfAbsent(c.result, () => <Calculation>[]).add(c);
    }
  }
  return map;
}

Map<int, List<Calculation>> generateDivideMap() {
  final map = <int, List<Calculation>>{};
  for (int i = 1; i < 100; i++) {
    for (int j = 0; j < 100 ~/ i; j++) {
      var c = Calculation(i * j, i, Operator.divide);
      map.putIfAbsent(c.result, () => <Calculation>[]).add(c);
    }
  }
  return map;
}
