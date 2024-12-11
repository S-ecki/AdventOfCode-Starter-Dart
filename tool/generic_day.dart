import 'dart:async';

import 'package:meta/meta.dart';
import 'package:timing/timing.dart';

import '../utils/input_util.dart';

typedef SolveFunction = FutureOr<int> Function();
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
  FutureOr<int> solvePart1();
  FutureOr<int> solvePart2();

  FutureOr<void> printSolutions() async {
    final results = await Future.wait([
      _solveAndTrackTime(solvePart1),
      _solveAndTrackTime(solvePart2),
    ]);

    final result1 = results[0];
    final result2 = results[1];

    print('-------------------------');
    print('         Day $day        ');
    print('Solution for part one: ${_formatResult(result1)}');
    print('Solution for part two: ${_formatResult(result2)}');
    print('\n');
  }

  Future<SolutionWithDuration> _solveAndTrackTime(SolveFunction solve) async {
    final tracker = AsyncTimeTracker();
    final int solution = await tracker.track(solve);
    return (solution, tracker.duration);
  }

  String _formatResult(SolutionWithDuration result) {
    final (solution, duration) = result;
    return '$solution - Took ${duration.inMilliseconds} milliseconds';
  }
}
