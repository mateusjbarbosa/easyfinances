import 'package:flutter/material.dart';

enum ButtonType { accent, primary, secondary }

class Button extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final ButtonType type;

  const Button({
    required this.onPressed,
    required this.text,
    this.type = ButtonType.primary,
    super.key,
  });

  Color? getButtonColor() {
    switch (type) {
      case ButtonType.accent:
        return Colors.amber[600];
      case ButtonType.primary:
        return Colors.amber[900];
      case ButtonType.secondary:
        return Colors.white;
      default:
        throw "ButtonType is invalid";
    }
  }

  Color? getTextColor() {
    switch (type) {
      case ButtonType.accent:
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return Colors.amber[900];
      default:
        throw "ButtonType is invalid";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: getButtonColor()),
      child: Text(
        text,
        style: TextStyle(color: getTextColor()),
      ),
    );
  }
}
