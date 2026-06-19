class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNumber(String? value, String fieldName) {
    final requiredError = validateRequired(value, fieldName);
    if (requiredError != null) return requiredError;

    final parsed = double.tryParse(value!);
    if (parsed == null) {
      return '$fieldName must be a valid number';
    }
    if (parsed <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }
}
