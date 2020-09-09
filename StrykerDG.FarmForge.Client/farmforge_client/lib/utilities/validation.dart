class Validation {
  static String isNotEmpty(String value) {
    print('validating $value');
    return value.isNotEmpty
      ? null
      : 'Cannot be empty';
  }
}