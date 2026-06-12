import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../../core/theme/forge_colors.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../data/database/app_database.dart';
import '../../../providers/app_providers.dart';

/// Product detail bottom sheet.
///
/// Forge v3.0 design:
///   - Sheet radius 24px
///   - Drag handle: 36×4px, Outline Strong
///   - Photo: ClipRRect 16px, 220px height
///   - Name: DM Serif Display 20px
///   - Margin: DM Serif Display 32px, Teal or Error
///   - Action buttons: Crimson primary, Outlined, TextButton Error
class ProductDetailSheet extends ConsumerWidget {
  final Product product;
  const ProductDetailSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSold = product.status == 'sold';
    final profit = product.status == 'sold' && product.salePrice != null
        ? product.salePrice! -
            product.purchasePrice -
            product.vintedFees -
            product.shippingCost -
            product.packagingCost
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // ── Drag handle ──────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ForgeColors.outlineStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Photo hero ───────────────────────────────────────────
              if (product.photoPath != null &&
                  product.photoPath!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(product.photoPath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _PhotoPlaceholder(cs: cs),
                  ),
                )
              else
                _PhotoPlaceholder(cs: cs),
              const SizedBox(height: 20),

              // ── Name + status ────────────────────────────────────────
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

              // ── Profit highlight ─────────────────────────────────────
              if (isSold)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    profit >= 0
                        ? '+${profit.toStringAsFixed(0)} €'
                        : '${profit.toStringAsFixed(0)} €',
                    style: tt.displayMedium?.copyWith(
                      color: profit >= 0
                          ? ForgeColors.teal
                          : ForgeColors.error,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ── Details grid ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _DetailRow(
                        label: 'Acheté le',
                        value: FormatDate.full(product.purchaseDate)),
                    _DetailRow(
                        label: "Prix d'achat",
                        value:
                            '${product.purchasePrice.toStringAsFixed(2)} €'),
                    _DetailRow(
                        label: 'Provenance', value: product.source),
                    if (product.quantity > 1)
                      _DetailRow(
                          label: 'Quantité',
                          value: 'x${product.quantity}'),
                    if (product.listingPrice != null)
                      _DetailRow(
                          label: 'Prix de vente',
                          value:
                              '${product.listingPrice!.toStringAsFixed(2)} €'),
                    if (isSold && product.salePrice != null) ...[
                      _DetailRow(
                          label: 'Vendu le',
                          value: product.saleDate != null
                              ? FormatDate.full(product.saleDate!)
                              : '-'),
                      _DetailRow(
                          label: 'Frais Vinted',
                          value:
                              '-${product.vintedFees.toStringAsFixed(2)} €'),
                      _DetailRow(
                          label: 'Frais envoi',
                          value:
                              '-${product.shippingCost.toStringAsFixed(2)} €'),
                      _DetailRow(
                          label: 'Emballage',
                          value:
                              '-${product.packagingCost.toStringAsFixed(2)} €'),
                    ],
                    if (product.notes != null &&
                        product.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(product.notes!,
                              style: tt.bodyMedium
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Action buttons ───────────────────────────────────────
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
                          icon: const Icon(Icons.check_circle_outline,
                              size: 20),
                          label: const Text('Marquer comme vendu'),
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                              '/article/${product.id}/modifier');
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Modifier'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () =>
                            _deleteProduct(context, ref, product.id),
                        icon: Icon(Icons.delete_outline,
                            size: 18, color: cs.error),
                        label: Text('Supprimer',
                            style: TextStyle(color: cs.error)),
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
        backgroundColor: ForgeColors.teal,
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
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              ref.read(productDaoProvider).deleteProduct(id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('Supprimer',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
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
          Text(label,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
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
      'bought' => ('Stock', ForgeColors.textSecondary),
      'listed' => ('En ligne', ForgeColors.crimson),
      'sold' => ('Vendu', ForgeColors.teal),
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
