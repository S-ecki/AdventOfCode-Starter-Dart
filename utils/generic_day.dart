import 'package:timing/timing.dart';

import 'input_util.dart';

/// Provides the [InputUtil] for given day and a [printSolutions] method to show
/// the puzzle solutions for given day.
abstract class GenericDay {
  GenericDay(this.day) : input = InputUtil(day);
  final int day;
  final InputUtil input;

  dynamic parseInput();
  int solvePart1();
  int solvePart2();

  void printSolutions() {
    final (solution1, duration1) = _solveAndTrackTime(solvePart1);
    final (solution2, duration2) = _solveAndTrackTime(solvePart2);

    print('-------------------------');
    print('         Day $day        ');
    print('Solution for puzzle one: ${_formatResult(solution1, duration1)}');
    print('Solution for puzzle two: ${_formatResult(solution2, duration2)}');
    print('\n');
  }

  (int, Duration) _solveAndTrackTime(int Function() solve) {
    final tracker = SyncTimeTracker();
    late final int solution;
    tracker.track(() => solution = solve());
    return (solution, tracker.duration);
  }

  String _formatResult(int solution, Duration duration) {
    return '$solution - Took ${duration.inMicroseconds} microseconds';
  }
}
