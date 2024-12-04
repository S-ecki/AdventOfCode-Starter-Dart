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
  /// ```
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

  /// reads the input
  /// splits the lines into paragraphs whenever finds blank line
  /// Each outer list represents a paragraph or section
  /// Each inner list represents the lines in that section
  List<List<String>> getParagraphLines() {
    final lines = getPerLine();
    final allParagraphs = <List<String>>[];
    var paragraph = <String>[];
    for (final oneLine in lines) {
      if (oneLine.isNotEmpty) {
        paragraph.add(oneLine);
      } else {
        allParagraphs.add(paragraph);
        paragraph = <String>[];
      }
    }
    if (paragraph.isNotEmpty) {
      allParagraphs.add(paragraph);
    }
    return allParagraphs;
  }

  /// Accepts the
  /// * input from input.getPerLine()
  /// * a split character that will be used to split each line
  /// * a function called for each split that returns something of type T
  ///
  List<List<T>> perLineToCells<T>(
    List<String> lines,
    String splitChars,
    T Function(String key) theFunc,
  ) {
    return lines
        .map((e) => e.split(splitChars))
        .map(
          (e) => e
              .map(
                (f) => theFunc(f)!,
              )
              .toList(),
        ) // List<List<T>> One Row
        .toList();
  }
}
