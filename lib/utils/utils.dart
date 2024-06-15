class FormatUtil {
  static String formatNumberWithCommas(int number) {
    String numStr = number.toString();
    RegExp exp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = numStr.replaceAllMapped(exp, (Match m) => '${m[1]},');
    return formatted;
  }

  static String formatNumberWithDecimals(double number) {
    List<String> parts = number.toString().split('.');
    String numStr = parts[0];
    RegExp exp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = numStr.replaceAllMapped(exp, (Match m) => '${m[1]},');
    return parts.length > 1 ? '$formatted.${parts[1]}' : formatted;
  }
}
