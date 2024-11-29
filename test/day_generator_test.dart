import 'package:test/test.dart';

import '../day_generator.dart';

void main() {
  group('DayGenerator', () {
    group('getCurrentAocDay', () {
      test('should return the current day during the aoc period', () {
        // noon December 1st CET
        final now = DateTime.parse('2024-12-08T12:00:00+0100');

        final result = getCurrentAocDay(now);

        expect(result, 8);
      });

      test('should return null if the current day is before the aoc period',
          () {
        // noon November 30th CET
        final dayBefore = DateTime.parse('2024-11-30T12:00:00+0100');
        final rightBeforeStart = DateTime.parse('2024-11-30T23:59:00-0500');

        expect(getCurrentAocDay(dayBefore), null);
        expect(getCurrentAocDay(rightBeforeStart), null);
      });

      test('should return 1 if the current day is the first day of aoc', () {
        final rightAfterStart = DateTime.parse('2024-12-01T00:01:00-0500');
        final rightBeforeNextDay = DateTime.parse('2024-12-01T23:59:00-0500');

        expect(getCurrentAocDay(rightAfterStart), 1);
        expect(getCurrentAocDay(rightBeforeNextDay), 1);
      });

      test('should return 25 if the current day is the last day of aoc', () {
        final rightAfterEnd = DateTime.parse('2024-12-25T00:01:00-0500');
        final dayAfterEnd = DateTime.parse('2024-12-26T00:01:00-0500');

        expect(getCurrentAocDay(rightAfterEnd), 25);
        expect(getCurrentAocDay(dayAfterEnd), null);
      });
    });
  });
}
