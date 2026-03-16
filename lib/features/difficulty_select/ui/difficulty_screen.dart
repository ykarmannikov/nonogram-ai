import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Экран выбора сложности — первый экран приложения.
class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Нонограмм'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Выберите сложность',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            _DifficultyButton(
              label: 'Лёгкий',
              icon: Icons.sentiment_satisfied_alt,
              onTap: () => context.push('/levels/easy'),
            ),
            const SizedBox(height: 16),
            _DifficultyButton(
              label: 'Сложный',
              icon: Icons.sentiment_very_dissatisfied,
              onTap: () => context.push('/levels/hard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size(200, 52),
      ),
    );
  }
}
