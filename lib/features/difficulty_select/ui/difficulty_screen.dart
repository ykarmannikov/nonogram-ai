import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nngram/features/level_select/state/levels_provider.dart';

/// Экран выбора сложности — первый экран приложения.
class DifficultyScreen extends ConsumerWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hardUnlocked = ref.watch(hardUnlockedProvider);

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
              onTap: hardUnlocked ? () => context.push('/levels/hard') : null,
              subtitle: hardUnlocked ? null : 'Пройдите все лёгкие уровни',
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
    this.subtitle,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(label),
          style: FilledButton.styleFrom(
            minimumSize: const Size(200, 52),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ],
    );
  }
}
