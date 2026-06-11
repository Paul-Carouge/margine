import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// 2×2 grid of key metrics — clean, typographic, no cards.
class StatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final invested = (stats['totalInvested'] as double?) ?? 0;
    final revenue = (stats['totalRevenue'] as double?) ?? 0;
    final profit = (stats['totalProfit'] as double?) ?? 0;
    final stockCount = (stats['boughtCount'] as int?) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _StatCell(label: 'Dépensé', value: '${invested.toStringAsFixed(0)} €', color: cs.onSurface)),
              const SizedBox(width: 12),
              Expanded(child: _StatCell(label: 'Gagné', value: '${revenue.toStringAsFixed(0)} €', color: MargineTheme.profitGreen)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _StatCell(
                label: 'Marge',
                value: '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} €',
                color: profit >= 0 ? MargineTheme.profitGreen : MargineTheme.lossRed,
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatCell(label: 'Stock', value: '$stockCount articles', color: cs.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(
          value,
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
