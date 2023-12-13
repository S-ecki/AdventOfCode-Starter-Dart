import '../utils/index.dart';

/// Every day should extend [GenericDay] to have access to the corresponding
/// input and a common interface.
///
/// Naming convention is set to pad any single-digit day with `0` to have proper
/// ordering of files and correct mapping between input for days and the day
/// files.
class Day00 extends GenericDay {
  // call the superclass with an integer == today´s day
  Day00() : super(0);

  /// The [InputUtil] can be accessed through the superclass variable `input`. \
  /// There are several methods in that class that parse the input in different
  /// ways, an example is given below
  ///
  /// The return type of this is `dynamic` for [GenericDay], so you can decide
  /// on a day-to-day basis what this function should return.
  @override
  List<int> parseInput() {
    final lines = input.getPerLine();
    // exemplary usage of ParseUtil class
    return ParseUtil.stringListToIntList(lines);
  }

  /// The `solvePartX` methods always return a int, the puzzle solution. This
  /// solution will be printed in main.
  @override
  int solvePart1() {
    return parseInput().reduce((value, element) => value + element);
  }

  @override
  int solvePart2() {
    return parseInput().reduce((value, element) => value * element);
  }
}
