import 'package:flutter_test/flutter_test.dart';

import 'package:benefits_mvp/utils/validators.dart';
import 'package:benefits_mvp/utils/card_utils.dart';

void main() {
  group('validators', () {
    test('validateEmail rejects empty', () {
      expect(validateEmail(''), isNotNull);
    });

    test('validateEmail accepts valid email', () {
      expect(validateEmail('test@example.com'), isNull);
    });

    test('validatePassword rejects short', () {
      expect(validatePassword('12345'), isNotNull);
    });

    test('validatePassword accepts 6+ chars', () {
      expect(validatePassword('123456'), isNull);
    });

    test('validateCardNumber rejects short', () {
      expect(validateCardNumber('1234'), isNotNull);
    });

    test('validateCardNumber accepts 16 digits', () {
      expect(validateCardNumber('4111111111111111'), isNull);
    });

    test('validateCvv rejects 2 digits', () {
      expect(validateCvv('12'), isNotNull);
    });

    test('validateCvv accepts 3 digits', () {
      expect(validateCvv('123'), isNull);
    });
  });

  group('card_utils', () {
    test('inferCardBrand detects VISA', () {
      expect(inferCardBrand('4111111111111111'), 'VISA');
    });

    test('inferCardBrand detects AMEX', () {
      expect(inferCardBrand('341111111111111'), 'AMEX');
    });

    test('inferCardBrand detects MC', () {
      expect(inferCardBrand('5111111111111111'), 'MC');
    });

    test('getLast4 returns last 4 digits', () {
      expect(getLast4('4111111111111111'), '1111');
    });
  });
}
