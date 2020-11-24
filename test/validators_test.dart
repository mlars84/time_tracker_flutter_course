import 'package:flutter_test/flutter_test.dart';

import '../lib/app/sign_in/validators.dart';

void main() {
  group('NonEmptyStringValidator', () {
    test('isValid returns true when string is not empty', () {
      var validator = NonEmptyStringValidator();

      expect(validator.isValid('test'), true);
    });

    test('isValid returns false when string is empty', () {
      var validator = NonEmptyStringValidator();

      expect(validator.isValid(''), false);
    });

    test('isValid returns false when string is empty, even with spaces', () {
      var validator = NonEmptyStringValidator();

      expect(validator.isValid('   '), false);
    });

    test('isValid returns false when passed null', () {
      var validator = NonEmptyStringValidator();

      expect(validator.isValid(null), false);
    });
  });
}
