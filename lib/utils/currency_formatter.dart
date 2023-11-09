import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String addFormatting(String text, {bool isEditing = false}) {
    double value = double.parse(text);

    final formattedValue = NumberFormat.simpleCurrency(locale: "pt_BR");

    String convertedValue;

    if (isEditing) {
      convertedValue = formattedValue.format(value / 100);
    } else {
      convertedValue = formattedValue.format(value);
    }

    return convertedValue;
  }

  static String removeFormatting(String text) {
    String valueWithoutCurrency = text.replaceFirst("R\$", "");
    valueWithoutCurrency = valueWithoutCurrency.replaceAll(".", "");
    final valueWithDot = valueWithoutCurrency.replaceFirst(",", ".");

    return valueWithDot;
  }
}
