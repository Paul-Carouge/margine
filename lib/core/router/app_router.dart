import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/items/items_screen.dart';
import '../../presentation/screens/items/add_edit_item_screen.dart';
import '../../presentation/screens/detail/item_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

// ---------------------------------------------------------------------------
// Shell scaffold for bottom navigation
// ---------------------------------------------------------------------------

/// Scaffold that wraps the [StatefulShellRoute] with a [BottomNavigationBar].
class _MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Statistiques',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

/// The application's [GoRouter] instance.
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _MainShell(navigationShell: navigationShell),
      branches: [
        // ── Dashboard branch ────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        // ── Items branch ────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/items',
              builder: (context, state) => const ItemsScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddEditItemScreen(),
                ),
                GoRoute(
                  path: 'edit/:id',
                  builder: (context, state) => AddEditItemScreen(
                    id: int.parse(state.pathParameters['id']!),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => ItemDetailScreen(
                    id: int.parse(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Analytics branch ────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analytics',
              builder: (context, state) => const AnalyticsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Settings (outside shell — accessed from AppBar) ──────────────────
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
