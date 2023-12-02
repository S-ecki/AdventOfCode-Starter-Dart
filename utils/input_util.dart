import 'dart:io';

/// Automatically reads reads the contents of the input file for given `day`. \
/// Note that file name and location must align.
class InputUtil {
  InputUtil(int day)
      : _inputAsString = _readInputDay(day),
        _inputAsList = _readInputDayAsList(day);

  /// Reads the entire input contents as one String.
  /// This is useful for parsing the test input.
  ///
  /// Example:
  /// ```dart
  /// final input = InputUtil.fromMultiLineString('''
  /// two1nine
  /// eightwothree
  /// abcone2threexyz
  /// xtwone3four
  /// 4nineeightseven2
  /// zoneight234
  /// 7pqrstsixteen''');
  /// final lines = input.getPerLine();
  InputUtil.fromMultiLineString(String input)
      : _inputAsString = input,
        _inputAsList = input.split('\n');

  final String _inputAsString;
  final List<String> _inputAsList;

  static String _createInputPath(int day) {
    final dayString = day.toString().padLeft(2, '0');
    return './input/aoc$dayString.txt';
  }

  static String _readInputDay(int day) {
    return _readInput(_createInputPath(day));
  }

  static String _readInput(String input) {
    return File(input).readAsStringSync();
  }

  static List<String> _readInputDayAsList(int day) {
    return _readInputAsList(_createInputPath(day));
  }

  static List<String> _readInputAsList(String input) {
    return File(input).readAsLinesSync();
  }

  /// Returns input as one String.
  String get asString => _inputAsString;

  /// Reads the entire input contents as lines of text.
  List<String> getPerLine() => _inputAsList;

  /// Splits the input String by `whitespace` and `newline`.
  List<String> getPerWhitespace() {
    return _inputAsString.split(RegExp(r'\s\n'));
  }

  /// Splits the input String by given pattern.
  List<String> getBy(String pattern) {
    return _inputAsString.split(pattern);
  }
}
