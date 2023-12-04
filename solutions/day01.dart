import '../utils/index.dart';

/// Every day should extend [GenericDay] to have access to the corresponding
/// input and a common interface.
///
/// Naming convention is set to pad any single-digit day with `0` to have proper
/// ordering of files and correct mapping between input for days and the day
/// files.
class Day01 extends GenericDay {
  // call the superclass with an integer == today´s day
  Day01() : super(1);

  /// The [InputUtil] can be accessed through the superclass variable `input`. \
  /// There are several methods in that class that parse the input in different
  /// ways, an example is given below
  ///
  /// The return type of this is `dynamic` for [GenericDay], so you can decide
  /// on a day-to-day basis what this function should return.
  @override
  List<String> parseInput() {
    final lines = input.getPerLine();
    // exemplary usage of ParseUtil class
    return lines;
  }

  /// The `solvePartX` methods always return a int, the puzzle solution. This
  /// solution will be printed in main.
  @override
  int solvePart1() {
    final input1 = parseInput();

    return input1.map(
      (e) {
        final firstDigit = int.parse(e[e.indexOf(RegExp(r'\d'))]);
        final lastDigit = int.parse(e[e.lastIndexOf(RegExp(r'\d'))]);

        return firstDigit * 10 + lastDigit;
      },
    ).sum;
  }

  @override
  int solvePart2() {
    const patternsAsNumbers = [
      (pattern: 'one', number: 1),
      (pattern: '1', number: 1),
      (pattern: 'two', number: 2),
      (pattern: '2', number: 2),
      (pattern: 'three', number: 3),
      (pattern: '3', number: 3),
      (pattern: 'four', number: 4),
      (pattern: '4', number: 4),
      (pattern: 'five', number: 5),
      (pattern: '5', number: 5),
      (pattern: 'six', number: 6),
      (pattern: '6', number: 6),
      (pattern: 'seven', number: 7),
      (pattern: '7', number: 7),
      (pattern: 'eight', number: 8),
      (pattern: '8', number: 8),
      (pattern: 'nine', number: 9),
      (pattern: '9', number: 9),
    ];

    return parseInput().map(
      (e) {
        final patternsThatMatchOrderedByIndex = patternsAsNumbers
            .map(
              (patternAsNumber) {
                final allMatches =
                    RegExp(patternAsNumber.pattern).allMatches(e);
                return allMatches
                    .map(
                      (match) => (
                        index: match.start,
                        pattern: patternAsNumber.pattern,
                        number: patternAsNumber.number,
                      ),
                    )
                    .toList();
              },
            )
            .toList()
            .flattened
            .sorted(
              (a, b) => a.index.compareTo(b.index),
            );

        final firstDigit = patternsThatMatchOrderedByIndex.first.number;
        final lastDigit = patternsThatMatchOrderedByIndex.last.number;

        return firstDigit * 10 + lastDigit;
      },
    ).sum;
  }
}
