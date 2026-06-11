import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen empty state shown when the user has no items yet.
///
/// Displays the "MARGINE" wordmark in letter-spaced Sora ExtraBold style,
/// a "No items yet" message, and a call-to-action button to add the first item.
///
/// Colors follow the "Noir & Amethyst" design system v2.
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
            // Logo mark — trending up icon
            Icon(
              Icons.trending_up_rounded,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),

            // Wordmark "M A R G I N E"
            Text(
              'M A R G I N E',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 4.2,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // "Aucun article pour l'instant" heading
            Text(
              'Aucun article pour l\'instant',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Suivez vos marges Vinted.\n'
              'Ajoutez votre premier achat pour voir votre profit.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),

            // CTA button
            ElevatedButton.icon(
              onPressed: () => context.push('/items/add'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter un article'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
