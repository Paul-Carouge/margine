import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';

/// Analytics screen — enriched statistics with spacing.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final statsAsync = ref.watch(dashboardStatsProvider);
    final productsAsync = ref.watch(productsStreamProvider);
    final monthlyAsync = ref.watch(monthlyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => _exportCsv(context, ref),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) {
          final profit = (stats['totalProfit'] as double?) ?? 0;
          final invested = (stats['totalInvested'] as double?) ?? 0;
          final revenue = (stats['totalRevenue'] as double?) ?? 0;
          final count = (stats['count'] as int?) ?? 0;
          final soldCount = (stats['soldCount'] as int?) ?? 0;
          final listedCount = (stats['listedCount'] as int?) ?? 0;
          final boughtCount = (stats['boughtCount'] as int?) ?? 0;

          // ── Computed stats ──────────────────────────────────────────────────
          final roi = invested > 0 ? (profit / invested * 100) : 0.0;
          final totalFees = (stats['totalFees'] as double?) ?? 0.0;
          final avgProfit = soldCount > 0 ? profit / soldCount : 0.0;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              // ── Hero number ───────────────────────────────────────────────
              Text('Résultat net', style: tt.titleMedium?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(
                '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} €',
                style: tt.displayLarge?.copyWith(
                  color: profit >= 0 ? MargineTheme.profitGreen : MargineTheme.lossRed,
                ),
              ),
              const SizedBox(height: 24),

              // ── 4-stat row ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Ventes', value: '$soldCount', color: MargineTheme.profitGreen, cs: cs)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(label: 'En ligne', value: '$listedCount', color: MargineTheme.statusListed, cs: cs)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(label: 'En stock', value: '$boughtCount', color: cs.onSurfaceVariant, cs: cs)),
                ],
              ),
              const SizedBox(height: 10),

              // ── ROI card ───────────────────────────────────────────────────
              _HighlightCard(
                label: 'Retour sur investissement (ROI)',
                value: roi >= 0 ? '+${roi.toStringAsFixed(1)} %' : '${roi.toStringAsFixed(1)} %',
                color: roi >= 0 ? MargineTheme.profitGreen : MargineTheme.lossRed,
                sublabel: '${count} article${count > 1 ? 's' : ''} · ${invested.toStringAsFixed(0)} € investis',
                cs: cs,
              ),
              const SizedBox(height: 20),

              // ── Status breakdown donut ───────────────────────────────────
              Text('Statuts', style: tt.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sections: [
                                if (boughtCount > 0)
                                  PieChartSectionData(
                                    value: boughtCount.toDouble(),
                                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                                    radius: 50,
                                    showTitle: false,
                                  ),
                                if (listedCount > 0)
                                  PieChartSectionData(
                                    value: listedCount.toDouble(),
                                    color: MargineTheme.statusListed,
                                    radius: 50,
                                    showTitle: false,
                                  ),
                                if (soldCount > 0)
                                  PieChartSectionData(
                                    value: soldCount.toDouble(),
                                    color: MargineTheme.profitGreen,
                                    radius: 50,
                                    showTitle: false,
                                  ),
                                if (count == 0)
                                  PieChartSectionData(
                                    value: 1,
                                    color: cs.outlineVariant,
                                    radius: 50,
                                    showTitle: false,
                                  ),
                              ],
                              sectionsSpace: 2,
                              centerSpaceRadius: 48,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$count', style: tt.headlineMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w700)),
                              Text('articles', style: tt.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendDot(color: cs.onSurfaceVariant.withValues(alpha: 0.5), label: 'Stock : $boughtCount'),
                        const SizedBox(height: 8),
                        _LegendDot(color: MargineTheme.statusListed, label: 'En ligne : $listedCount'),
                        const SizedBox(height: 8),
                        _LegendDot(color: MargineTheme.profitGreen, label: 'Vendu : $soldCount'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Key figures ─────────────────────────────────────────────────
              Text('Indicateurs', style: tt.titleMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DataRow(label: 'Revenu total', value: '${revenue.toStringAsFixed(2)} €', color: MargineTheme.profitGreen),
                    const Divider(height: 20),
                    _DataRow(label: 'Total investi', value: '${invested.toStringAsFixed(2)} €', color: cs.onSurface),
                    const Divider(height: 20),
                    _DataRow(label: 'Frais totaux', value: '${totalFees.toStringAsFixed(2)} €', color: cs.onSurfaceVariant),
                    const Divider(height: 20),
                    _DataRow(label: 'Profit moyen / vente', value: '${avgProfit.toStringAsFixed(2)} €', color: MargineTheme.statusSold),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Monthly evolution ──────────────────────────────────────
              monthlyAsync.when(
                data: (monthly) {
                  if (monthly.length < 2) return const SizedBox(width: 0, height: 0);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Évolution mensuelle', style: tt.titleMedium),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: monthly.map((m) => (m['invested'] as double)).reduce((a, b) => a > b ? a : b) * 1.4,
                            barGroups: monthly.map((m) {
                              final invested = (m['invested'] as double);
                              final revenue = (m['revenue'] as double);
                              return BarChartGroupData(
                                x: m['month'] as int,
                                barRods: [
                                  BarChartRodData(
                                    toY: invested,
                                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                                    width: 10,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                  ),
                                  if (revenue > 0)
                                    BarChartRodData(
                                      toY: revenue,
                                      color: MargineTheme.profitGreen,
                                      width: 10,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                    ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final m = value.toInt();
                                    if (m < 1 || m > 12) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(_frenchMonthAbbr(m), style: tt.bodySmall?.copyWith(fontSize: 10)),
                                    );
                                  },
                                  reservedSize: 20,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) => Text(
                                    '${value.toInt()}€',
                                    style: tt.bodySmall?.copyWith(fontSize: 9),
                                  ),
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 1,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: cs.outlineVariant.withValues(alpha: 0.3),
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barTouchData: BarTouchData(enabled: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LegendDot(color: cs.onSurfaceVariant.withValues(alpha: 0.5), label: 'Investi'),
                          const SizedBox(width: 16),
                          _LegendDot(color: MargineTheme.profitGreen, label: 'Revenu'),
                        ],
                      ),
                      const SizedBox(height: 28),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // ── Best & worst margin ─────────────────────────────────────────
              productsAsync.when(
                data: (products) => _BestWorstSection(products: products, cs: cs, tt: tt),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final dao = ref.read(productDaoProvider);
    final products = await dao.getAll();
    final buffer = StringBuffer();
    buffer.writeln('Nom;Statut;Prix achat;Prix vente;Frais Vinted;Frais envoi;Frais emballage;Marge;Date achat;Date vente');
    for (final p in products) {
      final profit = p.status == 'sold' && p.salePrice != null
          ? (p.salePrice! - p.purchasePrice - p.vintedFees - p.shippingCost - p.packagingCost).toStringAsFixed(2)
          : '-';
      buffer.writeln('${p.name};${p.status};${p.purchasePrice};${p.salePrice ?? '-'};${p.vintedFees};${p.shippingCost};${p.packagingCost};$profit;${p.purchaseDate.toIso8601String()};${p.saleDate?.toIso8601String() ?? '-'}');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/letabli-export.csv');
    await file.writeAsString(buffer.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'Export L\'Établi');
    HapticFeedback.mediumImpact();
  }
  static const _months = [
    '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
    'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
  ];

  static String _frenchMonthAbbr(int m) =>
      (m >= 1 && m <= 12) ? _months[m] : '';
}

// ── Widgets ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ColorScheme cs;

  const _StatCard({required this.label, required this.value, required this.color, required this.cs});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: tt.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: tt.bodySmall),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String sublabel;
  final ColorScheme cs;

  const _HighlightCard({
    required this.label,
    required this.value,
    required this.color,
    required this.sublabel,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: tt.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(sublabel, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DataRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: tt.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: tt.titleSmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: tt.bodySmall),
      ],
    );
  }
}

class _BestWorstSection extends StatelessWidget {
  final List<Product> products;
  final ColorScheme cs;
  final TextTheme tt;

  const _BestWorstSection({
    required this.products,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    final sold = products.where((p) => p.status == 'sold' && p.salePrice != null).toList();
    if (sold.isEmpty) return const SizedBox.shrink();

    // Calculate profit for each sold product
    final withProfit = sold.map((p) {
      final profit = p.salePrice! - p.purchasePrice - p.vintedFees - p.shippingCost - p.packagingCost;
      final marginPct = p.purchasePrice > 0 ? (profit / p.purchasePrice * 100) : 0.0;
      return (product: p, profit: profit, marginPct: marginPct);
    }).toList();

    withProfit.sort((a, b) => b.marginPct.compareTo(a.marginPct));
    final best = withProfit.first;
    final worst = withProfit.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meilleures & pires marges', style: tt.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MarginCard(
                label: 'Meilleure marge',
                product: best.product,
                margin: best.marginPct,
                profit: best.profit,
                color: MargineTheme.profitGreen,
                cs: cs,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MarginCard(
                label: 'Plus faible marge',
                product: worst.product,
                margin: worst.marginPct,
                profit: worst.profit,
                color: worst.profit >= 0 ? MargineTheme.profitGreen : MargineTheme.lossRed,
                cs: cs,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MarginCard extends StatelessWidget {
  final String label;
  final Product product;
  final double margin;
  final double profit;
  final Color color;
  final ColorScheme cs;

  const _MarginCard({
    required this.label,
    required this.product,
    required this.margin,
    required this.profit,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 6),
          Text(
            '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} €',
            style: tt.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text('+${margin.toStringAsFixed(0)} %', style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(height: 4),
          Text(product.name, style: tt.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
