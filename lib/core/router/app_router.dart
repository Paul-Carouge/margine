import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_product/add_product_screen.dart';
import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

/// No bottom nav. Simple push-based navigation.
///
/// Routes:
///   /                           — Home (L'Atelier)
///   /article/ajouter            — Ajouter un article
///   /article/:id/modifier       — Modifier un article
///   /analytics                  — Statistiques
///   /settings                   — Paramètres
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/article/ajouter',
      pageBuilder: (context, state) => _slideUp(
        const AddProductScreen(),
        state,
      ),
    ),
    GoRoute(
      path: '/article/:id/modifier',
      pageBuilder: (context, state) => _slideUp(
        AddProductScreen(
          productId: int.parse(state.pathParameters['id']!),
        ),
        state,
      ),
    ),
    GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) => _slideUp(
        const AnalyticsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => _slideUp(
        const SettingsScreen(),
        state,
      ),
    ),
  ],
);

/// Apple-style slide-up transition for push routes.
Page<Object> _slideUp(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        )),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
