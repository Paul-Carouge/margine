import 'package:flutter/material.dart';

import '../../../../core/theme/forge_colors.dart';

/// Stats cockpit — individual cards with icons.
///
/// Forge v3.0 design:
///   - Each card: Surface background, 20px radius, 16px padding
///   - Icon: 20px, Crimson (or Teal for profit/revenue)
///   - Value: Outfit titleLarge 18px Weight 700
///   - Label: Outfit bodySmall 12px
///   - Wrapped in two rows, 10px spacing
class StatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final invested = (stats['totalInvested'] as double?) ?? 0;
    final revenue = (stats['totalRevenue'] as double?) ?? 0;
    final profit = (stats['totalProfit'] as double?) ?? 0;
    final stockCount = (stats['boughtCount'] as int?) ?? 0;
    final listedCount = (stats['listedCount'] as int?) ?? 0;

    return Column(
      children: [
        // Row 1: En stock, En ligne, Marge (3 colonnes égales)
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.inventory_2_rounded,
                iconColor: ForgeColors.crimson,
                value: '$stockCount',
                label: 'En stock',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.store_rounded,
                iconColor: ForgeColors.teal,
                value: '$listedCount',
                label: 'En ligne',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.show_chart_rounded,
                iconColor: profit >= 0 ? ForgeColors.teal : ForgeColors.error,
                value:
                    '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} €',
                label: 'Marge',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Row 2: Dépensé, Gagné (50% chacun)
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_cart_rounded,
                iconColor: ForgeColors.crimson,
                value: '${invested.toStringAsFixed(0)} €',
                label: 'Dépensé',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up_rounded,
                iconColor: ForgeColors.teal,
                value: '${revenue.toStringAsFixed(0)} €',
                label: 'Gagné',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ForgeColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 10),
          Text(
            value,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: ForgeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: tt.bodySmall,
          ),
        ],
      ),
    );
  }
}
