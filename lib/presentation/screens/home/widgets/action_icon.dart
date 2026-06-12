import 'package:flutter/material.dart';

/// Icon button used in the home header.
///
/// Rounded, semi-transparent surface background, 22px icon.
class ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const ActionIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 22, color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}
