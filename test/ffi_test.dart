import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';

void setValue(Pointer<Int64> intv) {
  intv.value = 455;
}

void main() {
  test('native', () {
    final intPtr = calloc.allocate<Int64>(4);
    print(intPtr.address);
    print(intPtr.value);
    intPtr.value = 13049;
    print(intPtr.value);
    setValue(intPtr);
    print(intPtr.value);
    calloc.free(intPtr);
  });
}
