import 'package:go_router/go_router.dart';
import 'package:nngram/features/difficulty_select/ui/difficulty_screen.dart'
    show HomeScreen;
import 'package:nngram/features/game/ui/game_screen.dart';
import 'package:nngram/features/level_select/ui/level_select_screen.dart';

/// Конфигурация навигации приложения.
///
/// Маршруты:
/// - `/`                    → HomeScreen (главный экран с кнопкой "Играть")
/// - `/levels/:difficulty`  → LevelSelectScreen
/// - `/game`                → GameScreen (пазл передаётся через selectedPuzzleProvider)
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/levels/:difficulty',
      builder: (context, state) {
        final difficulty = state.pathParameters['difficulty']!;
        return LevelSelectScreen(difficulty: difficulty);
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
    ),
  ],
);
