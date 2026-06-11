import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../core/theme/app_theme.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';
import 'widgets/stats_grid.dart';
import 'widgets/product_card.dart';

/// Home screen — "L'Atelier"
///
/// A single scrollable gallery. No bottom nav, no tabs.
///   • Stats cockpit at top (2×2 big numbers)
///   • Filter pills
///   • Vertical scroll of photo-hero product cards
///   • FAB for quick add
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final filter = ref.watch(filterStatusProvider);
    final productsAsync = filter == 'all'
        ? ref.watch(productsStreamProvider)
        : ref.watch(productsByStatusProvider(filter));

    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Compact header ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          "L'Établi",
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    _IconBtn(
                      icon: Icons.bar_chart_rounded,
                      onTap: () => context.push('/analytics'),
                    ),
                    const SizedBox(width: 4),
                    _IconBtn(
                      icon: Icons.settings_rounded,
                      onTap: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Stats cockpit ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: statsAsync.when(
                  data: (s) => StatsGrid(stats: s),
                  loading: () => const SizedBox(height: 100),
                  error: (e, _) => SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Impossible de charger les stats',
                        style: textTheme.bodyMedium?.copyWith(color: cs.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Filter pills ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: FilterPills(
                  current: filter,
                  onChanged: (f) => ref.read(filterStatusProvider.notifier).state = f,
                ),
              ),
            ),

            // ── Product gallery ─────────────────────────────────────────────
            productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(filter: filter),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          index == 0 ? 0 : 0,
                          20,
                          index == products.length - 1 ? 100 : 12,
                        ),
                        child: ProductCard(
                          product: product,
                          onTap: () => _showDetail(context, product),
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Erreur : $e',
                    style: textTheme.bodyMedium?.copyWith(color: cs.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),

      // ── Full-width FAB ──────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push('/article/ajouter');
              },
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text(
                'Nouvel achat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Product product) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ProductDetailSheet(product: product),
    );
  }
}

// ── Icon button used in header ─────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 22, color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}

// ── Filter pills ────────────────────────────────────────────────────────────

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
    final cs = Theme.of(context).colorScheme;
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  f.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
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

// ── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String message;
    if (filter == 'all') {
      message = 'Aucun article pour l\'instant.\nAjoute ton premier achat !';
    } else {
      message = 'Aucun article dans ce statut.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: cs.outlineVariant),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product detail bottom sheet ─────────────────────────────────────────────

class _ProductDetailSheet extends ConsumerWidget {
  final Product product;
  const _ProductDetailSheet({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSold = product.status == 'sold';
    final profit = product.status == 'sold' && product.salePrice != null
        ? product.salePrice! - product.purchasePrice - product.vintedFees - product.shippingCost - product.packagingCost
        : 0.0;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // ── Drag handle ────────────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Photo hero ─────────────────────────────────────────────────
              if (product.photoPath != null && product.photoPath!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(product.photoPath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _PhotoPlaceholder(cs: cs),
                  ),
                )
              else
                _PhotoPlaceholder(cs: cs),
              const SizedBox(height: 20),

              // ── Name + status ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(product.name, style: tt.headlineMedium),
                    ),
                    const SizedBox(width: 12),
                    _StatusChip(status: product.status),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // ── Profit highlight ───────────────────────────────────────────
              if (isSold)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    profit >= 0
                        ? '+${profit.toStringAsFixed(0)} €'
                        : '${profit.toStringAsFixed(0)} €',
                    style: tt.displayMedium?.copyWith(
                      color: profit >= 0 ? MargineTheme.profitGreen : MargineTheme.lossRed,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ── Details grid ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _DetailRow(label: 'Acheté le', value: _fmtDate(product.purchaseDate)),
                    _DetailRow(label: 'Prix d\'achat', value: '${product.purchasePrice.toStringAsFixed(2)} €'),
                    _DetailRow(label: 'Provenance', value: product.source),
                    if (product.quantity > 1)
                      _DetailRow(label: 'Quantité', value: 'x${product.quantity}'),
                    if (product.listingPrice != null)
                      _DetailRow(label: 'Prix de vente', value: '${product.listingPrice!.toStringAsFixed(2)} €'),
                    if (isSold && product.salePrice != null) ...[
                      _DetailRow(label: 'Vendu le', value: product.saleDate != null ? _fmtDate(product.saleDate!) : '-'),
                      _DetailRow(label: 'Frais Vinted', value: '-${product.vintedFees.toStringAsFixed(2)} €'),
                      _DetailRow(label: 'Frais envoi', value: '-${product.shippingCost.toStringAsFixed(2)} €'),
                      _DetailRow(label: 'Emballage', value: '-${product.packagingCost.toStringAsFixed(2)} €'),
                    ],
                    if (product.notes != null && product.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(product.notes!, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Action buttons ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (!isSold)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _markSold(context, ref, product.id);
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 20),
                          label: const Text('Marquer comme vendu'),
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/article/${product.id}/modifier');
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Modifier'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () => _deleteProduct(context, ref, product.id),
                        icon: Icon(Icons.delete_outline, size: 18, color: cs.error),
                        label: Text('Supprimer', style: TextStyle(color: cs.error)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  void _markSold(BuildContext context, WidgetRef ref, int id) {
    final dao = ref.read(productDaoProvider);
    dao.updateProduct(ProductsCompanion(
      id: Value(id),
      status: const Value('sold'),
      saleDate: Value(DateTime.now()),
    ));
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Marqué comme vendu ✓'),
        backgroundColor: MargineTheme.profitGreen,
      ),
    );
  }

  void _deleteProduct(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              ref.read(productDaoProvider).deleteProduct(id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('Supprimer', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ── Helper widgets ──────────────────────────────────────────────────────────

class _PhotoPlaceholder extends StatelessWidget {
  final ColorScheme cs;
  const _PhotoPlaceholder({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(Icons.image_outlined, size: 48, color: cs.outlineVariant),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'bought' => ('Stock', MargineTheme.statusBought),
      'listed' => ('En ligne', MargineTheme.statusListed),
      'sold' => ('Vendu', MargineTheme.statusSold),
      _ => ('Inconnu', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
