class Validation {
  static String isNotEmpty(String value) {
    return value != null && value.isNotEmpty
      ? null
      : 'Cannot be empty';
  }

  static String isNumeric(String value) {
    return int.tryParse(value) == null
      ? 'Must be a number'
      : null;
  }

  static String isValidDate(String value) {
    return DateTime.tryParse(value) == null
      ? 'Invalid Date'
      : null;
  }
}