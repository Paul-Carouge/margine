import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../../data/database/app_database.dart';

/// Dashboard screen — overview of total profit, ROI, stats, and recent items.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final productsAsync = ref.watch(productsStreamProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'M A R G I N E',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 3.0,
            color: colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Triggers a re-fetch via the providers
          ref.invalidate(productsStreamProvider);
          ref.invalidate(dashboardStatsProvider);
        },
        child: productsAsync.when(
          data: (products) => statsAsync.when(
            data: (stats) => products.isEmpty
                ? _EmptyDashboard(theme: theme, colorScheme: colorScheme)
                : _DashboardContent(
                    products: products,
                    stats: stats,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorView(message: e.toString()),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(message: e.toString()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          context.push('/items/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashboard content (non-empty state)
// ---------------------------------------------------------------------------

class _DashboardContent extends StatelessWidget {
  final List<Product> products;
  final Map<String, dynamic> stats;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _DashboardContent({
    required this.products,
    required this.stats,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final totalProfit = (stats['totalProfit'] as double?) ?? 0.0;
    final count = (stats['count'] as int?) ?? 0;
    final soldCount = (stats['soldCount'] as int?) ?? 0;
    final totalInvested = (stats['totalInvested'] as double?) ?? 0.0;
    final roi = totalInvested > 0 ? (totalProfit / totalInvested) * 100 : 0.0;
    final totalQuantity = products.fold<int>(0, (sum, p) => sum + (p.quantity > 0 ? p.quantity : 1));

    // Last 5 recent items
    final recentItems = products.take(5).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      children: [
        // KPI cards row
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: 'Profit total',
                value: '\u20ac${totalProfit.toStringAsFixed(2)}',
                valueColor: totalProfit >= 0
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
                backgroundColor: totalProfit >= 0
                    ? const Color(0xFFEEF9D0)
                    : const Color(0xFFFFEBEE),
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                title: 'ROI',
                value: '${roi.toStringAsFixed(1)}%',
                valueColor: roi >= 0
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
                backgroundColor: Color(
                  roi >= 0 ? 0xFFEEF9D0 : 0xFFFFEBEE,
                ),
                icon: Icons.percent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Stats row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Articles', value: '$totalQuantity'),
              _StatItem(label: 'Vendus', value: '$soldCount'),
              _StatItem(label: 'Actifs', value: '${count - soldCount}'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Articles récents header
        Text(
          'Articles récents',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Recent items list
        if (recentItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Aucun article pour l\'instant — appuyez sur + pour ajouter.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          )
        else
          ...recentItems.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RecentItemCard(
                product: product,
                theme: theme,
                colorScheme: colorScheme,
                onTap: () => context.push('/items/${product.id}'),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// KPI Card
// ---------------------------------------------------------------------------

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final Color backgroundColor;
  final IconData icon;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: valueColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: valueColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat item (small label + value in the stats row)
// ---------------------------------------------------------------------------

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Recent item card (compact)
// ---------------------------------------------------------------------------

class _RecentItemCard extends StatelessWidget {
  final Product product;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _RecentItemCard({
    required this.product,
    required this.theme,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final netProfit = product.salePrice != null
        ? product.salePrice! -
            product.purchasePrice -
            product.vintedFees -
            product.shippingCost -
            product.packagingCost
        : null;
    final roi = netProfit != null && product.purchasePrice > 0
        ? (netProfit / product.purchasePrice) * 100
        : null;

    final statusColor = switch (product.status) {
      'sold' => const Color(0xFF2E7D32),
      'listed' => const Color(0xFFE65100),
      _ => const Color(0xFF1565C0),
    };

    final statusBgColor = switch (product.status) {
      'sold' => const Color(0xFFE8F5E9),
      'listed' => const Color(0xFFFFF3E0),
      _ => const Color(0xFFE3F2FD),
    };

    final statusLabel = switch (product.status) {
      'sold' => 'Vendu',
      'listed' => 'En ligne',
      _ => 'Acheté',
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.category_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),

            // Name + status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.quantity > 1) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'x${product.quantity}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profit / ROI
            if (netProfit != null) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\u20ac${netProfit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  if (roi != null)
                    Text(
                      '+${roi.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'monospace',
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ] else ...[
              const SizedBox(width: 8),
              Text(
                '—',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty dashboard state
// ---------------------------------------------------------------------------

class _EmptyDashboard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _EmptyDashboard({required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo mark
            Icon(
              Icons.trending_up_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun article pour l\'instant',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Suivez vos marges Vinted.\nAjoutez votre premier achat pour voir votre profit.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/items/add'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter un article'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error view
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Une erreur est survenue',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
