import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../providers/app_providers.dart';
import '../../../data/database/app_database.dart';
import '../../widgets/profit_display.dart';

/// Items screen — full list of all products with filtering and swipe actions.
class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  String _selectedFilter = 'Tous';

  static const _filters = ['Tous', 'Acheté', 'En ligne', 'Vendu'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
      ),
      body: productsAsync.when(
        data: (products) {
          final filteredProducts = _selectedFilter == 'Tous'
              ? products
              : products
                  .where((p) {
                    const filterMap = {
                      'Acheté': 'bought',
                      'En ligne': 'listed',
                      'Vendu': 'sold',
                    };
                    return p.status == filterMap[_selectedFilter];
                  })
                  .toList();

          if (products.isEmpty) {
            return _EmptyItems(colorScheme: colorScheme, theme: theme);
          }

          return Column(
            children: [
              // Filter chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedFilter = filter);
                          },
                          selectedColor: colorScheme.primary.withValues(alpha: 0.2),
                          checkmarkColor: colorScheme.primary,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.4),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Items list
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          'Aucun article dans cette catégorie',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _ItemCard(
                            product: product,
                            theme: theme,
                            colorScheme: colorScheme,
                            onTap: () =>
                                context.push('/items/${product.id}'),
                            onSwipe: () => _advanceStatus(product),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
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

  /// Advance the product status: bought → listed → sold.
  Future<void> _advanceStatus(Product product) async {
    final dao = ref.read(productDaoProvider);
    final nextStatus = switch (product.status) {
      'bought' => 'listed',
      'listed' => 'sold',
      _ => 'sold',
    };

    final now = DateTime.now();

    await dao.updateProduct(
      ProductsCompanion(
        id: Value(product.id),
        status: Value(nextStatus),
        listingPrice: product.listingPrice != null
            ? Value(product.listingPrice)
            : Value.absent(),
        salePrice: nextStatus == 'sold' && product.salePrice == null
            ? Value(product.listingPrice)
            : product.salePrice != null
                ? Value(product.salePrice)
                : Value.absent(),
        saleDate: nextStatus == 'sold' && product.saleDate == null
            ? Value(now)
            : Value.absent(),
        updatedAt: Value(now),
        // Preserve existing values
        name: Value(product.name),
        description: product.description != null
            ? Value(product.description)
            : Value.absent(),
        categoryId: Value(product.categoryId),
        purchasePrice: Value(product.purchasePrice),
        purchaseDate: Value(product.purchaseDate),
        source: Value(product.source),
        minPrice: product.minPrice != null
            ? Value(product.minPrice)
            : Value.absent(),
        vintedFees: Value(product.vintedFees),
        shippingCost: Value(product.shippingCost),
        packagingCost: Value(product.packagingCost),
        notes: product.notes != null
            ? Value(product.notes)
            : Value.absent(),
        photoPath: product.photoPath != null
            ? Value(product.photoPath)
            : Value.absent(),
        createdAt: Value(product.createdAt),
      ),
    );

    if (context.mounted) {
      HapticFeedback.mediumImpact();
      final label = switch (nextStatus) {
        'listed' => 'En ligne',
        'sold' => 'Vendu',
        _ => 'Acheté',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marqué comme $label'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Item card (full card with all details)
// ---------------------------------------------------------------------------

class _ItemCard extends StatelessWidget {
  final Product product;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final VoidCallback onSwipe;

  const _ItemCard({
    required this.product,
    required this.theme,
    required this.colorScheme,
    required this.onTap,
    required this.onSwipe,
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

    final statusIcon = switch (product.status) {
      'sold' => Icons.check_circle_outline,
      'listed' => Icons.sell_outlined,
      _ => Icons.shopping_bag_outlined,
    };

    return Dismissible(
      key: ValueKey('item_${product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              'Marquer comme\\n${switch (product.status) { 'bought' => 'En ligne', 'listed' => 'Vendu', _ => 'Vendu' }}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onSwipe(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Photo Thumbnail ──────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: product.photoPath != null
                      ? Image.file(
                          File(product.photoPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _PhotoFallback(colorScheme: colorScheme),
                        )
                      : _PhotoFallback(colorScheme: colorScheme),
                ),
              ),
              const SizedBox(width: 12),

              // ── Info Column ──────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + quantity badge + status
                    Row(
                      children: [
                        Expanded(
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
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'x${product.quantity}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 12, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Details row
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Cat. #${product.categoryId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Achat : \u20ac${product.purchasePrice.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        if (product.salePrice != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            'Vente : \u20ac${product.salePrice!.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Profit / ROI section
                    if (netProfit != null) ...[
                      const SizedBox(height: 6),
                      ProfitDisplay(
                        profit: netProfit,
                        roi: roi,
                        compact: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Photo fallback ──────────────────────────────────────────────────────────

class _PhotoFallback extends StatelessWidget {
  final ColorScheme colorScheme;

  const _PhotoFallback({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: 24,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty items state
// ---------------------------------------------------------------------------

class _EmptyItems extends StatelessWidget {
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _EmptyItems({required this.colorScheme, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.5),
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
              'Suivez vos marges Vinted.\nAppuyez sur + pour ajouter votre premier article.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
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
