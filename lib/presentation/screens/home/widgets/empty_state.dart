import 'package:flutter/material.dart';

/// Empty state shown when no products match the current filter/search.
class EmptyState extends StatelessWidget {
  final String filter;
  const EmptyState({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String message;
    if (filter == 'all') {
      message = "Aucun article pour l'instant.\nAjoute ton premier achat !";
    } else {
      message = 'Aucun article dans ce statut.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: cs.outlineVariant),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
