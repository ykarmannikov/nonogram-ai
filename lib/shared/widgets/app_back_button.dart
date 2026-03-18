import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nngram/shared/ui/app_colors.dart';
import 'package:nngram/shared/utils/platform_utils.dart';

/// Единая кнопка "назад" для всего приложения.
///
/// Без [onTap] автоматически вызывает [GoRouter.pop].
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: PlatformUtils.isIOS ? 3 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: AppColors.filled,
        ),
      ),
    );
  }
}
