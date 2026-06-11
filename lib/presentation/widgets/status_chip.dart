import 'package:flutter/material.dart';

/// A reusable pill-shaped chip that displays an item's lifecycle status.
///
/// Colors and icons follow the design system:
/// - **bought**: blue background, shopping bag icon
/// - **listed**: orange background, sell icon
/// - **sold**: green background, check icon
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  /// One of `"bought"`, `"listed"`, or `"sold"`.
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (Color bgColor, Color textColor, IconData icon, String label) =
        switch (status) {
      'sold' => (
          theme.brightness == Brightness.light
              ? const Color(0xFFE8F5E9)
              : const Color(0xFF1A3A1A),
          theme.brightness == Brightness.light
              ? const Color(0xFF2E7D32)
              : const Color(0xFF66BB6A),
          Icons.check_circle_outline,
          'Sold',
        ),
      'listed' => (
          theme.brightness == Brightness.light
              ? const Color(0xFFFFF3E0)
              : const Color(0xFF3A1A00),
          theme.brightness == Brightness.light
              ? const Color(0xFFE65100)
              : const Color(0xFFFF8A65),
          Icons.sell_outlined,
          'Listed',
        ),
      _ => (
          theme.brightness == Brightness.light
              ? const Color(0xFFE3F2FD)
              : const Color(0xFF1A3A5C),
          theme.brightness == Brightness.light
              ? const Color(0xFF1565C0)
              : const Color(0xFF42A5F5),
          Icons.shopping_bag_outlined,
          'Bought',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
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
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
