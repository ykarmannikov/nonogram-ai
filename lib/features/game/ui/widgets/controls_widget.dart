import 'package:flutter/material.dart';
import 'package:nngram/entities/game_mode.dart';
import 'package:nngram/shared/ui/app_colors.dart';
import 'package:nngram/shared/ui/app_spacing.dart';
import 'package:nngram/shared/utils/platform_utils.dart';

/// Переключатель режима ввода: закрашивание или крест.
class ModeControls extends StatelessWidget {
  const ModeControls({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  final GameMode currentMode;
  final void Function(GameMode mode) onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ModeButton(
          selected: currentMode == GameMode.fill,
          onTap: () => onModeChanged(GameMode.fill),
          child: _FillIcon(selected: currentMode == GameMode.fill),
        ),
        const SizedBox(width: AppSpacing.m),
        _ModeButton(
          selected: currentMode == GameMode.cross,
          onTap: () => onModeChanged(GameMode.cross),
          child: _CrossIcon(selected: currentMode == GameMode.cross),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  static const double _size = 56.0;
  static const double _radius = 14.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: selected ? AppColors.filled : Colors.transparent,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: AppColors.filled, width: 2),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: PlatformUtils.isIOS ? 3 : 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _FillIcon extends StatelessWidget {
  const _FillIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? Colors.white : AppColors.filled,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _CrossIcon extends StatelessWidget {
  const _CrossIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Text(
      '✕',
      style: TextStyle(
        fontSize: 22,
        color: selected ? Colors.white : AppColors.filled,
        height: 1,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
