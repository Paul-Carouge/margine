import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';

/// Full analytics page with charts and breakdowns.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              // ── Hero number ─────────────────────────────────────────────────
              Text('Résultat net', style: tt.titleMedium?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(
                '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} €',
                style: tt.displayLarge?.copyWith(
                  color: profit >= 0 ? const Color(0xFF3A8A6C) : const Color(0xFFD94A3D),
                ),
              ),
              const SizedBox(height: 24),

              // ── Mini stat row ──────────────────────────────────────────────
              Row(
                children: [
                  _MiniStat(label: 'Ventes', value: '$soldCount', color: const Color(0xFF3A8A6C), cs: cs),
                  _MiniStat(label: 'En ligne', value: '$listedCount', color: const Color(0xFF5B7FBF), cs: cs),
                  _MiniStat(label: 'En stock', value: '$boughtCount', color: cs.onSurfaceVariant, cs: cs),
                ],
              ),
              const SizedBox(height: 24),

              // ── Donut chart ────────────────────────────────────────────────
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: invested > 0 ? invested : 1,
                            color: const Color(0xFFD4A74D),
                            radius: 50,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: profit > 0 ? profit : 1,
                            color: const Color(0xFF3A8A6C),
                            radius: 50,
                            showTitle: false,
                          ),
                        ],
                        sectionsSpace: 0,
                        centerSpaceRadius: 55,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total', style: tt.bodySmall),
                        Text('${count} articles', style: tt.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // ── Legend ──────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: const Color(0xFFD4A74D), label: 'Investi ${invested.toStringAsFixed(0)} €'),
                  const SizedBox(width: 20),
                  _LegendDot(color: const Color(0xFF3A8A6C), label: 'Profit ${profit.toStringAsFixed(0)} €'),
                ],
              ),
              const SizedBox(height: 32),

              // ── Revenue breakdown ───────────────────────────────────────────
              Text('Détail', style: tt.titleMedium),
              const SizedBox(height: 12),
              _BreakdownRow(label: 'Total investi', value: '${invested.toStringAsFixed(2)} €', color: cs.onSurface),
              _BreakdownRow(label: 'Revenu total', value: '${revenue.toStringAsFixed(2)} €', color: const Color(0xFF3A8A6C)),
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
      buffer.writeln(
        '${p.name};${p.status};${p.purchasePrice};${p.salePrice ?? '-'};${p.vintedFees};${p.shippingCost};${p.packagingCost};$profit;${p.purchaseDate.toIso8601String()};${p.saleDate?.toIso8601String() ?? '-'}',
      );
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/margine-export.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles([XFile(file.path)], text: 'Export Margine');
    HapticFeedback.mediumImpact();
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ColorScheme cs;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: tt.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
            Text(label, style: tt.bodySmall),
          ],
        ),
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
        const SizedBox(width: 6),
        Text(label, style: tt.bodySmall),
      ],
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BreakdownRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: tt.bodyMedium),
          Text(value, style: tt.titleSmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}
