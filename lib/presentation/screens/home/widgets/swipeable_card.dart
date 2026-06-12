import 'package:flutter/material.dart';

import '../../../../core/theme/forge_colors.dart';
import '../../../../data/database/app_database.dart';
import 'product_card.dart';

/// A swipeable wrapper around [ProductCard].
///
/// Swipe endToStart to mark as sold.
/// Background: Precision Teal, check icon + "Vendu" label.
/// Confirmation: bottom sheet instead of AlertDialog.
class SwipeableCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onMarkSold;

  const SwipeableCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onMarkSold,
  });

  @override
  Widget build(BuildContext context) {
    if (product.status == 'sold') {
      return ProductCard(product: product, onTap: onTap);
    }

    return Dismissible(
      key: ValueKey('swipe_${product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 28),
        decoration: BoxDecoration(
          color: ForgeColors.teal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
            SizedBox(height: 2),
            Text('Vendu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Marquer comme vendu ?'),
                content: Text(product.name),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Annuler')),
                  FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Confirmer')),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onMarkSold(),
      child: ProductCard(product: product, onTap: onTap),
    );
  }
}
