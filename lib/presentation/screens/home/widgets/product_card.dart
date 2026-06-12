import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/forge_colors.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../data/database/app_database.dart';
import '../../../../presentation/providers/app_providers.dart';

/// A full-width product card with photo background and Graphite overlay.
///
/// Forge v3.0 design:
///   - 220px height (was 200px)
///   - Overlay gradient: transparent → Bg (#15151C) at 70%
///   - Name in DM Serif Display 17px
///   - Status badges: Crimson/Teal/Outline
///   - Shadow: single, 16px blur, Bg at 40% opacity
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final profit = profitFor(product);
    final isProfitable = profit >= 0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cs.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: ForgeColors.bg.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Photo or placeholder ──────────────────────────────────────
            if (product.photoPath != null && product.photoPath!.isNotEmpty)
              Image.file(
                File(product.photoPath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _GradientBg(),
              )
            else
              const _GradientBg(),

            // ── Graphite scrim gradient ───────────────────────────────────
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xB315151C), // #15151C at 70% opacity
                    ],
                  ),
                ),
              ),
            ),

            // ── Content overlay ──────────────────────────────────────────
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _StatusBadge(status: product.status),
                      if (product.quantity > 1) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'x${product.quantity}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (product.status == 'sold')
                        Text(
                          '${isProfitable ? '+' : ''}${profit.toStringAsFixed(0)} €',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isProfitable
                                ? ForgeColors.teal
                                : ForgeColors.error,
                            letterSpacing: -0.5,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DM Serif Display',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Acheté ${product.purchasePrice.toStringAsFixed(0)} € · ${FormatDate.short(product.purchaseDate)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ── Top-right price if not sold ──────────────────────────────
            if (product.status != 'sold')
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ForgeColors.bg.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${product.purchasePrice.toStringAsFixed(0)} €',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GradientBg extends StatelessWidget {
  const _GradientBg();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ForgeColors.surface,
            Color(0x1AC0392B), // crimson at 10% opacity
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      'bought' => (
          'Stock',
          ForgeColors.surface.withValues(alpha: 0.6),
          const Color(0xFFF0EDE5)
        ),
      'listed' => (
          'En ligne',
          ForgeColors.crimsonContainer,
          ForgeColors.crimson
        ),
      'sold' => (
          'Vendu',
          ForgeColors.tealContainer,
          ForgeColors.teal
        ),
      _ => ('', Colors.grey, Colors.white),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
