import 'package:meta/meta.dart';
import 'package:timing/timing.dart';

import 'input_util.dart';

typedef SolveFunction = int Function();
typedef SolutionWithDuration = (int, Duration);

/// Provides the [InputUtil] for given day and a [printSolutions] method to show
/// the puzzle solutions for given day.
abstract class GenericDay {
  GenericDay(this.day) : input = InputUtil(day);
  final int day;
  InputUtil input;

  /// This setter must only be used to mutate the input of an existing day
  /// implementation for testing purposes.
  @visibleForTesting
  // ignore: avoid_setters_without_getters
  set inputForTesting(String example) =>
      input = InputUtil.fromMultiLineString(example);

  dynamic parseInput();
  int solvePart1();
  int solvePart2();

  void printSolutions() {
    final result1 = _solveAndTrackTime(solvePart1);
    final result2 = _solveAndTrackTime(solvePart2);

    print('-------------------------');
    print('         Day $day        ');
    print('Solution for puzzle one: ${_formatResult(result1)}');
    print('Solution for puzzle two: ${_formatResult(result2)}');
    print('\n');
  }

  SolutionWithDuration _solveAndTrackTime(SolveFunction solve) {
    final tracker = SyncTimeTracker();
    late final int solution;
    tracker.track(() => solution = solve());
    return (solution, tracker.duration);
  }

  String _formatResult(SolutionWithDuration result) {
    final (solution, duration) = result;
    return '$solution - Took ${duration.inMicroseconds} microseconds';
  }
}
