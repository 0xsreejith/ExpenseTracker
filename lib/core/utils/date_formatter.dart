class DateFormatter {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static String format(DateTime date) {
    return "${_months[date.month - 1]} ${date.day}, ${date.year}";
  }

  static String getMonthShortName(int monthNumber) {
    if (monthNumber < 1 || monthNumber > 12) return '';
    return _months[monthNumber - 1];
  }
}
