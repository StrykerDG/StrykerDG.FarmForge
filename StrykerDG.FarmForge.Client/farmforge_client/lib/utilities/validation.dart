class Validation {
  static String isNotEmpty(String value) {
    return value.isNotEmpty
      ? null
      : 'Cannot be empty';
  }
}