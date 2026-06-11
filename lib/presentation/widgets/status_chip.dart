import 'package:flutter/material.dart';

/// A reusable 8dp-radius chip that displays an item's lifecycle status.
///
/// Colors follow the "Noir & Amethyst" design system v2:
/// - **bought**: teal background (#0D7377 / #38B2AC), shopping bag icon
/// - **listed**: copper background (#9C4221 / #ED8936), sell icon
/// - **sold**: emerald background (#276749 / #48BB78), check icon
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  /// One of `"bought"`, `"listed"`, or `"sold"`.
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (Color bgColor, Color textColor, Color borderColor, IconData icon, String label) =
        switch (status) {
      'sold' => (
          theme.brightness == Brightness.light
              ? const Color(0xFFE6F7EE)
              : const Color(0xFF0A2A1A),
          theme.brightness == Brightness.light
              ? const Color(0xFF276749)
              : const Color(0xFF48BB78),
          theme.brightness == Brightness.light
              ? const Color(0xFF276749).withValues(alpha: 0.3)
              : const Color(0xFF48BB78).withValues(alpha: 0.3),
          Icons.check_circle_outline,
          'Vendu',
        ),
      'listed' => (
          theme.brightness == Brightness.light
              ? const Color(0xFFFFEAD6)
              : const Color(0xFF2A1A0A),
          theme.brightness == Brightness.light
              ? const Color(0xFF9C4221)
              : const Color(0xFFED8936),
          theme.brightness == Brightness.light
              ? const Color(0xFF9C4221).withValues(alpha: 0.3)
              : const Color(0xFFED8936).withValues(alpha: 0.3),
          Icons.sell_outlined,
          'En ligne',
        ),
      _ => (
          theme.brightness == Brightness.light
              ? const Color(0xFFE6FFFB)
              : const Color(0xFF0A2A2A),
          theme.brightness == Brightness.light
              ? const Color(0xFF0D7377)
              : const Color(0xFF38B2AC),
          theme.brightness == Brightness.light
              ? const Color(0xFF0D7377).withValues(alpha: 0.3)
              : const Color(0xFF38B2AC).withValues(alpha: 0.3),
          Icons.shopping_bag_outlined,
          'Acheté',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: textColor,
              letterSpacing: 0.02,
            ),
          ),
        ],
      ),
    );
  }
}
