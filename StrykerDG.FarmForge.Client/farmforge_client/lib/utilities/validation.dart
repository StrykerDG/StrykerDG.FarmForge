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
    print('Validating: $value');
    return DateTime.tryParse(value) == null
      ? 'Invalid Date'
      : null;
  }

  static String isValidDateRange(String value) {
    bool validRange = false;

    if(value != null) {
      List<String> stringParts = value.split(" - ");
      List<bool> dateValidity = List<bool>();

      stringParts.forEach((date) { 
        bool valid = DateTime.tryParse(date) == null
          ? false
          : true;

        dateValidity.add(valid);
      });

      int validDates = dateValidity
        .where((item) => item == true)
        .length;

      if(validDates == stringParts.length)
        validRange = true;
    }

    return validRange == true
      ? null
      : 'Invalid Date Range';
  }
}