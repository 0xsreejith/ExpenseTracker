class NumberParser {
  static double parseDouble(String value, {double defaultValue = 0.0}) {
    return double.tryParse(value) ?? defaultValue;
  }
}
