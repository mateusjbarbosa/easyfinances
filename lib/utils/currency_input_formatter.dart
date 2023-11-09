import 'package:easyfinances/utils/currency_formatter.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formattedValue = CurrencyFormatter.addFormatting(
      newValue.text,
      isEditing: true,
    );

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  static String removeFormatting(String formattedText) {
    return formattedText.replaceFirst("R\$", "").replaceFirst(",", ".");
  }
}
