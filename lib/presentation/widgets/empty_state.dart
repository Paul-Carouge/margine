import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen empty state shown when the user has no items yet.
///
/// Displays the "MARGINE" wordmark in letter-spaced style, a "No items yet"
/// message, and a call-to-action button to add the first item.
///
/// Used on the **Dashboard** and **Items** screens.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo mark — rising arrow icon
            Icon(
              Icons.trending_up_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),

            // Wordmark "M A R G I N E"
            Text(
              'M A R G I N E',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 3.0,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // "No items yet" heading
            Text(
              'No items yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Start tracking your Vinted margins.\n'
              'Add your first purchase to see your profit.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),

            // CTA button
            ElevatedButton.icon(
              onPressed: () => context.push('/items/add'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Your First Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
