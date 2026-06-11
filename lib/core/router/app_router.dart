import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/items/items_screen.dart';
import '../../presentation/screens/items/add_edit_item_screen.dart';
import '../../presentation/screens/detail/item_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/widgets/page_transition.dart';

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
        onTap: (index) {
          HapticFeedback.lightImpact();
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
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

/// The application's [GoRouter] instance with Apple-style page transitions.
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
              pageBuilder: (context, state) =>
                  slideUpPage(const DashboardScreen(), key: state.pageKey),
            ),
          ],
        ),

        // ── Items branch ────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/items',
              pageBuilder: (context, state) =>
                  slideUpPage(const ItemsScreen(), key: state.pageKey),
              routes: [
                GoRoute(
                  path: 'add',
                  pageBuilder: (context, state) =>
                      slideUpPage(const AddEditItemScreen(), key: state.pageKey),
                ),
                GoRoute(
                  path: 'edit/:id',
                  pageBuilder: (context, state) => slideUpPage(
                    AddEditItemScreen(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                    key: state.pageKey,
                  ),
                ),
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) => slideUpPage(
                    ItemDetailScreen(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                    key: state.pageKey,
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
              pageBuilder: (context, state) =>
                  slideUpPage(const AnalyticsScreen(), key: state.pageKey),
            ),
          ],
        ),
      ],
    ),

    // ── Settings (outside shell — accessed from AppBar) ──────────────────
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          slideUpPage(const SettingsScreen(), key: state.pageKey),
    ),
  ],
);
