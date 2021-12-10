import 'dart:io';

/// Automatically reads reads the contents of the input file for given [day]. \
/// Note that file name and location must align.
class InputUtil {
  final String _inputAsString;

  InputUtil(int day) : _inputAsString = _readInputDay(day);

  static String _readInputDay(int day) {
    String dayString = day.toString().padLeft(2, '0');
    return _readInput('./input/aoc$dayString.txt');
  }

  static String _readInput(String input) {
    return File(input).readAsStringSync();
  }

  /// Returns input as one String.
  String get asString => _inputAsString;

  /// Splits the input String by `newline`.
  List<String> getPerLine() {
    return _inputAsString.split('\n');
  }

  /// Splits the input String by `whitespace` and `newline`.
  List<String> getPerWhitespace() {
    return _inputAsString.split(RegExp(r'\s\n'));
  }

  /// Splits the input String by given pattern.
  List<String> getBy(String pattern) {
    return _inputAsString.split(pattern);
  }
}
