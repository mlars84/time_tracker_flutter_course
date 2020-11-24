import 'package:flutter_test/flutter_test.dart';
import '../lib/app/home/job_entries/format.dart';

void main() {
  String dateTimeString;

  setUp(() {
    dateTimeString = '2020-08-12';
  });
  group('hours', () {
    test('Above zero', () {
      double hours = 10;
      expect(Format.hours(hours), '10h');
    });

    test('Zero', () {
      double hours = 0;
      expect(Format.hours(hours), '0h');
    });

    test('Below zero', () {
      double hours = -10;
      expect(Format.hours(hours), '0h');
    });

    test('Decimal value', () {
      double hours = 0.5;
      expect(Format.hours(hours), '0.5h');
    });
  });

  group('date', () {
    test('Formats DateTime as YEAR_ABBR_MONTH_DAY', () {
      expect(Format.date(DateTime.parse(dateTimeString)), 'Aug 12, 2020');
    });
  });

  group('dayOfWeek', () {
    test('Formats a DateTime string as day of week format', () {
      expect(Format.dayOfWeek(DateTime.parse(dateTimeString)), 'Wed');
    });
  });

  group('currency', () {
    test('Returns an empty string if pay param equals 0.0', () {
      double pay = 0.0;

      expect(Format.currency(pay), '');
    });

    test('Returns an empty string if pay param equals 0', () {
      double pay = 0;

      expect(Format.currency(pay), '');
    });

    test('Formats as simple currency when pay param is above 0', () {
      double pay = 25.0;

      expect(Format.currency(pay), '\$25');
    });

    test('Formats as simple negative currency when pay param is below 0', () {
      double pay = -25.0;

      expect(Format.currency(pay), '-\$25');
    });
  });
}
