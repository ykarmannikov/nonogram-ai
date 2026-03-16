import 'package:flutter/material.dart';
import 'package:nngram/entities/game_mode.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Переключатель режима
          FilledButton.icon(
            onPressed: onToggleMode,
            icon: Icon(isFill ? Icons.grid_on : Icons.close),
            label: Text(isFill ? 'Закрашивание' : 'Крест'),
          ),
          // Сброс поля
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Сброс'),
          ),
        ],
      ),
    );
  }
}
