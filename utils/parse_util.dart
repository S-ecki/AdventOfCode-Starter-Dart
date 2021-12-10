class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> strings) {
    return strings.map((s) => int.parse(s)).toList();
  }

  /// Returns a decimal number from binary string. \
  /// Throws an exception if this is not possible.
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }
}
