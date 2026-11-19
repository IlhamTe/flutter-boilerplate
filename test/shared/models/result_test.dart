import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_boilerplate/src/shared/models/result.dart';

void main() {
  String describe(Result<int> result) =>
      result.fold(onOk: (value) => 'ok $value', onError: (e) => 'error $e');

  test('fold calls onOk with the value of an Ok result', () {
    expect(describe(const Result.ok(1)), 'ok 1');
  });

  test('fold calls onError with the error of an Error result', () {
    final error = Exception('boom');
    expect(describe(Result.error(error)), 'error $error');
  });
}
