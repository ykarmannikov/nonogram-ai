import 'package:flutter/material.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/shared/ui/app_button.dart';
import 'package:nngram/shared/ui/app_spacing.dart';

/// Панель инструментов игрового экрана.
///
/// Позволяет переключать режим (fill/cross) и сбросить поле.
class GameToolbar extends StatelessWidget {
  const GameToolbar({
    super.key,
    required this.currentMode,
    required this.onToggleMode,
    required this.onReset,
  });

  final GameMode currentMode;
  final VoidCallback onToggleMode;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final isFill = currentMode == GameMode.fill;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AppButton(
            onPressed: onToggleMode,
            icon: Icon(isFill ? Icons.grid_on : Icons.close),
            label: isFill ? 'Закрашивание' : 'Крест',
          ),
          AppButton.secondary(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            label: 'Сброс',
          ),
        ],
      ),
    );
  }
}
