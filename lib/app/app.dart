import 'package:flutter/material.dart';
import 'package:nngram/app/router.dart';
import 'package:nngram/shared/theme/app_theme.dart';

/// Корневой виджет приложения.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Нонограмм',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
