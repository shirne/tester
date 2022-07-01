// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutest/fundation/shop_discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutest/main.dart';

void main() {
  test('test bitwise', () {
    int a = 2;
    int b = 4;
    int c = a >>> b;
    print(c);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test('buy books', () {
    final random = Random();

    final shopDiscount =
        ShopDiscount(['book1', 'book2', 'book3', 'book4', 'book5'], 8);

    final books1 = [
      'book1',
      'book2',
      'book3',
      'book4',
      'book5',
      'book1',
      'book2',
      'book3',
    ];
    final results1 = shopDiscount.findGroups(books1);

    print('results: $results1');

    for (int i in List.generate(10, (index) => random.nextInt(15) + 1)) {
      final books = shopDiscount.randomBooks(i);
      print('books: $books');
      final results = shopDiscount.findGroups(books);
      // print(results);

      List<double> prices = results.map<double>((r) => r.total).toList();
      double minprice =
          prices.reduce((value, element) => value < element ? value : element);
      final matchedResult = results.where((e) => e.total == minprice);
      print(
          'results: ${results.length}, minprice: ${(minprice * shopDiscount.price).toStringAsFixed(2)}, '
          'result count:${prices.where((element) => element == minprice).length}\n'
          '$matchedResult\n');
    }
  });
}
