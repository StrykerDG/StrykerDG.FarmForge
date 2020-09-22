class Validation {
  static String isNotEmpty(dynamic value) {
    if(value.runtimeType == String && !value.isNotEmpty) {
      return 'Cannot be empty';
    }

    return value != null
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