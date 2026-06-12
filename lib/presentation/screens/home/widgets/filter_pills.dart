import 'package:flutter/material.dart';

import '../../../../core/theme/forge_colors.dart';

/// Horizontal scrollable filter pills.
///
/// Forge v3.0 design:
///   - Pill shape: 20px radius
///   - Inactive: Surface background, Text Secondary
///   - Active: Primary Container background, Primary text
///   - 200ms AnimatedContainer
class FilterPills extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const FilterPills({super.key, required this.current, required this.onChanged});

  static const _filters = [
    ('all', 'Tout'),
    ('bought', 'Stock'),
    ('listed', 'En ligne'),
    ('sold', 'Vendu'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((f) {
          final isSelected = current == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(f.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : ForgeColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : ForgeColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
