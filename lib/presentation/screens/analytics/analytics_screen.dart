import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';

/// Analytics screen with monthly profit chart, category breakdown,
/// stats cards, and CSV export.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final productsAsync = ref.watch(productsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Exporter CSV',
            onPressed: () => _exportCsv(context, ref),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          return categoriesAsync.when(
            data: (categories) => products.isEmpty
                ? _buildEmptyState(theme, colorScheme)
                : _AnalyticsContent(
                    products: products,
                    categories: categories,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _buildError(e.toString(), theme),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(e.toString(), theme),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Aucune donnée à analyser',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some items and mark them as sold\nto see your analytics.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message, ThemeData theme) {
    return Center(
      child: Text('Error: $message', style: theme.textTheme.bodyLarge),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final dao = ref.read(productDaoProvider);
      final categories = await ref.read(categoryDaoProvider).getAll();
      final products = await dao.getAll();

      final buffer = StringBuffer();
      buffer.writeln('Name,Category,Purchase Price,Purchase Date,Source,'
          'Status,Listing Price,Sale Price,Sale Date,Vinted Fees,'
          'Shipping Cost,Packaging Cost,Net Profit');

      for (final p in products) {
        final cat =
            categories.where((c) => c.id == p.categoryId).firstOrNull;
        final netProfit = p.salePrice != null
            ? p.salePrice! - p.purchasePrice - p.vintedFees -
                p.shippingCost - p.packagingCost
            : 0.0;
        final dateFormat = DateFormat('yyyy-MM-dd');

        buffer.writeln(
          '"${_escapeCsv(p.name)}",'
          '"${_escapeCsv(cat?.name ?? 'Uncategorized')}",'
          '${p.purchasePrice.toStringAsFixed(2)},'
          '${dateFormat.format(p.purchaseDate)},'
          '"${_escapeCsv(p.source)}",'
          '${p.status},'
          '${p.listingPrice?.toStringAsFixed(2) ?? ''},'
          '${p.salePrice?.toStringAsFixed(2) ?? ''},'
          '${p.saleDate != null ? dateFormat.format(p.saleDate!) : ''},'
          '${p.vintedFees.toStringAsFixed(2)},'
          '${p.shippingCost.toStringAsFixed(2)},'
          '${p.packagingCost.toStringAsFixed(2)},'
          '${netProfit.toStringAsFixed(2)}',
        );
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/margine_export.csv');
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Margine Data Export',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l’export : $e')),
        );
      }
    }
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return value.replaceAll('"', '""');
    }
    return value;
  }
}

// -----------------------------------------------------------------------------
// Analytics content
// -----------------------------------------------------------------------------

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({
    required this.products,
    required this.categories,
    required this.theme,
    required this.colorScheme,
  });

  final List<Product> products;
  final List<Category> categories;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final sold = products.where((p) => p.status == 'sold').toList();
    final totalProfit = sold.fold<double>(
      0,
      (sum, p) =>
          sum + p.salePrice! - p.purchasePrice - p.vintedFees -
              p.shippingCost - p.packagingCost,
    );
    final avgProfit = sold.isNotEmpty ? totalProfit / sold.length : 0.0;
    final sellThroughRate = products.isNotEmpty
        ? (sold.length / products.length) * 100
        : 0.0;

    // Profit by category
    final profitByCategory = <int, double>{};
    for (final p in sold) {
      final profit = p.salePrice! - p.purchasePrice - p.vintedFees -
          p.shippingCost - p.packagingCost;
      profitByCategory.update(
        p.categoryId,
        (v) => v + profit,
        ifAbsent: () => profit,
      );
    }

    // Best performing category
    String bestCategory = '—';
    double bestProfit = double.negativeInfinity;
    for (final entry in profitByCategory.entries) {
      if (entry.value > bestProfit) {
        bestProfit = entry.value;
        final cat = categories.where((c) => c.id == entry.key).firstOrNull;
        bestCategory = cat?.name ?? 'Unknown';
      }
    }

    // Monthly profit (last 6 months)
    final now = DateTime.now();
    final monthlyProfits = <String, double>{};
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final key = DateFormat('MMM yyyy').format(month);
      monthlyProfits[key] = 0.0;
    }

    for (final p in sold) {
      if (p.saleDate == null) continue;
      final saleMonth = DateTime(p.saleDate!.year, p.saleDate!.month, 1);
      final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);
      if (saleMonth.isBefore(sixMonthsAgo) || saleMonth.isAfter(now)) continue;

      final profit = p.salePrice! - p.purchasePrice - p.vintedFees -
          p.shippingCost - p.packagingCost;
      final key = DateFormat('MMM yyyy').format(saleMonth);
      monthlyProfits[key] = (monthlyProfits[key] ?? 0) + profit;
    }

    final monthLabels = monthlyProfits.keys.toList();
    final monthValues = monthlyProfits.values.toList();
    final maxProfit = monthValues.fold(0.0, (a, b) => a > b ? a : b);
    final chartMax = maxProfit > 0 ? maxProfit * 1.2 : 100.0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // ── Stats Cards ─────────────────────────────────────────────────
        _StatsGrid(
          totalProfit: totalProfit,
          bestCategory: bestCategory,
          avgProfit: avgProfit,
          sellThroughRate: sellThroughRate,
          theme: theme,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 20),

        // ── Monthly Profit Chart ────────────────────────────────────────
        Text(
          'Profit mensuel',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: chartMax,
              minY: 0,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${monthLabels[group.x]}\n\u20ac${rod.toY.toStringAsFixed(2)}',
                      TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '\u20ac${value.toInt()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= monthLabels.length) {
                        return const SizedBox.shrink();
                      }
                      // Show short month label
                      final label = monthLabels[idx];
                      final short = label.split(' ').first;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          short,
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: chartMax / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(monthValues.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: monthValues[i].clamp(0, double.infinity),
                      color: colorScheme.primary,
                      width: 24,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Category Breakdown ──────────────────────────────────────────
        Text(
          'Profit par catégorie',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (profitByCategory.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Aucun article vendu à analyser par catégorie.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          )
        else
          _CategoryBreakdown(
            profitByCategory: profitByCategory,
            categories: categories,
            maxProfit: bestProfit,
            colorScheme: colorScheme,
            theme: theme,
          ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Stats cards grid
// -----------------------------------------------------------------------------

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.totalProfit,
    required this.bestCategory,
    required this.avgProfit,
    required this.sellThroughRate,
    required this.theme,
    required this.colorScheme,
  });

  final double totalProfit;
  final String bestCategory;
  final double avgProfit;
  final double sellThroughRate;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _StatCard(
                title: 'Profit total',
                value: '\u20ac${totalProfit.toStringAsFixed(2)}',
                valueColor: totalProfit >= 0
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
                icon: Icons.trending_up,
                theme: theme,
              ),
              const SizedBox(height: 8),
              _StatCard(
                title: 'Profit moyen / article',
                value: '\u20ac${avgProfit.toStringAsFixed(2)}',
                valueColor: avgProfit >= 0
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
                icon: Icons.equalizer,
                theme: theme,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _StatCard(
                title: 'Meilleure catégorie',
                value: bestCategory,
                valueColor: colorScheme.primary,
                icon: Icons.category_outlined,
                theme: theme,
              ),
              const SizedBox(height: 8),
              _StatCard(
                title: 'Taux de vente',
                value: '${sellThroughRate.toStringAsFixed(1)}%',
                valueColor: colorScheme.primary,
                icon: Icons.pie_chart_outline,
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.theme,
  });

  final String title;
  final String value;
  final Color valueColor;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: valueColor.withValues(alpha: 0.7)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Category breakdown (horizontal bars)
// -----------------------------------------------------------------------------

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({
    required this.profitByCategory,
    required this.categories,
    required this.maxProfit,
    required this.colorScheme,
    required this.theme,
  });

  final Map<int, double> profitByCategory;
  final List<Category> categories;
  final double maxProfit;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final chartColors = [
      colorScheme.primary,
      const Color(0xFFD4941A),
      const Color(0xFF6B3FA0),
      const Color(0xFF42A5F5),
      const Color(0xFFEF5350),
    ];

    final sortedEntries = profitByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(sortedEntries.length, (i) {
          final entry = sortedEntries[i];
          final catName =
              categories.where((c) => c.id == entry.key).firstOrNull?.name ??
                  'Unknown';
          final fraction = maxProfit > 0 ? entry.value / maxProfit : 0.0;
          final color = chartColors[i % chartColors.length];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      catName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\u20ac${entry.value.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: entry.value >= 0
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    backgroundColor:
                        colorScheme.outline.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
