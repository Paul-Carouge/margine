import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../providers/app_providers.dart';
import '../../../data/database/app_database.dart';

/// Items screen — full list of all products with filtering and swipe actions.
class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Bought', 'Listed', 'Sold'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: productsAsync.when(
        data: (products) {
          final filteredProducts = _selectedFilter == 'All'
              ? products
              : products
                  .where((p) => p.status == _selectedFilter.toLowerCase())
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
                          'No ${_selectedFilter.toLowerCase()} items',
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
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () => context.push('/items/add'),
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
      'sold' => 'Sold',
      'listed' => 'Listed',
      _ => 'Bought',
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
              'Mark as\n${switch (product.status) { 'bought' => 'Listed', 'listed' => 'Sold', _ => 'Sold' }}',
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
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: name + status chip
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
              const SizedBox(height: 8),

              // Details row
              Row(
                children: [
                  // Category icon (placeholder)
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
                    'Bought: \u20ac${product.purchasePrice.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  if (product.salePrice != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Sold: \u20ac${product.salePrice!.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ],
              ),

              // Profit / ROI section
              if (netProfit != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF9D0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Profit: \u20ac${netProfit.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      if (roi != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF557000).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+${roi.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                              color: const Color(0xFF557000),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
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
              'No items yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your Vinted margins.\nTap + to add your first item.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/items/add'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add First Item'),
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
