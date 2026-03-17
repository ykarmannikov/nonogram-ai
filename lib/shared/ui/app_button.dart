import 'package:flutter/material.dart';

/// Кнопка с двумя вариантами: primary (заливка) и secondary (контур).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _secondary = false;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _secondary = true;

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool _secondary;

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? const SizedBox.shrink();
    if (_secondary) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: effectiveIcon,
        label: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: effectiveIcon,
      label: Text(label),
    );
  }
}
