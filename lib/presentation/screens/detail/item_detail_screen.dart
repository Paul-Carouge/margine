import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/app_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/profit_display.dart';

/// Full product detail view.
///
/// Displays all information about a tracked resale item: header, purchase/
/// listing/sale info, financial summary, cost breakdown, timeline, and
/// action buttons for editing, deleting, or progressing the item status.
class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.id});

  /// The database id of the product to display.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final productAsync = ref.watch(productByIdProvider(id));
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Détail de l\u2019article'),
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Center(
              child: Text(
                'Article introuvable',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          // Resolve category name
          final categoryName = categoriesAsync.maybeWhen(
            data: (categories) {
              final cat =
                  categories.where((c) => c.id == product.categoryId).firstOrNull;
              return cat?.name ?? 'Non catégorisé';
            },
            orElse: () => 'Non catégorisé',
          );

          return _DetailContent(
            product: product,
            categoryName: categoryName,
            theme: theme,
            colorScheme: colorScheme,
            ref: ref,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur de chargement : $e',
              style: theme.textTheme.bodyLarge),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Detail content
// -----------------------------------------------------------------------------

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.product,
    required this.categoryName,
    required this.theme,
    required this.colorScheme,
    required this.ref,
  });

  final Product product;
  final String categoryName;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final WidgetRef ref;

  void _deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer l\u2019article'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer "${product.name}" ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await ref.read(productDaoProvider).deleteProduct(product.id);
              ref.invalidate(productsStreamProvider);
              ref.invalidate(dashboardStatsProvider);
              HapticFeedback.heavyImpact();
              if (context.mounted) context.pop(); // close dialog
              if (context.mounted) context.pop(); // go back
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _markAs(Product p, String newStatus, BuildContext context) {
    ref.read(productDaoProvider).updateProduct(
          ProductsCompanion(
            id: Value(p.id),
            status: Value(newStatus),
            saleDate: newStatus == 'sold'
                ? Value(DateTime.now())
                : const Value.absent(),
            salePrice: newStatus == 'sold' && p.listingPrice != null
                ? Value(p.listingPrice!)
                : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ),
        );
    ref.invalidate(productsStreamProvider);
    ref.invalidate(dashboardStatsProvider);
    HapticFeedback.mediumImpact();
    showAppToast(context, message:
      newStatus == 'sold' ? 'Marqué comme Vendu' : 'Marqué comme En ligne',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // ── Header ──────────────────────────────────────────────────────
        _buildHeader(dateFormat),
        const SizedBox(height: 16),

        // ── Info sections ───────────────────────────────────────────────
        _SectionCard(
          theme: theme,
          children: [
            _InfoRow(
              label: product.quantity > 1
                  ? 'Prix total (x${product.quantity})'
                  : "Prix d'achat",
              value: '\u20ac${product.purchasePrice.toStringAsFixed(2)}',
            ),
            _InfoRow(
              label: 'Date d\u2019achat',
              value: dateFormat.format(product.purchaseDate),
            ),
            _InfoRow(
              label: 'Source',
              value: product.source,
            ),
            if (product.listingPrice != null)
              _InfoRow(
                label: 'Prix de vente annoncé',
                value: '\u20ac${product.listingPrice!.toStringAsFixed(2)}',
              ),
            if (product.minPrice != null)
              _InfoRow(
                label: 'Prix minimum',
                value: '\u20ac${product.minPrice!.toStringAsFixed(2)}',
              ),
            if (product.salePrice != null)
              _InfoRow(
                label: 'Prix de vente',
                value: '\u20ac${product.salePrice!.toStringAsFixed(2)}',
              ),
            if (product.saleDate != null)
              _InfoRow(
                label: 'Date de vente',
                value: dateFormat.format(product.saleDate!),
              ),
            if (product.vintedFees > 0)
              _InfoRow(
                label: 'Frais Vinted',
                value: '\u20ac${product.vintedFees.toStringAsFixed(2)}',
              ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Financial Summary ───────────────────────────────────────────
        _FinancialSummary(
          product: product,
          netProfit: netProfit,
          roi: roi,
          theme: theme,
        ),
        const SizedBox(height: 12),

        // ── Costs Breakdown ─────────────────────────────────────────────
        _CostsBreakdown(product: product, theme: theme),
        const SizedBox(height: 12),

        // ── Timeline ────────────────────────────────────────────────────
        _Timeline(
          product: product,
          dateFormat: dateFormat,
          theme: theme,
        ),
        const SizedBox(height: 20),

        // ── Action Buttons ──────────────────────────────────────────────
        _ActionButtons(
          product: product,
          onEdit: () {
            HapticFeedback.lightImpact();
            context.push('/items/edit/${product.id}');
          },
          onDelete: () {
            HapticFeedback.heavyImpact();
            _deleteProduct(context);
          },
          onMarkSold: product.status == 'listed'
              ? () {
                  HapticFeedback.mediumImpact();
                  _markAs(product, 'sold', context);
                }
              : null,
          onMarkListed: product.status == 'bought'
              ? () {
                  HapticFeedback.mediumImpact();
                  _markAs(product, 'listed', context);
                }
              : null,
          theme: theme,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildHeader(DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Category chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Status chip
            StatusChip(status: product.status),
          ],
        ),
        if (product.quantity > 1) ...[
          const SizedBox(height: 8),
          Text(
            'Quantité : ${product.quantity}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        if (product.description != null && product.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            product.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
        // Photo
        if (product.photoPath != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(product.photoPath!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ] else ...[
          const SizedBox.shrink(),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Section card wrapper
// -----------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.theme, required this.children});

  final ThemeData theme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Info row
// -----------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Financial Summary Card
// -----------------------------------------------------------------------------

class _FinancialSummary extends StatelessWidget {
  const _FinancialSummary({
    required this.product,
    required this.netProfit,
    required this.roi,
    required this.theme,
  });

  final Product product;
  final double? netProfit;
  final double? roi;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final totalInvested =
        product.purchasePrice + product.vintedFees + product.shippingCost + product.packagingCost;
    final totalRevenue = product.salePrice ?? 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (netProfit != null && netProfit! >= 0)
              ? const Color(0xFF2E7D32).withValues(alpha: 0.2)
              : const Color(0xFFC62828).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Récapitulatif financier',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),

          // Total invested & revenue
          _InfoRow(
            label: 'Total investi',
            value: '\u20ac${totalInvested.toStringAsFixed(2)}',
          ),
          if (product.salePrice != null) ...[
            const SizedBox(height: 2),
            _InfoRow(
              label: 'Revenu total',
              value: '\u20ac${totalRevenue.toStringAsFixed(2)}',
            ),
          ],

          const Divider(height: 24),

          // Net profit — large, bold
          if (netProfit != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profit net',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ProfitDisplay(
                  profit: netProfit!,
                  roi: roi,
                  compact: true,
                ),
              ],
            ),
          ] else ...[
            Text(
              'Pas encore vendu',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Costs Breakdown
// -----------------------------------------------------------------------------

class _CostsBreakdown extends StatelessWidget {
  const _CostsBreakdown({required this.product, required this.theme});

  final Product product;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final total = product.purchasePrice +
        product.vintedFees +
        product.shippingCost +
        product.packagingCost;

    return _SectionCard(
      theme: theme,
      children: [
        Text(
          'Détail des coûts',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        _InfoRow(
          label: 'Prix d\u2019achat',
          value: '\u20ac${product.purchasePrice.toStringAsFixed(2)}',
        ),
        if (product.vintedFees > 0)
          _InfoRow(
            label: 'Frais Vinted',
            value: '\u20ac${product.vintedFees.toStringAsFixed(2)}',
          ),
        if (product.shippingCost > 0)
          _InfoRow(
            label: 'Frais de port',
            value: '\u20ac${product.shippingCost.toStringAsFixed(2)}',
          ),
        if (product.packagingCost > 0)
          _InfoRow(
            label: 'Emballage',
            value: '\u20ac${product.packagingCost.toStringAsFixed(2)}',
          ),
        const Divider(height: 16),
        _InfoRow(
          label: 'Total',
          value: '\u20ac${total.toStringAsFixed(2)}',
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Timeline
// -----------------------------------------------------------------------------

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.product,
    required this.dateFormat,
    required this.theme,
  });

  final Product product;
  final DateFormat dateFormat;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chronologie',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),

          // Bought
          _TimelineStep(
            icon: Icons.shopping_bag_outlined,
            iconColor: const Color(0xFF0D7377),
            iconBgColor: const Color(0xFFE6FFFB),
            label: 'Acheté',
            date: dateFormat.format(product.purchaseDate),
            isLast: product.status == 'bought',
            showDivider: true,
            theme: theme,
          ),

          // Listed
          if (product.listingPrice != null ||
              product.status == 'listed' ||
              product.status == 'sold')
            _TimelineStep(
              icon: Icons.sell_outlined,
              iconColor: const Color(0xFF9C4221),
              iconBgColor: const Color(0xFFFFEAD6),
              label: 'En ligne',
              date: product.listingPrice != null
                  ? '\u20ac${product.listingPrice!.toStringAsFixed(2)}'
                  : '—',
              isLast: product.status == 'listed',
              showDivider: product.status == 'sold',
              theme: theme,
            ),

          // Sold
          if (product.status == 'sold')
            _TimelineStep(
              icon: Icons.check_circle_outlined,
              iconColor: const Color(0xFF276749),
              iconBgColor: const Color(0xFFE6F7EE),
              label: 'Vendu',
              date: product.saleDate != null
                  ? dateFormat.format(product.saleDate!)
                  : '—',
              isLast: true,
              showDivider: false,
              theme: theme,
            ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.date,
    required this.isLast,
    required this.showDivider,
    required this.theme,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String date;
  final bool isLast;
  final bool showDivider;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isActive = isLast;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + divider line
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              if (showDivider)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Label + date
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showDivider ? 8.0 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Inter',
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Action buttons
// -----------------------------------------------------------------------------

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.onMarkSold,
    this.onMarkListed,
    required this.theme,
    required this.colorScheme,
  });

  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMarkSold;
  final VoidCallback? onMarkListed;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mark as Listed / Sold
        if (onMarkListed != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton.icon(
              onPressed: onMarkListed,
              icon: const Icon(Icons.sell_outlined, size: 18),
              label: const Text('Mettre en ligne'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C4221),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        if (onMarkSold != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton.icon(
              onPressed: onMarkSold,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Marquer comme vendu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF276749),
                foregroundColor: Colors.white,
              ),
            ),
          ),

        // Edit
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Modifier'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.primary),
            ),
          ),
        ),

        // Delete
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Supprimer'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFC62828),
          ),
        ),
      ],
    );
  }
}
