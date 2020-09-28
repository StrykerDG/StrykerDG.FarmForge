class DateTimeUtility {
  static String formatDateTime(DateTime date) {
    if(date != null) {
      final String formattedMonth = date.month > 9
        ? date.month.toString()
        : '0${date.month}';

      final String formattedDay = date.day > 9
        ? date.day.toString()
        : '0${date.day}';

      return '${date.year}-$formattedMonth-$formattedDay';
    }
    else return "";
  }

  static String formatShortDateTime(DateTime date) {
    if(date != null) {
      return "${date.month}/${date.day}";
    }
    else return "";
  }
}